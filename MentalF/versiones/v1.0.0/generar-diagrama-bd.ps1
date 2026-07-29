param(
    [ValidateSet('all', 'schema', 'domain')]
    [string]$Scope = 'all',
    [string[]]$Schemas = @(),
    [string]$Domain = 'core'
)

$ErrorActionPreference = 'Stop'

$artifactVersion = '1.0.0'
$generatedAt = (Get-Date).ToString('yyyy-MM-dd HH:mm:ss')
$sourceDacpac = 'Proyectos/sip-bd-migrations/compare/source.dacpac'

$domainMap = @{
    core = @('denuncias', 'personas', 'investigacion', 'casos', 'diligencias', 'auth', 'organizacion', 'archivos', 'ubicacion')
    operativo = @('denuncias', 'casos', 'diligencias', 'investigacion', 'encargos', 'tareas')
    identidad = @('personas', 'auth', 'organizacion', 'ubicacion')
    forense = @('evidencias', 'vehiculos', 'catalogo_bienes', 'archivos')
    analitica = @('analitica', 'configuracion', 'cooperacion_int', 'migracion')
}

function Normalize-DbName([string]$name) {
    return ($name -replace '\[', '' -replace '\]', '').Trim()
}

function NodeId([string]$text) {
    return 'N_' + (($text -replace '[^A-Za-z0-9]', '_'))
}

function SafeName([string]$text) {
    return (($text -replace '[^A-Za-z0-9._-]', '_').ToLower())
}

function Get-Schema([string]$tableName) {
    return ($tableName -split '\.')[0]
}

function Write-TableDiagram(
    [string]$title,
    [string]$outPath,
    [string[]]$selectedSchemas,
    [array]$allTables,
    [array]$allFks,
    [string]$artifactVersion,
    [string]$generatedAt,
    [string]$sourceDacpac
) {
    $selectedSchemas = $selectedSchemas | ForEach-Object { $_.ToLower() } | Sort-Object -Unique

    $selectedFks = $allFks | Where-Object {
        $fromSchema = (Get-Schema $_.From).ToLower()
        $toSchema = (Get-Schema $_.To).ToLower()
        ($selectedSchemas -contains $fromSchema) -or ($selectedSchemas -contains $toSchema)
    }

    $schemaTables = $allTables | Where-Object {
        $schema = (Get-Schema $_).ToLower()
        $selectedSchemas -contains $schema
    }

    $involvedTables = @()
    foreach ($fk in $selectedFks) {
        $involvedTables += $fk.From
        $involvedTables += $fk.To
    }

    $involvedTables += $schemaTables
    $involvedTables = $involvedTables | Sort-Object -Unique

    $md = New-Object System.Collections.Generic.List[string]
    $md.Add("# $title")
    $md.Add('')
    $md.Add(("Version artefacto: {0}" -f $artifactVersion))
    $md.Add(("Generado: {0}" -f $generatedAt))
    $md.Add(("Fuente: {0}" -f $sourceDacpac))
    $md.Add(("Esquemas incluidos: {0}" -f ($selectedSchemas -join ', ')))
    $md.Add('')
    $md.Add('```mermaid')
    $md.Add('flowchart LR')

    foreach ($t in $involvedTables) {
        $md.Add(("    {0}[{1}]" -f (NodeId $t), $t))
    }

    foreach ($fk in $selectedFks) {
        $md.Add(("    {0} -->|{1}| {2}" -f (NodeId $fk.From), $fk.Name, (NodeId $fk.To)))
    }

    $md.Add('```')
    $md.Add('')
    $md.Add(("Tablas incluidas: {0}" -f $involvedTables.Count))
    $md.Add(("Relaciones incluidas: {0}" -f $selectedFks.Count))

    Set-Content -Path $outPath -Value ($md -join "`r`n") -Encoding utf8

    return [PSCustomObject]@{
        OutputPath = $outPath
        Tables = $involvedTables.Count
        Relations = $selectedFks.Count
    }
}

$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$mentalFRoot = Resolve-Path (Join-Path $scriptDir '..\..')
$tmpDir = Join-Path $mentalFRoot '.tmp_dacpac'
$sourceDacpacAbs = Join-Path (Split-Path -Parent $mentalFRoot) $sourceDacpac

if (-not (Test-Path $sourceDacpacAbs)) {
    throw "No se encontro el DACPAC en: $sourceDacpacAbs"
}

if (Test-Path $tmpDir) {
    Remove-Item -Path $tmpDir -Recurse -Force
}

New-Item -ItemType Directory -Path $tmpDir -Force | Out-Null
Copy-Item -Path $sourceDacpacAbs -Destination (Join-Path $tmpDir 'source.zip') -Force
Expand-Archive -Path (Join-Path $tmpDir 'source.zip') -DestinationPath $tmpDir -Force

$xml = New-Object xml
$xml.Load((Join-Path $tmpDir 'model.xml'))
$elementNodes = Select-Xml -Xml $xml -XPath "//*[local-name()='Element']"

$tables = @()
$fks = @()

foreach ($e in $elementNodes) {
    $node = $e.Node
    $type = $node.GetAttribute('Type')

    if ($type -eq 'SqlTable') {
        $t = Normalize-DbName $node.GetAttribute('Name')
        $tables += $t
        continue
    }

    if ($type -ne 'SqlForeignKeyConstraint') {
        continue
    }

    $fkName = Normalize-DbName $node.GetAttribute('Name')
    $defTbl = $null
    $forTbl = $null

    foreach ($rel in $node.ChildNodes) {
        if ($rel.LocalName -ne 'Relationship') {
            continue
        }

        $relName = $rel.GetAttribute('Name')
        foreach ($entry in $rel.ChildNodes) {
            foreach ($ref in $entry.ChildNodes) {
                $refName = Normalize-DbName $ref.GetAttribute('Name')
                if ($relName -eq 'DefiningTable') {
                    $defTbl = $refName
                }
                elseif ($relName -eq 'ForeignTable') {
                    $forTbl = $refName
                }
            }
        }
    }

    if ($defTbl -and $forTbl) {
        $fks += [PSCustomObject]@{
            Name = $fkName
            From = $defTbl
            To   = $forTbl
        }
    }
}

$tables = $tables | Sort-Object -Unique

$allSchemas = @()
foreach ($t in $tables) {
    $allSchemas += (Get-Schema $t).ToLower()
}
$allSchemas = $allSchemas | Sort-Object -Unique

$schemaOutDir = Join-Path $scriptDir 'salida\esquemas'
$domainOutDir = Join-Path $scriptDir 'salida\dominios'
New-Item -ItemType Directory -Path $schemaOutDir -Force | Out-Null
New-Item -ItemType Directory -Path $domainOutDir -Force | Out-Null

if ($Scope -eq 'all') {
    # 1) Mapa agregado entre esquemas
    $schemaEdges = @{}
    foreach ($fk in $fks) {
        $fromSchema = (Get-Schema $fk.From).ToLower()
        $toSchema = (Get-Schema $fk.To).ToLower()
        $key = "$fromSchema->$toSchema"
        if (-not $schemaEdges.ContainsKey($key)) {
            $schemaEdges[$key] = 0
        }
        $schemaEdges[$key]++
    }

    $schemaMd = New-Object System.Collections.Generic.List[string]
    $schemaMd.Add('# Mapa Visual: Relaciones entre Esquemas (SIP)')
    $schemaMd.Add('')
    $schemaMd.Add(("Version artefacto: {0}" -f $artifactVersion))
    $schemaMd.Add(("Generado: {0}" -f $generatedAt))
    $schemaMd.Add(("Fuente: {0}" -f $sourceDacpac))
    $schemaMd.Add('')
    $schemaMd.Add('```mermaid')
    $schemaMd.Add('flowchart LR')
    foreach ($s in $allSchemas) {
        $schemaMd.Add(("    {0}[{1}]" -f (NodeId $s), $s))
    }
    foreach ($k in ($schemaEdges.Keys | Sort-Object)) {
        $parts = $k -split '->'
        $from = $parts[0]
        $to = $parts[1]
        $count = $schemaEdges[$k]
        $schemaMd.Add(("    {0} -->|{1} FK| {2}" -f (NodeId $from), $count, (NodeId $to)))
    }
    $schemaMd.Add('```')
    $schemaMd.Add('')
    $schemaMd.Add(("Total tablas detectadas: {0}" -f $tables.Count))
    $schemaMd.Add(("Total relaciones FK detectadas: {0}" -f $fks.Count))

    Set-Content -Path (Join-Path $scriptDir 'bd-relaciones-esquemas.md') -Value ($schemaMd -join "`r`n") -Encoding utf8

    # 2) Diagrama core legado + diagrama de dominio core en salida/dominios
    $coreResult = Write-TableDiagram -title 'Mapa Visual: Tablas y Relaciones (Core SIP)' -outPath (Join-Path $scriptDir 'bd-relaciones-tablas-core.md') -selectedSchemas $domainMap.core -allTables $tables -allFks $fks -artifactVersion $artifactVersion -generatedAt $generatedAt -sourceDacpac $sourceDacpac

    $domainFile = Join-Path $domainOutDir 'core.md'
    $null = Write-TableDiagram -title 'Mapa Visual por Dominio: core' -outPath $domainFile -selectedSchemas $domainMap.core -allTables $tables -allFks $fks -artifactVersion $artifactVersion -generatedAt $generatedAt -sourceDacpac $sourceDacpac

    # 3) Generar automaticamente una lamina por cada esquema
    foreach ($schema in $allSchemas) {
        $schemaFile = Join-Path $schemaOutDir ((SafeName $schema) + '.md')
        $null = Write-TableDiagram -title ("Mapa Visual por Esquema: {0}" -f $schema) -outPath $schemaFile -selectedSchemas @($schema) -allTables $tables -allFks $fks -artifactVersion $artifactVersion -generatedAt $generatedAt -sourceDacpac $sourceDacpac
    }

    # 4) Index de dominios disponibles
    $domainIndex = New-Object System.Collections.Generic.List[string]
    $domainIndex.Add('# Dominios Disponibles')
    $domainIndex.Add('')
    foreach ($key in ($domainMap.Keys | Sort-Object)) {
        $domainIndex.Add(("- {0}: {1}" -f $key, ($domainMap[$key] -join ', ')))
    }
    Set-Content -Path (Join-Path $domainOutDir 'README.md') -Value ($domainIndex -join "`r`n") -Encoding utf8

    Write-Output 'Generados: mapa agregado, core, carpeta salida/esquemas y carpeta salida/dominios'
    Write-Output ("Tablas totales: {0}" -f $tables.Count)
    Write-Output ("FK totales: {0}" -f $fks.Count)
    Write-Output ("Tablas core: {0}" -f $coreResult.Tables)
    Write-Output ("FK core: {0}" -f $coreResult.Relations)
}
elseif ($Scope -eq 'schema') {
    if (-not $Schemas -or $Schemas.Count -eq 0) {
        throw 'Debes indicar al menos un esquema con -Schemas. Ejemplo: -Scope schema -Schemas denuncias,personas'
    }

    $normalizedSchemas = @()
    foreach ($raw in $Schemas) {
        if ($null -eq $raw) {
            continue
        }

        $parts = $raw -split ','
        foreach ($p in $parts) {
            $name = $p.ToLower().Trim()
            if (-not [string]::IsNullOrWhiteSpace($name)) {
                $normalizedSchemas += $name
            }
        }
    }
    $normalizedSchemas = $normalizedSchemas | Sort-Object -Unique
    foreach ($s in $normalizedSchemas) {
        if (-not ($allSchemas -contains $s)) {
            throw "Esquema no encontrado en el modelo: $s"
        }
    }

    foreach ($schema in $normalizedSchemas) {
        $schemaFile = Join-Path $schemaOutDir ((SafeName $schema) + '.md')
        $result = Write-TableDiagram -title ("Mapa Visual por Esquema: {0}" -f $schema) -outPath $schemaFile -selectedSchemas @($schema) -allTables $tables -allFks $fks -artifactVersion $artifactVersion -generatedAt $generatedAt -sourceDacpac $sourceDacpac
        Write-Output (("Generado esquema {0}: {1} tablas, {2} FK" -f $schema, $result.Tables, $result.Relations))
    }
}
else {
    $domainKey = $Domain.ToLower().Trim()
    if (-not $domainMap.ContainsKey($domainKey)) {
        $available = ($domainMap.Keys | Sort-Object) -join ', '
        throw "Dominio no valido: $Domain. Dominios disponibles: $available"
    }

    $schemasForDomain = $domainMap[$domainKey]
    $domainFile = Join-Path $domainOutDir ((SafeName $domainKey) + '.md')
    $result = Write-TableDiagram -title ("Mapa Visual por Dominio: {0}" -f $domainKey) -outPath $domainFile -selectedSchemas $schemasForDomain -allTables $tables -allFks $fks -artifactVersion $artifactVersion -generatedAt $generatedAt -sourceDacpac $sourceDacpac

    Write-Output (("Generado dominio {0}: {1} tablas, {2} FK" -f $domainKey, $result.Tables, $result.Relations))
}
