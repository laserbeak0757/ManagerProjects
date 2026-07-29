param(
    [string]$ParentName = "Plataforma Agentes",
    [string]$ParentIdentifier = "plataforma-agentes"
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

$agents = @(
    @{ Name = "NEXO BFF Downstream"; Identifier = "nexo-bff-downstream" },
    @{ Name = "NEXO DB Analysis"; Identifier = "nexo-db-analysis" },
    @{ Name = "NEXO MS From Table"; Identifier = "nexo-ms-from-table" },
    @{ Name = "NEXO Postman and QA Pack"; Identifier = "nexo-postman-qa-pack" },
    @{ Name = "NEXO Requerimiento Analisis"; Identifier = "nexo-requerimiento-analisis" },
    @{ Name = "Explore"; Identifier = "explore-agent" },
    @{ Name = "FabricAdmin"; Identifier = "fabricadmin" },
    @{ Name = "FabricAppDev"; Identifier = "fabricappdev" },
    @{ Name = "FabricDataEngineer"; Identifier = "fabricdataengineer" },
    @{ Name = "FabricIQ"; Identifier = "fabriciq-agent" },
    @{ Name = "genpage-planner"; Identifier = "genpage-planner" },
    @{ Name = "genpage-entity-builder"; Identifier = "genpage-entity-builder" },
    @{ Name = "genpage-page-builder"; Identifier = "genpage-page-builder" },
    @{ Name = "genpage-edit-planner"; Identifier = "genpage-edit-planner" },
    @{ Name = "genpage-connector-builder"; Identifier = "genpage-connector-builder" }
)

$json = $agents | ConvertTo-Json -Compress
$jsonEscaped = $json.Replace("'", "''")
$parentNameEscaped = $ParentName.Replace("'", "''")
$parentIdentifierEscaped = $ParentIdentifier.Replace("'", "''")

$ruby = @"
require 'json'

agents = JSON.parse('$jsonEscaped')
parent_name = '$parentNameEscaped'
parent_identifier = '$parentIdentifierEscaped'

admin = User.find_by(login: 'admin') || User.admin.first
raise 'No se encontro usuario administrador' unless admin

workspace_type = Project.first&.workspace_type || 'project'

parent = Project.find_by(identifier: parent_identifier)
unless parent
  parent = Project.new(
    name: parent_name,
    identifier: parent_identifier,
    active: true,
    public: false,
    workspace_type: workspace_type
  )
  parent.save!
  puts "PARENT_CREATED:#{parent.id}:#{parent.name}:#{parent.identifier}"
else
  puts "PARENT_EXISTS:#{parent.id}:#{parent.name}:#{parent.identifier}"
end

epic_type = Type.find_by(name: 'Epic') || Type.find_by(name: 'Feature') || Type.first
feature_type = Type.find_by(name: 'Feature') || Type.find_by(name: 'Task') || Type.first
status_new = Status.find_by(is_default: true) || Status.find_by(name: 'New') || Status.first
priority_default = Enumeration.where(type: 'IssuePriority').find_by(is_default: true) || Enumeration.where(type: 'IssuePriority').first

raise 'No hay tipos para crear backlog' unless epic_type && feature_type
raise 'No hay estados para crear backlog' unless status_new
raise 'No hay prioridades para crear backlog' unless priority_default

created_projects = 0
existing_projects = 0
created_items = 0
existing_items = 0

agents.each do |agent|
  name = agent.fetch('Name')
  identifier = agent.fetch('Identifier')

  project = Project.find_by(identifier: identifier)
  unless project
    project = Project.new(
      name: name,
      identifier: identifier,
      parent_id: parent.id,
      active: true,
      public: false,
      workspace_type: workspace_type
    )
    project.save!
    created_projects += 1
    puts "SUBPROJECT_CREATED:#{project.id}:#{project.name}:#{project.identifier}"
  else
    existing_projects += 1
    if project.parent_id != parent.id
      project.parent_id = parent.id
      project.save!
      puts "SUBPROJECT_RELINKED:#{project.id}:#{project.name}:#{project.identifier}"
    else
      puts "SUBPROJECT_EXISTS:#{project.id}:#{project.name}:#{project.identifier}"
    end
  end

  epic_subject = "EPIC: Implementacion base del agente #{name}"
  feature_subject = "Feature: Setup operativo inicial de #{name}"

  epic = WorkPackage.find_by(project_id: project.id, subject: epic_subject)
  unless epic
    epic = WorkPackage.new(
      project_id: project.id,
      type_id: epic_type.id,
      status_id: status_new.id,
      subject: epic_subject,
      description: "Inicializar estructura, convenciones, ownership y objetivos del agente #{name}.",
      author_id: admin.id,
      priority_id: priority_default.id
    )
    epic.save!
    created_items += 1
    puts "EPIC_CREATED:#{epic.id}:#{project.identifier}"
  else
    existing_items += 1
    puts "EPIC_EXISTS:#{epic.id}:#{project.identifier}"
  end

  feature = WorkPackage.find_by(project_id: project.id, subject: feature_subject)
  unless feature
    feature = WorkPackage.new(
      project_id: project.id,
      type_id: feature_type.id,
      status_id: status_new.id,
      subject: feature_subject,
      description: "Definir backlog inicial, checklist operativo, riesgos y evidencias de entrega para #{name}.",
      author_id: admin.id,
      priority_id: priority_default.id,
      parent_id: epic.id
    )
    feature.save!
    created_items += 1
    puts "FEATURE_CREATED:#{feature.id}:#{project.identifier}"
  else
    existing_items += 1
    puts "FEATURE_EXISTS:#{feature.id}:#{project.identifier}"
  end
end

puts "SUMMARY:created_projects=#{created_projects},existing_projects=#{existing_projects},created_items=#{created_items},existing_items=#{existing_items},parent_id=#{parent.id}"
"@

$ruby | docker compose exec -T openproject bin/rails runner -
