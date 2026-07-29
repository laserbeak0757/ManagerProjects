const controlOptions = ['text', 'number', 'date', 'textarea', 'checkbox'];
const STORAGE_KEY = 'vistas-v4-snapshots';
const THEME_STORAGE_KEY = 'vistas-v4-theme';
const THEME_CLASS_PREFIX = 'theme-';
const THEMES = {
  executive: {
    className: 'theme-executive',
    label: 'Azul-Verde Ejecutivo'
  },
  mint: {
    className: 'theme-mint',
    label: 'Verde-Turquesa Claro'
  },
  xbetClassic: {
    className: 'theme-xbet-classic',
    label: '8xbet Clasico (claro)'
  },
  xbetSlate: {
    className: 'theme-xbet-slate',
    label: '8xbet Slate (profundo)'
  },
  xbetBlend: {
    className: 'theme-xbet-blend',
    label: '8XBET Blend (neutral)'
  }
};

const state = {
  schema: { source: 'loading', tables: [] },
  presets: [],
  status: { ok: false, version: '4.1.0', schemaSource: 'loading', tableCount: 0, presetCount: 0 },
  screen: {
    screenName: 'Pantalla sin preset',
    sections: []
  },
  formValues: {},
  gridValues: {},
  ui: {
    query: '',
    selectedTableName: '',
    selectedPresetId: '',
    selectedTheme: 'executive',
    snapshots: []
  }
};

const dom = {
  kpiRail: document.getElementById('kpiRail'),
  schemaBadge: document.getElementById('schemaBadge'),
  schemaSource: document.getElementById('schemaSource'),
  tableSearch: document.getElementById('tableSearch'),
  tableSelect: document.getElementById('tableSelect'),
  tableBrowser: document.getElementById('tableBrowser'),
  selectedTableInfo: document.getElementById('selectedTableInfo'),
  schemaText: document.getElementById('schemaText'),
  screenName: document.getElementById('screenName'),
  themeSelect: document.getElementById('themeSelect'),
  presetSelect: document.getElementById('presetSelect'),
  screenMeta: document.getElementById('screenMeta'),
  selectionMeta: document.getElementById('selectionMeta'),
  sectionsContainer: document.getElementById('sectionsContainer'),
  screenText: document.getElementById('screenText'),
  previewContainer: document.getElementById('previewContainer'),
  payloadPreview: document.getElementById('payloadPreview'),
  validationList: document.getElementById('validationList'),
  snapshotList: document.getElementById('snapshotList'),
  previewBadge: document.getElementById('previewBadge')
};

function safeParseJson(raw, fallback) {
  try {
    return JSON.parse(raw);
  } catch {
    return fallback;
  }
}

function loadSnapshots() {
  const raw = localStorage.getItem(STORAGE_KEY);
  const parsed = safeParseJson(raw || '[]', []);
  return Array.isArray(parsed) ? parsed : [];
}

function applyTheme(themeId) {
  const fallbackTheme = 'executive';
  const chosenId = THEMES[themeId] ? themeId : fallbackTheme;
  const theme = THEMES[chosenId];

  document.body.classList.forEach((className) => {
    if (className.startsWith(THEME_CLASS_PREFIX)) {
      document.body.classList.remove(className);
    }
  });

  document.body.classList.add(theme.className);
  state.ui.selectedTheme = chosenId;
  if (dom.themeSelect && dom.themeSelect.value !== chosenId) {
    dom.themeSelect.value = chosenId;
  }
}

function loadTheme() {
  const storedTheme = localStorage.getItem(THEME_STORAGE_KEY);
  const selected = THEMES[storedTheme] ? storedTheme : 'executive';
  applyTheme(selected);
}

function persistTheme() {
  localStorage.setItem(THEME_STORAGE_KEY, state.ui.selectedTheme);
}

function persistSnapshots() {
  localStorage.setItem(STORAGE_KEY, JSON.stringify(state.ui.snapshots, null, 2));
}

function tableKey(table) {
  return `${table.schema}.${table.name}`;
}

function findTable(tableName) {
  return state.schema.tables.find((table) => tableKey(table) === tableName);
}

function getSelectedTable() {
  return findTable(state.ui.selectedTableName) || state.schema.tables[0] || null;
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
  if (type.includes('max') || name.includes('observ') || name.includes('desc') || name.includes('detalle')) return 'textarea';
  return 'text';
}

function formatFieldLabel(fieldName) {
  return String(fieldName || '')
    .replace(/_/g, ' ')
    .replace(/\b\w/g, (char) => char.toUpperCase());
}

function getSchemaFields(table) {
  return Array.isArray(table?.fields) ? table.fields : [];
}

function buildSectionFromTable(table, mode = 'form') {
  const fields = getSchemaFields(table);
  return {
    id: `sec-${Date.now()}-${Math.random().toString(36).slice(2, 7)}`,
    name: `${formatTableName(table)} ${mode === 'grid' ? 'Detalle' : 'Cabecera'}`,
    table: tableKey(table),
    mode,
    relation: null,
    fields: fields.map((field) => ({
      bind: field.name,
      label: formatFieldLabel(field.name),
      control: inferControl(field.type, field.name),
      required: !field.nullable,
      include: true
    }))
  };
}

function formatTableName(table) {
  return `${table.schema}.${table.name}`;
}

function filterTables() {
  const query = state.ui.query.trim().toLowerCase();
  if (!query) {
    return state.schema.tables;
  }

  return state.schema.tables.filter((table) => {
    if (tableKey(table).toLowerCase().includes(query)) return true;
    return getSchemaFields(table).some((field) => {
      const fieldText = `${field.name} ${field.type}`.toLowerCase();
      return fieldText.includes(query);
    });
  });
}

function syncSchemaSource() {
  dom.schemaSource.innerHTML = '';
  const option = document.createElement('option');
  option.value = state.status.schemaSource || state.schema.source || 'local';
  option.textContent = `${state.status.schemaSource || state.schema.source || 'local'} (${state.status.tableCount || state.schema.tables.length} tablas)`;
  dom.schemaSource.appendChild(option);
  dom.schemaSource.value = option.value;
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
    option.textContent = preset.name;
    dom.presetSelect.appendChild(option);
  });

  if (state.ui.selectedPresetId) {
    dom.presetSelect.value = state.ui.selectedPresetId;
  }
}

function syncTableOptions() {
  const filtered = filterTables();
  dom.tableSelect.innerHTML = '';

  filtered.forEach((table) => {
    const option = document.createElement('option');
    option.value = tableKey(table);
    option.textContent = `${tableKey(table)} (${getSchemaFields(table).length})`;
    dom.tableSelect.appendChild(option);
  });

  if (filtered.length > 0) {
    const preferred = filtered.some((table) => tableKey(table) === state.ui.selectedTableName)
      ? state.ui.selectedTableName
      : tableKey(filtered[0]);
    state.ui.selectedTableName = preferred;
    dom.tableSelect.value = preferred;
  } else {
    state.ui.selectedTableName = '';
  }
}

function renderKpis() {
  const selectedTable = getSelectedTable();
  const selectedFields = selectedTable ? getSchemaFields(selectedTable).length : 0;
  const includedFields = state.screen.sections.reduce((count, section) => count + section.fields.filter((field) => field.include !== false).length, 0);

  const kpis = [
    { value: state.schema.tables.length, label: 'Tablas cargadas' },
    { value: state.presets.length, label: 'Presets' },
    { value: state.screen.sections.length, label: 'Secciones' },
    { value: selectedFields, label: 'Campos activos' }
  ];

  dom.kpiRail.innerHTML = '';
  kpis.forEach((item) => {
    const box = document.createElement('div');
    box.className = 'kpi';
    const value = document.createElement('span');
    value.className = 'value';
    value.textContent = String(item.value);
    const label = document.createElement('span');
    label.className = 'label';
    label.textContent = item.label;
    box.appendChild(value);
    box.appendChild(label);
    dom.kpiRail.appendChild(box);
  });

  dom.selectionMeta.textContent = selectedTable ? `${tableKey(selectedTable)} · ${selectedFields} campos · ${includedFields} campos incluidos` : 'Sin tabla seleccionada';
  dom.screenMeta.textContent = `${state.screen.sections.length} secciones · ${state.ui.snapshots.length} snapshots`;
  dom.schemaBadge.textContent = `${state.status.tableCount || state.schema.tables.length} tablas`;
  dom.previewBadge.textContent = state.schema.tables.length > 0 ? 'Listo' : 'Sin schema';
}

function renderTableBrowser() {
  const filtered = filterTables();
  dom.tableBrowser.innerHTML = '';

  if (filtered.length === 0) {
    const empty = document.createElement('div');
    empty.className = 'empty-state';
    empty.textContent = 'No hay tablas que coincidan con el filtro actual.';
    dom.tableBrowser.appendChild(empty);
    return;
  }

  filtered.slice(0, 80).forEach((table) => {
    const item = document.createElement('button');
    item.type = 'button';
    item.className = `table-item${tableKey(table) === state.ui.selectedTableName ? ' is-active' : ''}`;
    item.addEventListener('click', () => {
      state.ui.selectedTableName = tableKey(table);
      dom.tableSelect.value = state.ui.selectedTableName;
      renderAll();
    });

    const left = document.createElement('div');
    const title = document.createElement('strong');
    title.textContent = formatTableName(table);
    const meta = document.createElement('small');
    meta.textContent = `${getSchemaFields(table).length} campos`;
    left.appendChild(title);
    left.appendChild(document.createElement('br'));
    left.appendChild(meta);

    const right = document.createElement('small');
    right.textContent = getSchemaFields(table).slice(0, 2).map((field) => field.name).join(' · ');

    item.appendChild(left);
    item.appendChild(right);
    dom.tableBrowser.appendChild(item);
  });
}

function renderTableInfo() {
  const table = getSelectedTable();
  dom.selectedTableInfo.innerHTML = '';

  if (!table) {
    dom.selectedTableInfo.className = 'card card-muted missing-state';
    dom.selectedTableInfo.textContent = 'Selecciona una tabla para ver sus campos y acciones rápidas.';
    return;
  }

  dom.selectedTableInfo.className = 'card card-muted';

  const heading = document.createElement('div');
  heading.innerHTML = `<strong>${formatTableName(table)}</strong><div class="muted">${getSchemaFields(table).length} campos · schema ${table.schema}</div>`;
  dom.selectedTableInfo.appendChild(heading);

  const meta = document.createElement('div');
  meta.className = 'section-meta';
  const chips = [
    `${table.schema}`,
    `${table.name}`,
    `${getSchemaFields(table).length} fields`
  ];
  chips.forEach((chipText) => {
    const chip = document.createElement('span');
    chip.className = 'badge';
    chip.textContent = chipText;
    meta.appendChild(chip);
  });
  dom.selectedTableInfo.appendChild(meta);

  const list = document.createElement('ul');
  list.className = 'column-list indented';
  getSchemaFields(table).slice(0, 12).forEach((field) => {
    const li = document.createElement('li');
    const name = document.createElement('span');
    name.className = 'column-name';
    name.textContent = field.name;
    const type = document.createElement('span');
    type.className = 'column-type';
    type.textContent = field.type;
    const nullable = document.createElement('span');
    nullable.className = 'column-nullability';
    nullable.textContent = field.nullable ? 'NULL' : 'NOT NULL';
    li.appendChild(name);
    li.appendChild(type);
    li.appendChild(nullable);
    list.appendChild(li);
  });
  dom.selectedTableInfo.appendChild(list);

  const actions = document.createElement('div');
  actions.className = 'section-foot';

  const addForm = document.createElement('button');
  addForm.type = 'button';
  addForm.className = 'btn-secondary';
  addForm.textContent = 'Agregar como formulario';
  addForm.addEventListener('click', () => addSectionFromSelectedTable('form'));

  const addGrid = document.createElement('button');
  addGrid.type = 'button';
  addGrid.className = 'btn-secondary';
  addGrid.textContent = 'Agregar como detalle';
  addGrid.addEventListener('click', () => addSectionFromSelectedTable('grid'));

  actions.appendChild(addForm);
  actions.appendChild(addGrid);
  dom.selectedTableInfo.appendChild(actions);
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
  section.fields = getSchemaFields(table).map((tableField) => {
    const previous = current.get(tableField.name);
    if (previous) {
      return {
        ...previous,
        required: previous.required || !tableField.nullable,
        label: previous.label || formatFieldLabel(tableField.name)
      };
    }

    return {
      bind: tableField.name,
      label: formatFieldLabel(tableField.name),
      control: inferControl(tableField.type, tableField.name),
      required: !tableField.nullable,
      include: true
    };
  });
}

function createSectionCard(section, index) {
  const wrapper = document.createElement('article');
  wrapper.className = 'section-card';

  const head = document.createElement('div');
  head.className = 'section-head';

  const nameInput = document.createElement('input');
  nameInput.value = section.name;
  nameInput.placeholder = 'Nombre de la sección';
  nameInput.addEventListener('input', () => {
    section.name = nameInput.value;
    renderPreviewAndPayload();
    syncScreenEditors();
  });

  const tableSelect = document.createElement('select');
  state.schema.tables.forEach((table) => {
    const option = document.createElement('option');
    option.value = tableKey(table);
    option.textContent = formatTableName(table);
    tableSelect.appendChild(option);
  });
  tableSelect.value = section.table;
  tableSelect.addEventListener('change', () => {
    section.table = tableSelect.value;
    syncSectionWithTable(section);
    renderAll();
  });

  const modeSelect = document.createElement('select');
  ['form', 'grid'].forEach((mode) => {
    const option = document.createElement('option');
    option.value = mode;
    option.textContent = mode === 'form' ? 'Formulario' : 'Detalle';
    modeSelect.appendChild(option);
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

  const meta = document.createElement('div');
  meta.className = 'section-meta';
  [
    section.mode === 'form' ? 'Formulario' : 'Detalle',
    section.table,
    `${section.fields.filter((field) => field.include !== false).length} incluidos`
  ].forEach((value) => {
    const chip = document.createElement('span');
    chip.className = 'badge';
    chip.textContent = value;
    meta.appendChild(chip);
  });
  wrapper.appendChild(meta);

  if (section.mode === 'grid') {
    const relationRow = document.createElement('div');
    relationRow.className = 'section-head indented';

    const parentSectionSelect = document.createElement('select');
    state.screen.sections.filter((item) => item.id !== section.id).forEach((item) => {
      const option = document.createElement('option');
      option.value = item.id;
      option.textContent = item.name;
      parentSectionSelect.appendChild(option);
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
    getSchemaFields(parentTable).forEach((field) => {
      const option = document.createElement('option');
      option.value = field.name;
      option.textContent = field.name;
      parentFieldSelect.appendChild(option);
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
    getSchemaFields(childTable).forEach((field) => {
      const option = document.createElement('option');
      option.value = field.name;
      option.textContent = field.name;
      childFieldSelect.appendChild(option);
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
  table.className = 'section-table';
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

  const foot = document.createElement('div');
  foot.className = 'section-foot';

  const duplicateBtn = document.createElement('button');
  duplicateBtn.type = 'button';
  duplicateBtn.className = 'btn-secondary';
  duplicateBtn.textContent = 'Duplicar';
  duplicateBtn.addEventListener('click', () => {
    const duplicate = structuredClone(section);
    duplicate.id = `sec-${Date.now()}-${Math.random().toString(36).slice(2, 7)}`;
    duplicate.name = `${section.name} copia`;
    state.screen.sections.splice(index + 1, 0, duplicate);
    renderAll();
  });

  const moveUpBtn = document.createElement('button');
  moveUpBtn.type = 'button';
  moveUpBtn.className = 'btn-secondary';
  moveUpBtn.textContent = 'Subir';
  moveUpBtn.disabled = index === 0;
  moveUpBtn.addEventListener('click', () => {
    if (index <= 0) return;
    const sections = state.screen.sections;
    [sections[index - 1], sections[index]] = [sections[index], sections[index - 1]];
    renderAll();
  });

  const moveDownBtn = document.createElement('button');
  moveDownBtn.type = 'button';
  moveDownBtn.className = 'btn-secondary';
  moveDownBtn.textContent = 'Bajar';
  moveDownBtn.disabled = index === state.screen.sections.length - 1;
  moveDownBtn.addEventListener('click', () => {
    if (index >= state.screen.sections.length - 1) return;
    const sections = state.screen.sections;
    [sections[index + 1], sections[index]] = [sections[index], sections[index + 1]];
    renderAll();
  });

  foot.appendChild(duplicateBtn);
  foot.appendChild(moveUpBtn);
  foot.appendChild(moveDownBtn);
  wrapper.appendChild(foot);

  return wrapper;
}

function renderSections() {
  dom.sectionsContainer.innerHTML = '';

  if (!state.screen.sections.length) {
    const empty = document.createElement('div');
    empty.className = 'empty-state';
    empty.innerHTML = '<strong>Sin secciones todavía.</strong><br/>Usa una tabla activa, un preset o la acción de crear pantalla inteligente.';
    dom.sectionsContainer.appendChild(empty);
    return;
  }

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
    const tableFields = new Map(getSchemaFields(table).map((field) => [field.name, field]));
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

  if (!state.screen.sections.length) {
    const empty = document.createElement('div');
    empty.className = 'empty-state';
    empty.textContent = 'La vista previa aparecerá aquí al agregar la primera sección.';
    dom.previewContainer.appendChild(empty);
  }

  state.screen.sections.forEach((section) => {
    const box = document.createElement('div');
    box.className = 'preview-box';

    const title = document.createElement('h4');
    title.textContent = `${section.name} (${section.mode === 'form' ? 'Formulario' : 'Detalle'})`;
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
      table.className = 'section-table';
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

    box.classList.add('fade-in');
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

function syncScreenEditors() {
  dom.schemaText.value = JSON.stringify(state.schema, null, 2);
  dom.screenText.value = JSON.stringify(state.screen, null, 2);
  dom.screenName.value = state.screen.screenName || '';
}

function renderSnapshots() {
  dom.snapshotList.innerHTML = '';

  if (!state.ui.snapshots.length) {
    const empty = document.createElement('div');
    empty.className = 'missing-state';
    empty.textContent = 'Aún no hay snapshots guardados.';
    dom.snapshotList.appendChild(empty);
    return;
  }

  state.ui.snapshots.slice(0, 6).forEach((snapshot) => {
    const item = document.createElement('div');
    item.className = 'snapshot-item';

    const title = document.createElement('h4');
    title.textContent = snapshot.name;

    const meta = document.createElement('p');
    meta.textContent = `${new Date(snapshot.createdAt).toLocaleString('es-CL')} · ${snapshot.sectionCount} secciones · ${snapshot.tableName || 'sin tabla base'}`;

    const actions = document.createElement('div');
    actions.className = 'snapshot-actions';

    const loadBtn = document.createElement('button');
    loadBtn.type = 'button';
    loadBtn.textContent = 'Cargar';
    loadBtn.addEventListener('click', () => loadSnapshot(snapshot.id));

    const deleteBtn = document.createElement('button');
    deleteBtn.type = 'button';
    deleteBtn.className = 'btn-secondary';
    deleteBtn.textContent = 'Eliminar';
    deleteBtn.addEventListener('click', () => deleteSnapshot(snapshot.id));

    actions.appendChild(loadBtn);
    actions.appendChild(deleteBtn);

    item.appendChild(title);
    item.appendChild(meta);
    item.appendChild(actions);
    dom.snapshotList.appendChild(item);
  });
}

function autoBuildScreen() {
  const table = getSelectedTable();
  if (!table) return;

  state.screen = {
    screenName: `Pantalla inteligente - ${formatTableName(table)}`,
    sections: [buildSectionFromTable(table, 'form')]
  };
  state.formValues = {};
  state.gridValues = {};
  state.ui.selectedPresetId = '';
  renderAll();
}

function addSectionFromSelectedTable(mode = 'form') {
  const table = getSelectedTable();
  if (!table) return;

  const section = buildSectionFromTable(table, mode);
  if (mode === 'grid' && state.screen.sections.length > 0) {
    section.relation = {
      parentSectionId: state.screen.sections[state.screen.sections.length - 1].id,
      parentField: getSchemaFields(findTable(state.screen.sections[state.screen.sections.length - 1].table))[0]?.name || '',
      childField: getSchemaFields(table)[0]?.name || ''
    };
  }

  state.screen.sections.push(section);
  renderAll();
}

function applyPresetById(presetId) {
  const preset = state.presets.find((item) => item.id === presetId);
  if (!preset) return;
  state.ui.selectedPresetId = presetId;
  state.screen = structuredClone(preset.screen);
  state.screen.sections = state.screen.sections || [];
  state.screen.sections.forEach((section) => {
    section.fields = (section.fields || []).map(normalizeField);
    section.mode = section.mode || 'form';
    section.relation = section.relation || null;
  });
  state.formValues = {};
  state.gridValues = {};

  const firstSection = state.screen.sections[0];
  if (firstSection) {
    state.ui.selectedTableName = firstSection.table;
  }

  renderAll();
}

function clearScreen() {
  state.screen = {
    screenName: 'Pantalla sin preset',
    sections: []
  };
  state.formValues = {};
  state.gridValues = {};
  state.ui.selectedPresetId = '';
  renderAll();
}

function exportScreen() {
  const blob = new Blob([JSON.stringify(state.screen, null, 2)], { type: 'application/json' });
  const url = URL.createObjectURL(blob);
  const anchor = document.createElement('a');
  anchor.href = url;
  anchor.download = `${(state.screen.screenName || 'screen').toLowerCase().replace(/\s+/g, '_')}.v4.json`;
  anchor.click();
  URL.revokeObjectURL(url);
}

function syncSchemaFromEditor() {
  const parsed = safeParseJson(dom.schemaText.value, null);
  if (!parsed || !Array.isArray(parsed.tables)) throw new Error('schema debe incluir tables[]');
  state.schema = parsed;
  state.ui.selectedTableName = tableKey(state.schema.tables[0] || {});
  state.status.tableCount = state.schema.tables.length;
  renderAll();
}

function syncScreenFromEditor() {
  const parsed = safeParseJson(dom.screenText.value, null);
  if (!parsed || !Array.isArray(parsed.sections)) throw new Error('screen debe incluir sections[]');
  state.screen = parsed;
  state.screen.sections.forEach((section) => {
    section.fields = (section.fields || []).map(normalizeField);
    section.mode = section.mode || 'form';
    section.relation = section.relation || null;
  });
  state.formValues = {};
  state.gridValues = {};
  renderAll();
}

function saveSnapshot() {
  const snapshot = {
    id: `snap-${Date.now()}`,
    name: `${state.screen.screenName || 'Pantalla'} · ${new Date().toLocaleTimeString('es-CL')}`,
    tableName: state.ui.selectedTableName,
    sectionCount: state.screen.sections.length,
    createdAt: new Date().toISOString(),
    screen: structuredClone(state.screen)
  };

  state.ui.snapshots.unshift(snapshot);
  state.ui.snapshots = state.ui.snapshots.slice(0, 8);
  persistSnapshots();
  renderSnapshots();
}

function loadSnapshot(snapshotId) {
  const snapshot = state.ui.snapshots.find((item) => item.id === snapshotId);
  if (!snapshot) return;

  state.screen = structuredClone(snapshot.screen);
  state.formValues = {};
  state.gridValues = {};
  state.ui.selectedTableName = snapshot.tableName || state.ui.selectedTableName;
  renderAll();
}

function deleteSnapshot(snapshotId) {
  state.ui.snapshots = state.ui.snapshots.filter((item) => item.id !== snapshotId);
  persistSnapshots();
  renderSnapshots();
}

function renderAll() {
  renderKpis();
  syncSchemaSource();
  syncPresets();
  syncTableOptions();
  renderTableBrowser();
  renderTableInfo();
  renderSections();
  renderPreviewAndPayload();
  renderSnapshots();
  syncScreenEditors();
}

async function loadBootstrapData() {
  const [schemaResponse, presetsResponse, statusResponse] = await Promise.all([
    fetch('/api/schema'),
    fetch('/api/presets'),
    fetch('/api/status')
  ]);

  state.schema = await schemaResponse.json();
  state.presets = (await presetsResponse.json()).presets || [];
  state.status = await statusResponse.json();
  state.ui.snapshots = loadSnapshots();

  if (!Array.isArray(state.schema.tables) || state.schema.tables.length === 0) {
    throw new Error('No se pudo cargar el schema de tablas');
  }

  if (!state.ui.selectedTableName) {
    state.ui.selectedTableName = tableKey(state.schema.tables[0]);
  }

  if (state.ui.snapshots.length > 0 && !state.ui.snapshots[0].screen) {
    state.ui.snapshots = [];
    persistSnapshots();
  }

  renderAll();
}

function wireEvents() {
  dom.themeSelect.addEventListener('change', () => {
    applyTheme(dom.themeSelect.value);
    persistTheme();
  });

  dom.tableSearch.addEventListener('input', () => {
    state.ui.query = dom.tableSearch.value;
    syncTableOptions();
    renderTableBrowser();
    renderTableInfo();
    renderKpis();
  });

  dom.tableSelect.addEventListener('change', () => {
    state.ui.selectedTableName = dom.tableSelect.value;
    renderAll();
  });

  dom.screenName.addEventListener('input', () => {
    state.screen.screenName = dom.screenName.value;
    syncScreenEditors();
    renderKpis();
  });

  dom.presetSelect.addEventListener('change', () => {
    state.ui.selectedPresetId = dom.presetSelect.value;
  });

  document.getElementById('btnLoadPreset').addEventListener('click', () => {
    if (dom.presetSelect.value) {
      applyPresetById(dom.presetSelect.value);
    }
  });

  document.getElementById('btnAutoBuild').addEventListener('click', autoBuildScreen);
  document.getElementById('btnAddSection').addEventListener('click', () => addSectionFromSelectedTable('form'));
  document.getElementById('btnAddDetail').addEventListener('click', () => addSectionFromSelectedTable('grid'));
  document.getElementById('btnSaveSnapshot').addEventListener('click', saveSnapshot);
  document.getElementById('btnRefreshSnapshots').addEventListener('click', renderSnapshots);
  document.getElementById('btnExportScreen').addEventListener('click', exportScreen);
  document.getElementById('btnValidate').addEventListener('click', () => {
    const { errors } = buildPayloadAndValidate();
    alert(errors.length > 0 ? `Validacion con errores: ${errors.length}` : 'Simulacion OK: payload valido');
  });
  document.getElementById('btnClearScreen').addEventListener('click', clearScreen);

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
}

wireEvents();
loadTheme();
loadBootstrapData().catch((error) => {
  console.error(error);
  dom.previewBadge.textContent = 'Error';
  alert(`No se pudo cargar la aplicacion: ${error.message}`);
});
