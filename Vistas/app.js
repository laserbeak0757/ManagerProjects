const defaultSchema = {
  source: "sample",
  tables: [
    {
      schema: "personas",
      name: "persona",
      fields: [
        { name: "id", type: "int", nullable: false },
        { name: "run", type: "varchar(12)", nullable: false },
        { name: "nombres", type: "varchar(120)", nullable: false },
        { name: "apellido_paterno", type: "varchar(120)", nullable: false },
        { name: "apellido_materno", type: "varchar(120)", nullable: true },
        { name: "fecha_nacimiento", type: "date", nullable: true },
        { name: "correo", type: "varchar(200)", nullable: true },
        { name: "telefono", type: "varchar(30)", nullable: true },
        { name: "observacion", type: "varchar(max)", nullable: true },
        { name: "vigente", type: "bit", nullable: false }
      ]
    }
  ]
};

const defaultScreen = {
  screenName: "Persona - Registro Base",
  table: "personas.persona",
  elements: [
    { id: "run", label: "RUN", control: "text", bind: "run", required: true },
    { id: "nombres", label: "Nombres", control: "text", bind: "nombres", required: true },
    { id: "apellido_paterno", label: "Apellido Paterno", control: "text", bind: "apellido_paterno", required: true },
    { id: "fecha_nacimiento", label: "Fecha de Nacimiento", control: "date", bind: "fecha_nacimiento", required: false },
    { id: "vigente", label: "Vigente", control: "checkbox", bind: "vigente", required: false }
  ]
};

const state = {
  schema: structuredClone(defaultSchema),
  screen: structuredClone(defaultScreen),
  formData: {}
};

const dom = {
  schemaText: document.getElementById("schemaText"),
  screenText: document.getElementById("screenText"),
  tableSelect: document.getElementById("tableSelect"),
  dbFieldsList: document.getElementById("dbFieldsList"),
  mappingBody: document.getElementById("mappingBody"),
  previewForm: document.getElementById("previewForm"),
  payloadPreview: document.getElementById("payloadPreview"),
  screenName: document.getElementById("screenName")
};

function tableKey(table) {
  return `${table.schema}.${table.name}`;
}

function currentTable() {
  return state.schema.tables.find((t) => tableKey(t) === state.screen.table) || state.schema.tables[0];
}

function controlFromType(type, fieldName) {
  const lower = String(type || "").toLowerCase();
  const name = String(fieldName || "").toLowerCase();

  if (lower.includes("bit")) return "checkbox";
  if (lower.includes("date") || lower.includes("time")) return "date";
  if (lower.includes("int") || lower.includes("decimal") || lower.includes("numeric") || lower.includes("float")) return "number";
  if (name.includes("observ") || name.includes("descripcion") || lower.includes("max")) return "textarea";
  return "text";
}

function ensureScreenSync() {
  const table = currentTable();
  if (!table) return;

  const validFields = new Set(table.fields.map((f) => f.name));
  state.screen.elements = state.screen.elements.filter((el) => validFields.has(el.bind));
}

function renderTableOptions() {
  dom.tableSelect.innerHTML = "";
  state.schema.tables.forEach((table) => {
    const option = document.createElement("option");
    option.value = tableKey(table);
    option.textContent = `${tableKey(table)} (${table.fields.length} campos)`;
    dom.tableSelect.appendChild(option);
  });

  if (!state.screen.table && state.schema.tables.length > 0) {
    state.screen.table = tableKey(state.schema.tables[0]);
  }

  dom.tableSelect.value = state.screen.table;
}

function renderDbFields() {
  const table = currentTable();
  dom.dbFieldsList.innerHTML = "";
  if (!table) return;

  table.fields.forEach((field) => {
    const item = document.createElement("div");
    item.className = "db-field-item";
    item.textContent = `${field.name} (${field.type}) ${field.nullable ? "NULL" : "NOT NULL"}`;
    dom.dbFieldsList.appendChild(item);
  });
}

function renderMappingRows() {
  const table = currentTable();
  const availableFields = table ? table.fields.map((f) => f.name) : [];

  dom.mappingBody.innerHTML = "";
  state.screen.elements.forEach((element, index) => {
    const tr = document.createElement("tr");

    const labelTd = document.createElement("td");
    const labelInput = document.createElement("input");
    labelInput.value = element.label;
    labelInput.addEventListener("input", () => {
      element.label = labelInput.value;
      renderPreview();
      syncJsonEditors();
    });
    labelTd.appendChild(labelInput);

    const controlTd = document.createElement("td");
    const controlSelect = document.createElement("select");
    ["text", "number", "date", "textarea", "checkbox"].forEach((control) => {
      const opt = document.createElement("option");
      opt.value = control;
      opt.textContent = control;
      controlSelect.appendChild(opt);
    });
    controlSelect.value = element.control;
    controlSelect.addEventListener("change", () => {
      element.control = controlSelect.value;
      renderPreview();
      syncJsonEditors();
    });
    controlTd.appendChild(controlSelect);

    const bindTd = document.createElement("td");
    const bindSelect = document.createElement("select");
    availableFields.forEach((fieldName) => {
      const opt = document.createElement("option");
      opt.value = fieldName;
      opt.textContent = fieldName;
      bindSelect.appendChild(opt);
    });
    bindSelect.value = element.bind;
    bindSelect.addEventListener("change", () => {
      element.bind = bindSelect.value;
      renderPreview();
      syncJsonEditors();
    });
    bindTd.appendChild(bindSelect);

    const requiredTd = document.createElement("td");
    const requiredInput = document.createElement("input");
    requiredInput.type = "checkbox";
    requiredInput.checked = Boolean(element.required);
    requiredInput.addEventListener("change", () => {
      element.required = requiredInput.checked;
      renderPreview();
      syncJsonEditors();
    });
    requiredTd.appendChild(requiredInput);

    const deleteTd = document.createElement("td");
    const deleteButton = document.createElement("button");
    deleteButton.className = "btn-secondary";
    deleteButton.type = "button";
    deleteButton.textContent = "Quitar";
    deleteButton.addEventListener("click", () => {
      state.screen.elements.splice(index, 1);
      renderAll();
    });
    deleteTd.appendChild(deleteButton);

    tr.appendChild(labelTd);
    tr.appendChild(controlTd);
    tr.appendChild(bindTd);
    tr.appendChild(requiredTd);
    tr.appendChild(deleteTd);
    dom.mappingBody.appendChild(tr);
  });
}

function buildFieldControl(element) {
  let control;

  if (element.control === "textarea") {
    control = document.createElement("textarea");
  } else {
    control = document.createElement("input");
    control.type = element.control === "checkbox" ? "checkbox" : element.control;
  }

  if (element.control === "checkbox") {
    control.checked = Boolean(state.formData[element.bind]);
    control.addEventListener("change", () => {
      state.formData[element.bind] = control.checked;
      renderPayload();
    });
  } else {
    const val = state.formData[element.bind] ?? "";
    control.value = val;
    control.required = Boolean(element.required);
    control.placeholder = element.placeholder || "";
    control.addEventListener("input", () => {
      state.formData[element.bind] = control.value;
      renderPayload();
    });
  }

  return control;
}

function renderPreview() {
  dom.previewForm.innerHTML = "";
  state.screen.elements.forEach((element) => {
    const box = document.createElement("div");
    box.className = "preview-field";

    const label = document.createElement("label");
    label.textContent = element.label + (element.required ? " *" : "");

    const bind = document.createElement("small");
    bind.textContent = `BD: ${element.bind}`;
    bind.style.color = "#5e6c63";

    box.appendChild(label);
    box.appendChild(buildFieldControl(element));
    box.appendChild(bind);
    dom.previewForm.appendChild(box);
  });

  renderPayload();
}

function renderPayload() {
  const payload = {};
  state.screen.elements.forEach((element) => {
    payload[element.bind] = state.formData[element.bind] ?? (element.control === "checkbox" ? false : "");
  });

  dom.payloadPreview.textContent = JSON.stringify(payload, null, 2);
}

function syncJsonEditors() {
  dom.schemaText.value = JSON.stringify(state.schema, null, 2);
  dom.screenText.value = JSON.stringify(state.screen, null, 2);
  dom.screenName.value = state.screen.screenName || "";
}

function renderAll() {
  ensureScreenSync();
  renderTableOptions();
  renderDbFields();
  renderMappingRows();
  renderPreview();
  syncJsonEditors();
}

function generateFromSelectedTable() {
  const table = currentTable();
  if (!table) return;

  state.screen.elements = table.fields.map((field) => ({
    id: field.name,
    label: field.name.replace(/_/g, " ").replace(/\b\w/g, (x) => x.toUpperCase()),
    control: controlFromType(field.type, field.name),
    bind: field.name,
    required: !field.nullable
  }));

  renderAll();
}

function exportJsonFile(fileName, data) {
  const blob = new Blob([JSON.stringify(data, null, 2)], { type: "application/json" });
  const url = URL.createObjectURL(blob);
  const a = document.createElement("a");
  a.href = url;
  a.download = fileName;
  a.click();
  URL.revokeObjectURL(url);
}

function wireEvents() {
  dom.tableSelect.addEventListener("change", () => {
    state.screen.table = dom.tableSelect.value;
    ensureScreenSync();
    renderAll();
  });

  dom.screenName.addEventListener("input", () => {
    state.screen.screenName = dom.screenName.value;
    syncJsonEditors();
  });

  document.getElementById("btnAddElement").addEventListener("click", () => {
    const table = currentTable();
    if (!table || table.fields.length === 0) return;

    const fallbackField = table.fields[0].name;
    state.screen.elements.push({
      id: `campo_${state.screen.elements.length + 1}`,
      label: "Nuevo Campo",
      control: "text",
      bind: fallbackField,
      required: false
    });
    renderAll();
  });

  document.getElementById("btnGenerateFromTable").addEventListener("click", generateFromSelectedTable);

  document.getElementById("btnExportScreen").addEventListener("click", () => {
    const safeName = (state.screen.screenName || "pantalla").toLowerCase().replace(/\s+/g, "_");
    exportJsonFile(`${safeName}.screen.json`, state.screen);
  });

  document.getElementById("btnLoadSample").addEventListener("click", () => {
    state.schema = structuredClone(defaultSchema);
    state.screen = structuredClone(defaultScreen);
    state.formData = {};
    renderAll();
  });

  document.getElementById("btnApplySchema").addEventListener("click", () => {
    try {
      const parsed = JSON.parse(dom.schemaText.value);
      if (!Array.isArray(parsed.tables)) throw new Error("El schema debe tener 'tables'.");
      state.schema = parsed;
      if (!state.screen.table && parsed.tables.length > 0) {
        state.screen.table = tableKey(parsed.tables[0]);
      }
      renderAll();
    } catch (error) {
      alert(`Schema invalido: ${error.message}`);
    }
  });

  document.getElementById("btnApplyScreen").addEventListener("click", () => {
    try {
      const parsed = JSON.parse(dom.screenText.value);
      if (!Array.isArray(parsed.elements)) throw new Error("La vista debe tener 'elements'.");
      state.screen = parsed;
      renderAll();
    } catch (error) {
      alert(`Vista invalida: ${error.message}`);
    }
  });

  document.getElementById("btnSimulateSave").addEventListener("click", () => {
    alert("Simulacion OK: revisa el payload generado.");
  });

  document.getElementById("schemaFileInput").addEventListener("change", async (event) => {
    const file = event.target.files[0];
    if (!file) return;
    const text = await file.text();
    try {
      const parsed = JSON.parse(text);
      if (!Array.isArray(parsed.tables)) throw new Error("El schema debe tener 'tables'.");
      state.schema = parsed;
      if (!state.screen.table && parsed.tables.length > 0) {
        state.screen.table = tableKey(parsed.tables[0]);
      }
      renderAll();
    } catch (error) {
      alert(`Archivo schema invalido: ${error.message}`);
    }
  });

  document.getElementById("screenFileInput").addEventListener("change", async (event) => {
    const file = event.target.files[0];
    if (!file) return;
    const text = await file.text();
    try {
      const parsed = JSON.parse(text);
      if (!Array.isArray(parsed.elements)) throw new Error("La vista debe tener 'elements'.");
      state.screen = parsed;
      renderAll();
    } catch (error) {
      alert(`Archivo vista invalido: ${error.message}`);
    }
  });
}

wireEvents();
renderAll();
