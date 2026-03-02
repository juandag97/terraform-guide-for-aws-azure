/**
 * Workshop Terraform — App Service Azure (Node.js + Express)
 *
 * API simple que demuestra un servicio web desplegado en
 * Azure App Service a través de Terraform.
 */

const express = require('express');
const app = express();

// Azure inyecta el puerto por variable de entorno
// Usamos 8080 como fallback para desarrollo local
const PORT = process.env.PORT || process.env.WEBSITES_PORT || 8080;

const ENVIRONMENT  = process.env.ENVIRONMENT  || 'local';
const PROJECT_NAME = process.env.PROJECT_NAME || 'workshop-tf';
const NODE_ENV     = process.env.NODE_ENV     || 'development';

app.use(express.json());

// ------------------------------------------------------------
// Middleware: log de cada request
// ------------------------------------------------------------
app.use((req, res, next) => {
  const timestamp = new Date().toISOString();
  console.log(`[${timestamp}] ${req.method} ${req.path}`);
  next();
});

// ------------------------------------------------------------
// GET /
// Health check — Azure lo usa para verificar que la app vive
// ------------------------------------------------------------
app.get('/', (req, res) => {
  res.json({
    status:      'ok',
    message:     'Servicio funcionando correctamente',
    environment: ENVIRONMENT,
    project:     PROJECT_NAME,
    timestamp:   new Date().toISOString(),
  });
});

// ------------------------------------------------------------
// GET /api/hello
// Endpoint principal del demo
// ------------------------------------------------------------
app.get('/api/hello', (req, res) => {
  const name = req.query.name || 'Mundo';

  res.json({
    message:     `¡Hola, ${name}! 👋`,
    description: 'Este mensaje viene de un App Service desplegado con Terraform en Azure.',
    meta: {
      project:     PROJECT_NAME,
      environment: ENVIRONMENT,
      node_env:    NODE_ENV,
      node_version: process.version,
      platform:    process.platform,
      timestamp:   new Date().toISOString(),
    },
  });
});

// ------------------------------------------------------------
// GET /api/info
// Información del servidor — útil para debugging
// ------------------------------------------------------------
app.get('/api/info', (req, res) => {
  res.json({
    runtime:       `Node.js ${process.version}`,
    platform:      process.platform,
    environment:   ENVIRONMENT,
    project:       PROJECT_NAME,
    uptime_seconds: Math.floor(process.uptime()),
    memory_mb:     {
      used:  Math.round(process.memoryUsage().heapUsed / 1024 / 1024),
      total: Math.round(process.memoryUsage().heapTotal / 1024 / 1024),
    },
    available_routes: [
      'GET /',
      'GET /api/hello',
      'GET /api/hello?name=TuNombre',
      'GET /api/info',
    ],
  });
});

// ------------------------------------------------------------
// 404 — Ruta no encontrada
// ------------------------------------------------------------
app.use((req, res) => {
  res.status(404).json({
    error:    'Ruta no encontrada',
    path:     req.path,
    method:   req.method,
    available: ['GET /', 'GET /api/hello', 'GET /api/info'],
  });
});

// ------------------------------------------------------------
// Iniciar servidor
// ------------------------------------------------------------
app.listen(PORT, () => {
  console.log(`
╔══════════════════════════════════════════════╗
║   Workshop Terraform — Azure App Service     ║
╠══════════════════════════════════════════════╣
║  Puerto:      ${String(PORT).padEnd(29)}║
║  Entorno:     ${ENVIRONMENT.padEnd(29)}║
║  Proyecto:    ${PROJECT_NAME.padEnd(29)}║
║  Node:        ${process.version.padEnd(29)}║
╚══════════════════════════════════════════════╝
  `);
});
