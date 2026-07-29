const controlOptions = ["text", "number", "date", "textarea", "checkbox"];

const defaultSchema = {
  source: "sample",
  tables: [
    {
      schema: "denuncias",
      name: "denuncia",
      fields: [
        { name: "id_denuncia", type: "int", nullable: false },
        { name: "numero_parte", type: "varchar(50)", nullable: false },
        { name: "fecha_recepcion", type: "datetime2", nullable: false },
        { name: "id_estado_denuncia", type: "int", nullable: false },
        { name: "observacion", type: "varchar(max)", nullable: true }
      ]
    },
    {
      schema: "denuncias",
      name: "denuncia_persona_rol",
      fields: [
        { name: "id_denuncia_persona_rol", type: "int", nullable: false },
        { name: "id_denuncia", type: "int", nullable: false },
        { name: "id_persona", type: "int", nullable: false },
        { name: "id_tipo_rol_persona", type: "int", nullable: false },
        { name: "fecha_creacion", type: "datetime2", nullable: false }
      ]
    }
  ]
};

const defaultScreen = {
  screenName: "Registro Denuncia con Personas",
  sections: [
    {
      id: "s1",
      name: "Cabecera Denuncia",
      table: "denuncias.denuncia",
      mode: "form",
      relation: null,
      fields: [
        { bind: "numero_parte", label: "Numero Parte", control: "text", required: true, include: true },
        { bind: "fecha_recepcion", label: "Fecha Recepcion", control: "date", required: true, include: true },
        { bind: "id_estado_denuncia", label: "Estado", control: "number", required: true, include: true },
        { bind: "observacion", label: "Observacion", control: "textarea", required: false, include: true }
      ]
    },
    {
      id: "s2",
      name: "Detalle Personas",
      table: "denuncias.denuncia_persona_rol",
      mode: "grid",
      relation: {
        parentSectionId: "s1",
        parentField: "id_denuncia",
        childField: "id_denuncia"
      },
      fields: [
        { bind: "id_persona", label: "Persona", control: "number", required: true, include: true },
        { bind: "id_tipo_rol_persona", label: "Rol", control: "number", required: true, include: true }
      ]
    }
  ]
};

const state = {
  schema: structuredClone(defaultSchema),
  screen: structuredClone(defaultScreen),
  formValues: {},
  gridValues: {}
};

const dom = {
  schemaFileInput: document.getElementById("schemaFileInput"),
  tableSelect: document.getElementById("tableSelect"),
  tableFields: document.getElementById("tableFields"),
  schemaText: document.getElementById("schemaText"),
  screenName: document.getElementById("screenName"),
  screenFileInput: document.getElementById("screenFileInput"),
  sectionsContainer: document.getElementById("sectionsContainer"),
  screenText: document.getElementById("screenText"),
  previewContainer: document.getElementById("previewContainer"),
  payloadPreview: document.getElementById("payloadPreview"),
  validationList: document.getElementById("validationList")
};

function tableKey(table) {
  return `${table.schema}.${table.name}`;
}

function findTable(tableName) {
  return state.schema.tables.find((t) => tableKey(t) === tableName);
}

function inferControl(sqlType, fieldName) {
  const t = String(sqlType || "").toLowerCase();
  const n = String(fieldName || "").toLowerCase();

  if (t.includes("bit")) return "checkbox";
  if (t.includes("date") || t.includes("time")) return "date";
  if (t.includes("int") || t.includes("decimal") || t.includes("numeric") || t.includes("float") || t.includes("money")) return "number";
  if (t.includes("max") || n.includes("observ") || n.includes("desc")) return "textarea";
  return "text";
}

function ensureGridRows(sectionId) {
  if (!Array.isArray(state.gridValues[sectionId])) {
    state.gridValues[sectionId] = [{}];
  }
}

function renderSchemaPanel() {
  dom.tableSelect.innerHTML = "";
  state.schema.tables.forEach((table) => {
    const opt = document.createElement("option");
    opt.value = tableKey(table);
    opt.textContent = `${tableKey(table)} (${table.fields.length})`;
    dom.tableSelect.appendChild(opt);
  });

  if (state.schema.tables.length > 0 && !dom.tableSelect.value) {
    dom.tableSelect.value = tableKey(state.schema.tables[0]);
  }

  const selected = findTable(dom.tableSelect.value) || state.schema.tables[0];
  dom.tableFields.innerHTML = "";
  if (selected) {
    selected.fields.forEach((f) => {
      const row = document.createElement("div");
      row.textContent = `${f.name} (${f.type}) ${f.nullable ? "NULL" : "NOT NULL"}`;
      dom.tableFields.appendChild(row);
    });
  }
}

function buildFieldSelectOptions(select, table) {
  select.innerHTML = "";
  (table?.fields || []).forEach((field) => {
    const opt = document.createElement("option");
    opt.value = field.name;
    opt.textContent = field.name;
    select.appendChild(opt);
  });
}

function syncSectionFieldsWithTable(section) {
  const table = findTable(section.table);
  if (!table) {
    section.fields = [];
    return;
  }

  const existing = new Map(section.fields.map((f) => [f.bind, f]));
  section.fields = table.fields.map((tf) => {
    const prior = existing.get(tf.name);
    if (prior) {
      return {
        ...prior,
        required: !tf.nullable ? true : Boolean(prior.required)
      };
    }

    return {
      bind: tf.name,
      label: tf.name.replace(/_/g, " ").replace(/\b\w/g, (x) => x.toUpperCase()),
      control: inferControl(tf.type, tf.name),
      required: !tf.nullable,
      include: true
    };
  });
}

function createSectionCard(section, index) {
  const wrapper = document.createElement("div");
  wrapper.className = "section-card";

  const header = document.createElement("div");
  header.className = "section-grid";

  const nameInput = document.createElement("input");
  nameInput.value = section.name;
  nameInput.addEventListener("input", () => {
    section.name = nameInput.value;
    renderPreviewAndPayload();
    syncEditors();
  });

  const modeSelect = document.createElement("select");
  ["form", "grid"].forEach((mode) => {
    const opt = document.createElement("option");
    opt.value = mode;
    opt.textContent = mode;
    modeSelect.appendChild(opt);
  });
  modeSelect.value = section.mode;
  modeSelect.addEventListener("change", () => {
    section.mode = modeSelect.value;
    ensureGridRows(section.id);
    renderAll();
  });

  const tableSelect = document.createElement("select");
  state.schema.tables.forEach((table) => {
    const opt = document.createElement("option");
    opt.value = tableKey(table);
    opt.textContent = tableKey(table);
    tableSelect.appendChild(opt);
  });
  tableSelect.value = section.table;
  tableSelect.addEventListener("change", () => {
    section.table = tableSelect.value;
    syncSectionFieldsWithTable(section);
    renderAll();
  });

  const deleteBtn = document.createElement("button");
  deleteBtn.type = "button";
  deleteBtn.className = "btn-secondary";
  deleteBtn.textContent = "Quitar seccion";
  deleteBtn.addEventListener("click", () => {
    state.screen.sections.splice(index, 1);
    delete state.formValues[section.id];
    delete state.gridValues[section.id];
    renderAll();
  });

  header.appendChild(nameInput);
  header.appendChild(modeSelect);
  header.appendChild(tableSelect);
  header.appendChild(deleteBtn);
  wrapper.appendChild(header);

  if (section.mode === "grid") {
    const rel = section.relation || {
      parentSectionId: state.screen.sections[0]?.id || "",
      parentField: "",
      childField: ""
    };
    section.relation = rel;

    const relRow = document.createElement("div");
    relRow.className = "section-grid";

    const parentSectionSelect = document.createElement("select");
    state.screen.sections
      .filter((s) => s.id !== section.id)
      .forEach((s) => {
        const opt = document.createElement("option");
        opt.value = s.id;
        opt.textContent = s.name;
        parentSectionSelect.appendChild(opt);
      });
    if (parentSectionSelect.options.length > 0) {
      parentSectionSelect.value = rel.parentSectionId || parentSectionSelect.options[0].value;
    }
    parentSectionSelect.addEventListener("change", () => {
      rel.parentSectionId = parentSectionSelect.value;
      renderPreviewAndPayload();
      syncEditors();
    });

    const parentFieldSelect = document.createElement("select");
    const parentSection = state.screen.sections.find((s) => s.id === (parentSectionSelect.value || rel.parentSectionId));
    buildFieldSelectOptions(parentFieldSelect, findTable(parentSection?.table));
    if (parentFieldSelect.options.length > 0) {
      parentFieldSelect.value = rel.parentField || parentFieldSelect.options[0].value;
    }
    parentFieldSelect.addEventListener("change", () => {
      rel.parentField = parentFieldSelect.value;
      renderPreviewAndPayload();
      syncEditors();
    });

    const childFieldSelect = document.createElement("select");
    buildFieldSelectOptions(childFieldSelect, findTable(section.table));
    if (childFieldSelect.options.length > 0) {
      childFieldSelect.value = rel.childField || childFieldSelect.options[0].value;
    }
    childFieldSelect.addEventListener("change", () => {
      rel.childField = childFieldSelect.value;
      renderPreviewAndPayload();
      syncEditors();
    });

    const relCaption = document.createElement("div");
    relCaption.textContent = "Relacion detalle: seccionPadre / campoPadre / campoHijo";
    relCaption.style.fontSize = "0.78rem";
    relCaption.style.color = "#5d665e";

    relRow.appendChild(parentSectionSelect);
    relRow.appendChild(parentFieldSelect);
    relRow.appendChild(childFieldSelect);
    wrapper.appendChild(relCaption);
    wrapper.appendChild(relRow);

    rel.parentSectionId = parentSectionSelect.value || rel.parentSectionId;
    rel.parentField = parentFieldSelect.value || rel.parentField;
    rel.childField = childFieldSelect.value || rel.childField;
  } else {
    section.relation = null;
  }

  const fieldTable = document.createElement("table");
  fieldTable.className = "table";
  fieldTable.innerHTML = "<thead><tr><th>Incluir</th><th>Campo</th><th>Etiqueta</th><th>Control</th><th>Req</th></tr></thead>";
  const tbody = document.createElement("tbody");

  section.fields.forEach((field) => {
    const tr = document.createElement("tr");

    const tdInclude = document.createElement("td");
    const include = document.createElement("input");
    include.type = "checkbox";
    include.checked = Boolean(field.include);
    include.addEventListener("change", () => {
      field.include = include.checked;
      renderPreviewAndPayload();
      syncEditors();
    });
    tdInclude.appendChild(include);

    const tdBind = document.createElement("td");
    tdBind.textContent = field.bind;

    const tdLabel = document.createElement("td");
    const label = document.createElement("input");
    label.value = field.label;
    label.addEventListener("input", () => {
      field.label = label.value;
      renderPreviewAndPayload();
      syncEditors();
    });
    tdLabel.appendChild(label);

    const tdControl = document.createElement("td");
    const control = document.createElement("select");
    controlOptions.forEach((c) => {
      const opt = document.createElement("option");
      opt.value = c;
      opt.textContent = c;
      control.appendChild(opt);
    });
    control.value = field.control;
    control.addEventListener("change", () => {
      field.control = control.value;
      renderPreviewAndPayload();
      syncEditors();
    });
    tdControl.appendChild(control);

    const tdReq = document.createElement("td");
    const req = document.createElement("input");
    req.type = "checkbox";
    req.checked = Boolean(field.required);
    req.addEventListener("change", () => {
      field.required = req.checked;
      renderPreviewAndPayload();
      syncEditors();
    });
    tdReq.appendChild(req);

    tr.appendChild(tdInclude);
    tr.appendChild(tdBind);
    tr.appendChild(tdLabel);
    tr.appendChild(tdControl);
    tr.appendChild(tdReq);
    tbody.appendChild(tr);
  });

  fieldTable.appendChild(tbody);
  wrapper.appendChild(fieldTable);

  if (section.mode === "grid") {
    const btnRow = document.createElement("div");
    btnRow.className = "row";
    const addRowBtn = document.createElement("button");
    addRowBtn.type = "button";
    addRowBtn.className = "btn-secondary";
    addRowBtn.textContent = "Agregar fila detalle";
    addRowBtn.addEventListener("click", () => {
      ensureGridRows(section.id);
      state.gridValues[section.id].push({});
      renderPreviewAndPayload();
    });
    btnRow.appendChild(addRowBtn);
    wrapper.appendChild(btnRow);
  }

  return wrapper;
}

function renderSectionsBuilder() {
  dom.sectionsContainer.innerHTML = "";
  state.screen.sections.forEach((section, index) => {
    syncSectionFieldsWithTable(section);
    if (section.mode === "grid") {
      ensureGridRows(section.id);
    }
    dom.sectionsContainer.appendChild(createSectionCard(section, index));
  });
}

function renderControl(sectionId, field, rowIndex = null) {
  const control = field.control === "textarea" ? document.createElement("textarea") : document.createElement("input");
  if (field.control !== "textarea") {
    control.type = field.control === "checkbox" ? "checkbox" : field.control;
  }

  const readValue = () => {
    if (rowIndex === null) {
      return state.formValues[sectionId]?.[field.bind];
    }
    ensureGridRows(sectionId);
    return state.gridValues[sectionId][rowIndex]?.[field.bind];
  };

  const writeValue = (value) => {
    if (rowIndex === null) {
      if (!state.formValues[sectionId]) state.formValues[sectionId] = {};
      state.formValues[sectionId][field.bind] = value;
    } else {
      ensureGridRows(sectionId);
      state.gridValues[sectionId][rowIndex][field.bind] = value;
    }
  };

  if (field.control === "checkbox") {
    control.checked = Boolean(readValue());
    control.addEventListener("change", () => {
      writeValue(control.checked);
      renderPreviewAndPayload();
    });
  } else {
    control.value = readValue() ?? "";
    control.required = Boolean(field.required);
    control.addEventListener("input", () => {
      writeValue(control.value);
      renderPreviewAndPayload();
    });
  }

  return control;
}

function renderPreviewAndPayload() {
  dom.previewContainer.innerHTML = "";

  state.screen.sections.forEach((section) => {
    const box = document.createElement("div");
    box.className = "preview-box";
    const title = document.createElement("h4");
    title.textContent = `${section.name} (${section.mode})`;
    box.appendChild(title);

    const includedFields = section.fields.filter((f) => f.include);

    if (section.mode === "form") {
      const formGrid = document.createElement("div");
      formGrid.className = "preview-grid";
      includedFields.forEach((field) => {
        const item = document.createElement("div");
        const label = document.createElement("label");
        label.textContent = field.label + (field.required ? " *" : "");
        item.appendChild(label);
        item.appendChild(renderControl(section.id, field));
        formGrid.appendChild(item);
      });
      box.appendChild(formGrid);
    } else {
      ensureGridRows(section.id);
      const table = document.createElement("table");
      table.className = "table";
      const thead = document.createElement("thead");
      const trh = document.createElement("tr");
      includedFields.forEach((field) => {
        const th = document.createElement("th");
        th.textContent = field.label;
        trh.appendChild(th);
      });
      thead.appendChild(trh);
      table.appendChild(thead);

      const tbody = document.createElement("tbody");
      state.gridValues[section.id].forEach((_, rowIndex) => {
        const tr = document.createElement("tr");
        includedFields.forEach((field) => {
          const td = document.createElement("td");
          td.appendChild(renderControl(section.id, field, rowIndex));
          tr.appendChild(td);
        });
        tbody.appendChild(tr);
      });
      table.appendChild(tbody);
      box.appendChild(table);
    }

    dom.previewContainer.appendChild(box);
  });

  const { payload, errors } = buildPayloadAndValidate();
  dom.payloadPreview.textContent = JSON.stringify(payload, null, 2);

  dom.validationList.innerHTML = "";
  if (errors.length === 0) {
    const ok = document.createElement("li");
    ok.textContent = "Sin errores de validacion";
    ok.className = "validation-ok";
    dom.validationList.appendChild(ok);
  } else {
    errors.forEach((error) => {
      const li = document.createElement("li");
      li.textContent = error;
      dom.validationList.appendChild(li);
    });
  }
}

function parseBySqlType(value, sqlType, control) {
  if (control === "checkbox") {
    return Boolean(value);
  }

  const raw = value ?? "";
  if (raw === "") {
    return null;
  }

  const t = String(sqlType || "").toLowerCase();

  if (t.includes("int") || t.includes("bigint") || t.includes("smallint") || t.includes("tinyint")) {
    const n = Number(raw);
    return Number.isInteger(n) ? n : Number.NaN;
  }

  if (t.includes("decimal") || t.includes("numeric") || t.includes("float") || t.includes("money")) {
    const n = Number(raw);
    return Number.isFinite(n) ? n : Number.NaN;
  }

  if (t.includes("date") || t.includes("time")) {
    const parsed = Date.parse(raw);
    return Number.isNaN(parsed) ? Number.NaN : raw;
  }

  if (t.includes("bit")) {
    return raw === "true" || raw === true || raw === 1 || raw === "1";
  }

  return String(raw);
}

function buildPayloadAndValidate() {
  const payload = {
    screenName: state.screen.screenName,
    sections: {}
  };
  const errors = [];

  state.screen.sections.forEach((section) => {
    const table = findTable(section.table);
    const tableFields = new Map((table?.fields || []).map((f) => [f.name, f]));
    const includedFields = section.fields.filter((f) => f.include);

    if (section.mode === "form") {
      const row = {};
      includedFields.forEach((field) => {
        const sqlMeta = tableFields.get(field.bind);
        const raw = state.formValues[section.id]?.[field.bind] ?? "";
        const parsed = parseBySqlType(raw, sqlMeta?.type, field.control);

        if (field.required && (raw === "" || raw === null || raw === undefined)) {
          errors.push(`${section.name}.${field.bind}: obligatorio`);
        }

        if (Number.isNaN(parsed)) {
          errors.push(`${section.name}.${field.bind}: formato invalido para tipo ${sqlMeta?.type || "desconocido"}`);
        } else {
          row[field.bind] = parsed;
        }
      });
      payload.sections[section.id] = row;
    } else {
      ensureGridRows(section.id);
      const rows = state.gridValues[section.id].map((gridRow, rowIndex) => {
        const row = {};
        includedFields.forEach((field) => {
          const sqlMeta = tableFields.get(field.bind);
          const raw = gridRow[field.bind] ?? "";
          const parsed = parseBySqlType(raw, sqlMeta?.type, field.control);

          if (field.required && (raw === "" || raw === null || raw === undefined)) {
            errors.push(`${section.name}[${rowIndex}].${field.bind}: obligatorio`);
          }

          if (Number.isNaN(parsed)) {
            errors.push(`${section.name}[${rowIndex}].${field.bind}: formato invalido para tipo ${sqlMeta?.type || "desconocido"}`);
          } else {
            row[field.bind] = parsed;
          }
        });

        return row;
      });

      if (section.relation?.parentSectionId && section.relation.parentField && section.relation.childField) {
        const parentData = payload.sections[section.relation.parentSectionId] || {};
        const parentValue = parentData[section.relation.parentField];
        rows.forEach((r) => {
          r[section.relation.childField] = parentValue ?? r[section.relation.childField] ?? null;
        });
      }

      payload.sections[section.id] = rows;
    }
  });

  return { payload, errors };
}

function syncEditors() {
  dom.schemaText.value = JSON.stringify(state.schema, null, 2);
  dom.screenText.value = JSON.stringify(state.screen, null, 2);
  dom.screenName.value = state.screen.screenName || "";
}

function renderAll() {
  renderSchemaPanel();
  renderSectionsBuilder();
  renderPreviewAndPayload();
  syncEditors();
}

function addSection() {
  const firstTable = state.schema.tables[0];
  if (!firstTable) return;

  const id = `s${Date.now()}`;
  const section = {
    id,
    name: `Seccion ${state.screen.sections.length + 1}`,
    table: tableKey(firstTable),
    mode: "form",
    relation: null,
    fields: firstTable.fields.map((f) => ({
      bind: f.name,
      label: f.name,
      control: inferControl(f.type, f.name),
      required: !f.nullable,
      include: true
    }))
  };

  state.screen.sections.push(section);
  renderAll();
}

function exportScreen() {
  const blob = new Blob([JSON.stringify(state.screen, null, 2)], { type: "application/json" });
  const url = URL.createObjectURL(blob);
  const a = document.createElement("a");
  a.href = url;
  const safeName = (state.screen.screenName || "pantalla").toLowerCase().replace(/\s+/g, "_");
  a.download = `${safeName}.v2.screen.json`;
  a.click();
  URL.revokeObjectURL(url);
}

function wireEvents() {
  dom.tableSelect.addEventListener("change", renderSchemaPanel);

  dom.screenName.addEventListener("input", () => {
    state.screen.screenName = dom.screenName.value;
    syncEditors();
  });

  document.getElementById("btnAddSection").addEventListener("click", addSection);
  document.getElementById("btnLoadSample").addEventListener("click", () => {
    state.schema = structuredClone(defaultSchema);
    state.screen = structuredClone(defaultScreen);
    state.formValues = {};
    state.gridValues = {};
    renderAll();
  });

  document.getElementById("btnExportScreen").addEventListener("click", exportScreen);

  document.getElementById("btnSimulateSave").addEventListener("click", () => {
    const { errors } = buildPayloadAndValidate();
    if (errors.length > 0) {
      alert(`Validacion con errores: ${errors.length} hallazgos`);
    } else {
      alert("Simulacion OK: payload valido");
    }
  });

  dom.schemaFileInput.addEventListener("change", async (event) => {
    const file = event.target.files[0];
    if (!file) return;
    const text = await file.text();
    try {
      const parsed = JSON.parse(text);
      if (!Array.isArray(parsed.tables)) throw new Error("schema debe contener tables[]");
      state.schema = parsed;
      state.screen.sections.forEach(syncSectionFieldsWithTable);
      renderAll();
    } catch (error) {
      alert(`Schema invalido: ${error.message}`);
    }
  });

  dom.screenFileInput.addEventListener("change", async (event) => {
    const file = event.target.files[0];
    if (!file) return;
    const text = await file.text();
    try {
      const parsed = JSON.parse(text);
      if (!Array.isArray(parsed.sections)) throw new Error("pantalla debe contener sections[]");
      state.screen = parsed;
      renderAll();
    } catch (error) {
      alert(`Pantalla invalida: ${error.message}`);
    }
  });

  document.getElementById("btnApplySchema").addEventListener("click", () => {
    try {
      const parsed = JSON.parse(dom.schemaText.value);
      if (!Array.isArray(parsed.tables)) throw new Error("schema debe contener tables[]");
      state.schema = parsed;
      state.screen.sections.forEach(syncSectionFieldsWithTable);
      renderAll();
    } catch (error) {
      alert(`Schema invalido: ${error.message}`);
    }
  });

  document.getElementById("btnApplyScreen").addEventListener("click", () => {
    try {
      const parsed = JSON.parse(dom.screenText.value);
      if (!Array.isArray(parsed.sections)) throw new Error("pantalla debe contener sections[]");
      state.screen = parsed;
      renderAll();
    } catch (error) {
      alert(`Pantalla invalida: ${error.message}`);
    }
  });
}

wireEvents();
renderAll();
