# Archivos del Proyecto

Esta sección describe todos los archivos creados para el proyecto.

---

## Archivos Principales

### Dockerfile

**Líneas:** 25  
**Propósito:** Instala nginx desde cero

```dockerfile
FROM ubuntu:22.04
ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get install -y nginx && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

COPY public/ /usr/share/nginx/html/
COPY nginx.conf /etc/nginx/sites-available/default

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
```

**Características:**
-  Instala nginx desde Ubuntu (no imagen preconstruida)
-  Limpia caché para reducir tamaño
-  Copia archivos estáticos
-  Copia configuración personalizada

---

### nginx.conf

**Líneas:** 49  
**Propósito:** Configuración del servidor web

```nginx
# Servidor para localhost
server {
    listen 80;
    server_name localhost;
    root /usr/share/nginx/html;
    index index.html;

    location / {
        try_files $uri $uri/ =404;
    }

    location /app/ {
        alias /usr/share/nginx/html/app/;
        try_files $uri $uri/ =404;
    }

    access_log /var/log/nginx/access.log;
    error_log /var/log/nginx/error.log;
}

# Servidor para miapp.local
server {
    listen 80;
    server_name miapp.local;
    # ... misma configuración con logs separados
}
```

**Características:**
-  Dos servidores virtuales
-  Rutas configurables
-  Logs separados por dominio
-  Manejo de errores 404

---

### docker-compose.yml

**Líneas:** 10  
**Propósito:** Orquestación de Docker

```yaml
services:
  webserver:
    build: .
    ports:
      - "80:80"
      - "1593:80"
    volumes:
      - ./public:/usr/share/nginx/html
    container_name: proyecto_webserver
```

**Características:**
-  Construcción automática
-  Mapeo de puertos (80 y 1593)
-  Volumen para desarrollo
-  Nombre de contenedor personalizado

---

### setup.sh

**Líneas:** 48  
**Propósito:** Script de configuración automatizado

```bash
#!/bin/bash
# Verifica Docker
# Configura hosts
# Construye imagen
# Inicia servidor
```

**Características:**
-  Verificación de dependencias
-  Instrucciones para hosts
-  Construcción e inicio automático
-  Mensajes informativos

---

## Archivos de Aplicación

### public/index.html

**Líneas:** ~45  
**Propósito:** Página principal del servidor

```html
<!DOCTYPE html>
<html>
<head>
    <title>Proyecto Webserver</title>
</head>
<body>
    <h1>🚀 Proyecto Webserver</h1>
    <a href="/app/">Acceder a la App</a>
</body>
</html>
```

---

### public/app/*

**Archivos:** `index.html`, `styles.css`, `app.js`

**Propósito:** Aplicación web interactiva

**Características:**
- HTML con estructura semántica
- CSS con diseño responsive
- JavaScript con interactividad
- Input dinámico con validación

---

## Archivos de Documentación

### README.md

**Propósito:** Instrucciones de uso del proyecto

**Contenido:**
- Estructura del proyecto
- Cómo usar
- Configurar hosts
- Comandos útiles

---

### mkdocs.yml

**Propósito:** Configuración de la documentación MkDocs

```yaml
site_name: Servidor Web con nginx en Docker
nav:
  - Inicio: index.md
  - Fase 1: fases/fase1.md
  # ...
```

---

### docs/*

**Carpeta:** Documentación completa del proyecto

**Estructura:**
```
docs/
├── index.md
├── fases/
│   ├── phase1.md
│   ├── phase2.md
│   ├── phase3.md
│   └── phase4.md
├── archivos.md
├── verificacion.md
├── nginx.md
├── docker.md
└── conclusion.md
```

---

## Archivos Adicionales

### .dockerignore

**Propósito:** Excluir archivos del build

```
node_modules/
.git/
dist/
*.md
```

---

### Arquitectura Final

```
proyecto_webserver/
├── app/                    # Fuente
├── public/                 # Servido por nginx
├── docs/                   # Documentación MkDocs
├── Dockerfile             # Build
├── nginx.conf             # Config
├── docker-compose.yml     # Orquestación
├── setup.sh               # Script
├── mkdocs.yml             # Docs config
└── README.md              # Guía
```

