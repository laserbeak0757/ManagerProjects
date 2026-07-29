const http = require('http');
const fs = require('fs');
const path = require('path');

const root = __dirname;
const publicDir = path.join(root, 'public');
const dataDir = path.join(root, 'data');
const port = Number(process.env.PORT || 3003);

function sendJson(res, status, payload) {
  res.writeHead(status, { 'Content-Type': 'application/json; charset=utf-8' });
  res.end(JSON.stringify(payload, null, 2));
}

function contentType(filePath) {
  const ext = path.extname(filePath).toLowerCase();
  if (ext === '.html') return 'text/html; charset=utf-8';
  if (ext === '.css') return 'text/css; charset=utf-8';
  if (ext === '.js') return 'application/javascript; charset=utf-8';
  if (ext === '.json') return 'application/json; charset=utf-8';
  return 'text/plain; charset=utf-8';
}

function readJsonFile(filePath, fallback) {
  try {
    const content = fs.readFileSync(filePath, 'utf8').replace(/^\uFEFF/, '');
    return JSON.parse(content);
  } catch {
    return fallback;
  }
}

function loadSchema() {
  const file = path.join(dataDir, 'schema.from.sip-bd-migrations.json');
  return readJsonFile(file, { source: 'empty', tables: [] });
}

function loadPresets() {
  const file = path.join(dataDir, 'presets.json');
  return readJsonFile(file, { presets: [] });
}

const server = http.createServer((req, res) => {
  const url = new URL(req.url, `http://${req.headers.host}`);

  if (url.pathname === '/api/schema') {
    return sendJson(res, 200, loadSchema());
  }

  if (url.pathname === '/api/presets') {
    return sendJson(res, 200, loadPresets());
  }

  let requestedPath = url.pathname === '/' ? '/index.html' : url.pathname;
  requestedPath = path.normalize(requestedPath).replace(/^([.]{2}[\/])+/, '');

  const candidates = [path.join(publicDir, requestedPath), path.join(dataDir, requestedPath)];
  const filePath = candidates.find((candidate) => candidate.startsWith(publicDir) || candidate.startsWith(dataDir) && fs.existsSync(candidate));

  if (!filePath || !fs.existsSync(filePath) || fs.statSync(filePath).isDirectory()) {
    res.writeHead(404, { 'Content-Type': 'text/plain; charset=utf-8' });
    res.end('Not found');
    return;
  }

  res.writeHead(200, { 'Content-Type': contentType(filePath) });
  fs.createReadStream(filePath).pipe(res);
});

server.listen(port, () => {
  console.log(`Vistas SIP v3 escuchando en http://localhost:${port}`);
});
