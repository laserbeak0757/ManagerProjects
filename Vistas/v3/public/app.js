const controlOptions = ['text', 'number', 'date', 'textarea', 'checkbox'];

const state = {
  schema: { source: 'loading', tables: [] },
  presets: [],
  screen: {
    screenName: 'Pantalla sin preset',
    sections: []
  },
  formValues: {},
  gridValues: {}
};

const dom = {
  schemaSource: document.getElementById('schemaSource'),
  tableSelect: document.getElementById('tableSelect'),
  tableInfo: document.getElementById('tableInfo'),
  schemaText: document.getElementById('schemaText'),
  screenName: document.getElementById('screenName'),
  presetSelect: document.getElementById('presetSelect'),
  sectionsContainer: document.getElementById('sectionsContainer'),
  screenText: document.getElementById('screenText'),
  previewContainer: document.getElementById('previewContainer'),
  payloadPreview: document.getElementById('payloadPreview'),
  validationList: document.getElementById('validationList')
};

function tableKey(table) {
  return `${table.schema}.${table.name}`;
}

function findTable(tableName) {
  return state.schema.tables.find((table) => tableKey(table) === tableName);
}

function normalizeField(field) {
  return {
    bind: field.bind,
    label: field.label || field.bind,
    control: field.control || 'text',
    required: Boolean(field.required),
    include: field.include !== false
  };
}

function inferControl(sqlType, fieldName) {
  const type = String(sqlType || '').toLowerCase();
  const name = String(fieldName || '').toLowerCase();

  if (type.includes('bit')) return 'checkbox';
  if (type.includes('date') || type.includes('time')) return 'date';
  if (type.includes('int') || type.includes('decimal') || type.includes('numeric') || type.includes('float') || type.includes('money')) return 'number';
  if (type.includes('max') || name.includes('observ') || name.includes('desc')) return 'textarea';
  return 'text';
}

function syncTableOptions() {
  dom.tableSelect.innerHTML = '';
  state.schema.tables.forEach((table) => {
    const option = document.createElement('option');
    option.value = tableKey(table);
    option.textContent = `${tableKey(table)} (${table.fields.length})`;
    dom.tableSelect.appendChild(option);
  });

  if (state.schema.tables.length > 0) {
    dom.tableSelect.value = dom.tableSelect.value || tableKey(state.schema.tables[0]);
  }
}

function renderTableInfo() {
  const table = findTable(dom.tableSelect.value);
  dom.tableInfo.innerHTML = '';
  if (!table) {
    dom.tableInfo.textContent = 'Sin tabla seleccionada';
    return;
  }

  table.fields.forEach((field) => {
    const item = document.createElement('div');
    item.textContent = `${field.name} (${field.type}) ${field.nullable ? 'NULL' : 'NOT NULL'}`;
    dom.tableInfo.appendChild(item);
  });
}

function syncPresets() {
  dom.presetSelect.innerHTML = '';
  const placeholder = document.createElement('option');
  placeholder.value = '';
  placeholder.textContent = 'Selecciona un preset';
  dom.presetSelect.appendChild(placeholder);

  state.presets.forEach((preset) => {
    const option = document.createElement('option');
    option.value = preset.id;
    option.textContent = `${preset.name}`;
    dom.presetSelect.appendChild(option);
  });
}

function adoptScreen(screen) {
  state.screen = structuredClone(screen);
  state.screen.sections = state.screen.sections || [];
  state.screen.sections.forEach((section) => {
    section.fields = (section.fields || []).map(normalizeField);
    section.mode = section.mode || 'form';
    section.relation = section.relation || null;
  });
  state.formValues = {};
  state.gridValues = {};
  renderAll();
}

function applyPresetById(presetId) {
  const preset = state.presets.find((item) => item.id === presetId);
  if (!preset) return;
  adoptScreen(preset.screen);
}

function syncScreenEditors() {
  dom.schemaText.value = JSON.stringify(state.schema, null, 2);
  dom.screenText.value = JSON.stringify(state.screen, null, 2);
  dom.screenName.value = state.screen.screenName || '';
}

function ensureGridRows(sectionId) {
  if (!Array.isArray(state.gridValues[sectionId])) {
    state.gridValues[sectionId] = [{}];
  }
}

function syncSectionWithTable(section) {
  const table = findTable(section.table);
  if (!table) {
    section.fields = [];
    return;
  }

  const current = new Map((section.fields || []).map((field) => [field.bind, field]));
  section.fields = table.fields.map((tableField) => {
    const previous = current.get(tableField.name);
    if (previous) {
      return {
        ...previous,
        required: previous.required || !tableField.nullable
      };
    }

    return {
      bind: tableField.name,
      label: tableField.name.replace(/_/g, ' ').replace(/\b\w/g, (ch) => ch.toUpperCase()),
      control: inferControl(tableField.type, tableField.name),
      required: !tableField.nullable,
      include: true
    };
  });
}

function createSectionCard(section, index) {
  const wrapper = document.createElement('div');
  wrapper.className = 'section-card';

  const head = document.createElement('div');
  head.className = 'section-head';

  const nameInput = document.createElement('input');
  nameInput.value = section.name;
  nameInput.addEventListener('input', () => {
    section.name = nameInput.value;
    renderPreviewAndPayload();
    syncScreenEditors();
  });

  const tableSelect = document.createElement('select');
  state.schema.tables.forEach((table) => {
    const opt = document.createElement('option');
    opt.value = tableKey(table);
    opt.textContent = tableKey(table);
    tableSelect.appendChild(opt);
  });
  tableSelect.value = section.table;
  tableSelect.addEventListener('change', () => {
    section.table = tableSelect.value;
    syncSectionWithTable(section);
    renderAll();
  });

  const modeSelect = document.createElement('select');
  ['form', 'grid'].forEach((mode) => {
    const opt = document.createElement('option');
    opt.value = mode;
    opt.textContent = mode;
    modeSelect.appendChild(opt);
  });
  modeSelect.value = section.mode;
  modeSelect.addEventListener('change', () => {
    section.mode = modeSelect.value;
    ensureGridRows(section.id);
    renderAll();
  });

  const deleteBtn = document.createElement('button');
  deleteBtn.type = 'button';
  deleteBtn.className = 'btn-secondary';
  deleteBtn.textContent = 'Quitar';
  deleteBtn.addEventListener('click', () => {
    state.screen.sections.splice(index, 1);
    delete state.formValues[section.id];
    delete state.gridValues[section.id];
    renderAll();
  });

  head.appendChild(nameInput);
  head.appendChild(tableSelect);
  head.appendChild(modeSelect);
  head.appendChild(deleteBtn);
  wrapper.appendChild(head);

  if (section.mode === 'grid') {
    const relationRow = document.createElement('div');
    relationRow.className = 'section-head';

    const parentSectionSelect = document.createElement('select');
    state.screen.sections.filter((item) => item.id !== section.id).forEach((item) => {
      const opt = document.createElement('option');
      opt.value = item.id;
      opt.textContent = item.name;
      parentSectionSelect.appendChild(opt);
    });

    const relation = section.relation || { parentSectionId: '', parentField: '', childField: '' };
    section.relation = relation;

    if (parentSectionSelect.options.length > 0) {
      parentSectionSelect.value = relation.parentSectionId || parentSectionSelect.options[0].value;
    }
    parentSectionSelect.addEventListener('change', () => {
      relation.parentSectionId = parentSectionSelect.value;
      renderAll();
    });

    const parentFieldSelect = document.createElement('select');
    const parentSection = state.screen.sections.find((item) => item.id === (parentSectionSelect.value || relation.parentSectionId));
    const parentTable = findTable(parentSection?.table);
    (parentTable?.fields || []).forEach((field) => {
      const opt = document.createElement('option');
      opt.value = field.name;
      opt.textContent = field.name;
      parentFieldSelect.appendChild(opt);
    });
    if (parentFieldSelect.options.length > 0) {
      parentFieldSelect.value = relation.parentField || parentFieldSelect.options[0].value;
    }
    parentFieldSelect.addEventListener('change', () => {
      relation.parentField = parentFieldSelect.value;
      renderAll();
    });

    const childFieldSelect = document.createElement('select');
    const childTable = findTable(section.table);
    (childTable?.fields || []).forEach((field) => {
      const opt = document.createElement('option');
      opt.value = field.name;
      opt.textContent = field.name;
      childFieldSelect.appendChild(opt);
    });
    if (childFieldSelect.options.length > 0) {
      childFieldSelect.value = relation.childField || childFieldSelect.options[0].value;
    }
    childFieldSelect.addEventListener('change', () => {
      relation.childField = childFieldSelect.value;
      renderAll();
    });

    relationRow.appendChild(parentSectionSelect);
    relationRow.appendChild(parentFieldSelect);
    relationRow.appendChild(childFieldSelect);
    wrapper.appendChild(relationRow);
  }

  const table = document.createElement('table');
  table.className = 'table';
  table.innerHTML = '<thead><tr><th>Incl.</th><th>Campo</th><th>Etiqueta</th><th>Control</th><th>Req</th></tr></thead>';
  const tbody = document.createElement('tbody');

  section.fields.forEach((field) => {
    const tr = document.createElement('tr');

    const includeTd = document.createElement('td');
    const include = document.createElement('input');
    include.type = 'checkbox';
    include.checked = field.include !== false;
    include.addEventListener('change', () => {
      field.include = include.checked;
      renderPreviewAndPayload();
    });
    includeTd.appendChild(include);

    const bindTd = document.createElement('td');
    bindTd.textContent = field.bind;

    const labelTd = document.createElement('td');
    const label = document.createElement('input');
    label.value = field.label;
    label.addEventListener('input', () => {
      field.label = label.value;
      renderPreviewAndPayload();
    });
    labelTd.appendChild(label);

    const controlTd = document.createElement('td');
    const control = document.createElement('select');
    controlOptions.forEach((option) => {
      const opt = document.createElement('option');
      opt.value = option;
      opt.textContent = option;
      control.appendChild(opt);
    });
    control.value = field.control;
    control.addEventListener('change', () => {
      field.control = control.value;
      renderPreviewAndPayload();
    });
    controlTd.appendChild(control);

    const reqTd = document.createElement('td');
    const req = document.createElement('input');
    req.type = 'checkbox';
    req.checked = Boolean(field.required);
    req.addEventListener('change', () => {
      field.required = req.checked;
      renderPreviewAndPayload();
    });
    reqTd.appendChild(req);

    tr.appendChild(includeTd);
    tr.appendChild(bindTd);
    tr.appendChild(labelTd);
    tr.appendChild(controlTd);
    tr.appendChild(reqTd);
    tbody.appendChild(tr);
  });

  table.appendChild(tbody);
  wrapper.appendChild(table);

  if (section.mode === 'grid') {
    const addRowBtn = document.createElement('button');
    addRowBtn.type = 'button';
    addRowBtn.className = 'btn-secondary';
    addRowBtn.textContent = 'Agregar fila detalle';
    addRowBtn.addEventListener('click', () => {
      ensureGridRows(section.id);
      state.gridValues[section.id].push({});
      renderPreviewAndPayload();
    });
    wrapper.appendChild(addRowBtn);
  }

  return wrapper;
}

function renderSections() {
  dom.sectionsContainer.innerHTML = '';
  state.screen.sections.forEach((section, index) => {
    syncSectionWithTable(section);
    if (section.mode === 'grid') {
      ensureGridRows(section.id);
    }
    dom.sectionsContainer.appendChild(createSectionCard(section, index));
  });
}

function renderControl(sectionId, field, rowIndex = null) {
  const control = field.control === 'textarea' ? document.createElement('textarea') : document.createElement('input');
  if (field.control !== 'textarea') {
    control.type = field.control === 'checkbox' ? 'checkbox' : field.control;
  }

  const readValue = () => {
    if (rowIndex === null) {
      return state.formValues[sectionId]?.[field.bind];
    }
    return state.gridValues[sectionId]?.[rowIndex]?.[field.bind];
  };

  const writeValue = (value) => {
    if (rowIndex === null) {
      if (!state.formValues[sectionId]) state.formValues[sectionId] = {};
      state.formValues[sectionId][field.bind] = value;
      return;
    }

    ensureGridRows(sectionId);
    state.gridValues[sectionId][rowIndex][field.bind] = value;
  };

  if (field.control === 'checkbox') {
    control.checked = Boolean(readValue());
    control.addEventListener('change', () => {
      writeValue(control.checked);
      renderPreviewAndPayload();
    });
  } else {
    control.value = readValue() ?? '';
    control.required = Boolean(field.required);
    control.addEventListener('input', () => {
      writeValue(control.value);
      renderPreviewAndPayload();
    });
  }

  return control;
}

function parseBySqlType(rawValue, sqlType, control) {
  if (control === 'checkbox') {
    return Boolean(rawValue);
  }

  if (rawValue === '' || rawValue === null || rawValue === undefined) {
    return null;
  }

  const type = String(sqlType || '').toLowerCase();

  if (type.includes('int') || type.includes('bigint') || type.includes('smallint') || type.includes('tinyint')) {
    const numeric = Number(rawValue);
    return Number.isInteger(numeric) ? numeric : Number.NaN;
  }

  if (type.includes('decimal') || type.includes('numeric') || type.includes('float') || type.includes('money')) {
    const numeric = Number(rawValue);
    return Number.isFinite(numeric) ? numeric : Number.NaN;
  }

  if (type.includes('date') || type.includes('time')) {
    const parsed = Date.parse(rawValue);
    return Number.isNaN(parsed) ? Number.NaN : rawValue;
  }

  if (type.includes('bit')) {
    return rawValue === true || rawValue === 'true' || rawValue === '1' || rawValue === 1;
  }

  return String(rawValue);
}

function buildPayloadAndValidate() {
  const payload = {
    screenName: state.screen.screenName,
    sections: {}
  };
  const errors = [];

  state.screen.sections.forEach((section) => {
    const table = findTable(section.table);
    const tableFields = new Map((table?.fields || []).map((field) => [field.name, field]));
    const included = section.fields.filter((field) => field.include !== false);

    if (section.mode === 'form') {
      const row = {};
      included.forEach((field) => {
        const sqlMeta = tableFields.get(field.bind);
        const raw = state.formValues[section.id]?.[field.bind] ?? '';
        const parsed = parseBySqlType(raw, sqlMeta?.type, field.control);

        if (field.required && (raw === '' || raw === null || raw === undefined)) {
          errors.push(`${section.name}.${field.bind}: obligatorio`);
        }

        if (Number.isNaN(parsed)) {
          errors.push(`${section.name}.${field.bind}: formato invalido para ${sqlMeta?.type || 'tipo desconocido'}`);
        } else {
          row[field.bind] = parsed;
        }
      });
      payload.sections[section.id] = row;
      return;
    }

    ensureGridRows(section.id);
    const rows = state.gridValues[section.id].map((gridRow, rowIndex) => {
      const row = {};
      included.forEach((field) => {
        const sqlMeta = tableFields.get(field.bind);
        const raw = gridRow[field.bind] ?? '';
        const parsed = parseBySqlType(raw, sqlMeta?.type, field.control);

        if (field.required && (raw === '' || raw === null || raw === undefined)) {
          errors.push(`${section.name}[${rowIndex}].${field.bind}: obligatorio`);
        }

        if (Number.isNaN(parsed)) {
          errors.push(`${section.name}[${rowIndex}].${field.bind}: formato invalido para ${sqlMeta?.type || 'tipo desconocido'}`);
        } else {
          row[field.bind] = parsed;
        }
      });

      if (section.relation?.parentSectionId && section.relation.parentField && section.relation.childField) {
        const parentPayload = payload.sections[section.relation.parentSectionId] || {};
        row[section.relation.childField] = parentPayload[section.relation.parentField] ?? row[section.relation.childField] ?? null;
      }

      return row;
    });

    payload.sections[section.id] = rows;
  });

  return { payload, errors };
}

function renderPreviewAndPayload() {
  dom.previewContainer.innerHTML = '';

  state.screen.sections.forEach((section) => {
    const box = document.createElement('div');
    box.className = 'preview-box';

    const title = document.createElement('h4');
    title.textContent = `${section.name} (${section.mode})`;
    box.appendChild(title);

    const included = section.fields.filter((field) => field.include !== false);

    if (section.mode === 'form') {
      const grid = document.createElement('div');
      grid.className = 'preview-grid';
      included.forEach((field) => {
        const item = document.createElement('div');
        const label = document.createElement('label');
        label.textContent = `${field.label}${field.required ? ' *' : ''}`;
        item.appendChild(label);
        item.appendChild(renderControl(section.id, field));
        grid.appendChild(item);
      });
      box.appendChild(grid);
    } else {
      ensureGridRows(section.id);
      const table = document.createElement('table');
      table.className = 'table';
      const thead = document.createElement('thead');
      const tr = document.createElement('tr');
      included.forEach((field) => {
        const th = document.createElement('th');
        th.textContent = field.label;
        tr.appendChild(th);
      });
      thead.appendChild(tr);
      table.appendChild(thead);

      const tbody = document.createElement('tbody');
      state.gridValues[section.id].forEach((_, rowIndex) => {
        const row = document.createElement('tr');
        included.forEach((field) => {
          const cell = document.createElement('td');
          cell.appendChild(renderControl(section.id, field, rowIndex));
          row.appendChild(cell);
        });
        tbody.appendChild(row);
      });
      table.appendChild(tbody);
      box.appendChild(table);
    }

    dom.previewContainer.appendChild(box);
  });

  const { payload, errors } = buildPayloadAndValidate();
  dom.payloadPreview.textContent = JSON.stringify(payload, null, 2);
  dom.validationList.innerHTML = '';

  if (errors.length === 0) {
    const ok = document.createElement('li');
    ok.textContent = 'Sin errores de validacion';
    ok.className = 'validation-ok';
    dom.validationList.appendChild(ok);
    return;
  }

  errors.forEach((error) => {
    const li = document.createElement('li');
    li.textContent = error;
    dom.validationList.appendChild(li);
  });
}

function addSection() {
  const firstTable = state.schema.tables[0];
  if (!firstTable) return;

  const section = {
    id: `sec-${Date.now()}`,
    name: `Seccion ${state.screen.sections.length + 1}`,
    table: tableKey(firstTable),
    mode: 'form',
    relation: null,
    fields: firstTable.fields.map((field) => ({
      bind: field.name,
      label: field.name,
      control: inferControl(field.type, field.name),
      required: !field.nullable,
      include: true
    }))
  };

  state.screen.sections.push(section);
  renderAll();
}

function addFieldToLastSection() {
  const section = state.screen.sections[state.screen.sections.length - 1];
  if (!section) return;
  const table = findTable(section.table);
  const firstField = table?.fields[0];
  if (!firstField) return;

  section.fields.push({
    bind: firstField.name,
    label: firstField.name,
    control: inferControl(firstField.type, firstField.name),
    required: !firstField.nullable,
    include: true
  });
  renderAll();
}

function exportScreen() {
  const blob = new Blob([JSON.stringify(state.screen, null, 2)], { type: 'application/json' });
  const url = URL.createObjectURL(blob);
  const anchor = document.createElement('a');
  anchor.href = url;
  anchor.download = `${(state.screen.screenName || 'screen').toLowerCase().replace(/\s+/g, '_')}.v3.json`;
  anchor.click();
  URL.revokeObjectURL(url);
}

function syncSchemaFromEditor() {
  const parsed = JSON.parse(dom.schemaText.value);
  if (!Array.isArray(parsed.tables)) throw new Error('schema debe incluir tables[]');
  state.schema = parsed;
  renderAll();
}

function syncScreenFromEditor() {
  const parsed = JSON.parse(dom.screenText.value);
  if (!Array.isArray(parsed.sections)) throw new Error('screen debe incluir sections[]');
  state.screen = parsed;
  state.screen.sections.forEach((section) => {
    section.fields = (section.fields || []).map(normalizeField);
  });
  renderAll();
}

function renderAll() {
  syncTableOptions();
  renderTableInfo();
  renderSections();
  renderPreviewAndPayload();
  syncScreenEditors();
}

async function loadBootstrapData() {
  const [schemaResponse, presetsResponse] = await Promise.all([
    fetch('/api/schema'),
    fetch('/api/presets')
  ]);

  state.schema = await schemaResponse.json();
  state.presets = (await presetsResponse.json()).presets || [];

  if (!Array.isArray(state.schema.tables) || state.schema.tables.length === 0) {
    throw new Error('No se pudo cargar el schema de tablas');
  }

  syncPresets();
  renderAll();
}

async function bootstrapApp() {
  const attempts = 3;

  for (let attempt = 1; attempt <= attempts; attempt += 1) {
    try {
      await loadBootstrapData();
      return;
    } catch (error) {
      if (attempt === attempts) {
        throw error;
      }

      await new Promise((resolve) => setTimeout(resolve, 250 * attempt));
    }
  }
}

function wireEvents() {
  dom.schemaSource.addEventListener('change', () => {
    renderTableInfo();
  });

  dom.tableSelect.addEventListener('change', renderTableInfo);

  dom.screenName.addEventListener('input', () => {
    state.screen.screenName = dom.screenName.value;
    syncScreenEditors();
  });

  dom.presetSelect.addEventListener('change', () => {
    if (!dom.presetSelect.value) return;
    applyPresetById(dom.presetSelect.value);
  });

  document.getElementById('btnApplyPreset').addEventListener('click', () => {
    if (dom.presetSelect.value) {
      applyPresetById(dom.presetSelect.value);
    }
  });

  document.getElementById('btnAddSection').addEventListener('click', addSection);
  document.getElementById('btnAddField').addEventListener('click', addFieldToLastSection);
  document.getElementById('btnLoadSample').addEventListener('click', () => {
    applyPresetById(state.presets[0]?.id || '');
  });
  document.getElementById('btnExportScreen').addEventListener('click', exportScreen);
  document.getElementById('btnSimulateSave').addEventListener('click', () => {
    const { errors } = buildPayloadAndValidate();
    alert(errors.length > 0 ? `Validacion con errores: ${errors.length}` : 'Simulacion OK: payload valido');
  });

  document.getElementById('btnApplySchema').addEventListener('click', () => {
    try {
      syncSchemaFromEditor();
    } catch (error) {
      alert(`Schema invalido: ${error.message}`);
    }
  });

  document.getElementById('btnApplyScreen').addEventListener('click', () => {
    try {
      syncScreenFromEditor();
    } catch (error) {
      alert(`Screen invalida: ${error.message}`);
    }
  });

  document.getElementById('schemaFileInput')?.addEventListener('change', async (event) => {
    const file = event.target.files[0];
    if (!file) return;
    try {
      const parsed = JSON.parse(await file.text());
      if (!Array.isArray(parsed.tables)) throw new Error('schema debe incluir tables[]');
      state.schema = parsed;
      renderAll();
    } catch (error) {
      alert(`Schema invalido: ${error.message}`);
    }
  });

  document.getElementById('screenFileInput')?.addEventListener('change', async (event) => {
    const file = event.target.files[0];
    if (!file) return;
    try {
      const parsed = JSON.parse(await file.text());
      if (!Array.isArray(parsed.sections)) throw new Error('screen debe incluir sections[]');
      state.screen = parsed;
      renderAll();
    } catch (error) {
      alert(`Pantalla invalida: ${error.message}`);
    }
  });
}

wireEvents();
bootstrapApp().catch((error) => {
  console.error(error);
  alert(`No se pudo cargar la aplicacion: ${error.message}`);
});
