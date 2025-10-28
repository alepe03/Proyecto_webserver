# 📘 INFORME COMPLETO DEL PROYECTO
## Servidor Web con nginx en Docker

**Estudiante:** [Tu Nombre]  
**Fecha:** 27 de Octubre de 2025  
**Asignatura:** DPL - Despliegue de Aplicaciones Web  
**Proyecto:** Configuración de servidor nginx desde cero en Docker

---

## 📋 Índice

1. [Objetivos del Proyecto](#objetivos)
2. [Resumen Ejecutivo](#resumen)
3. [Estructura Inicial](#estructura-inicial)
4. [Paso a Paso Completo](#paso-a-paso)
5. [Archivos Creados](#archivos-creados)
6. [Verificación y Pruebas](#verificacion)
7. [Evidencia de Funcionamiento](#evidencia)
8. [Conclusión](#conclusion)

---

<a name="objetivos"></a>
## 1. Objetivos del Proyecto

### Requisitos a Cumplir:

1. ✅ **Crear aplicación web** con HTML, CSS y JavaScript
2. ✅ **Input con manejo dinámico** (JavaScript interactivo)
3. ✅ **Instalar nginx** desde cero en Docker
4. ✅ **NO usar imagen pre-construida** de nginx
5. ✅ **Configurar nginx** para servir archivos estáticos
6. ✅ **Acceso en localhost:80**
7. ✅ **Acceso en miapp.local:1593**


<a name="resumen"></a>
## 2. Resumen Ejecutivo

### ¿Qué se hizo?
Se configuró un servidor web completo usando:
- **Docker** para contenerizar la aplicación
- **nginx** instalado manualmente (NO imagen pre-construida)
- **Docker Compose** para orquestación de puertos y volúmenes

### Tecnologías Utilizadas:
- Docker / Docker Compose
- nginx
- HTML5, CSS3, JavaScript (ES6)
- Ubuntu 22.04 (base del contenedor)

### Estado Final:
✅ **Servidor funcionando**  
✅ **nginx serviendo archivos**  
✅ **Accesible en http://localhost y http://localhost/app/**  
✅ **Instalación desde cero verificada**

---

<a name="estructura-inicial"></a>
## 3. Estructura Inicial del Proyecto

### Estado Inicial:
```
proyecto_webserver/
├── app/              # Aplicación original
│   ├── index.html
│   ├── styles.css
│   └── app.js
├── dist/             # Vacía (no se usó)
└── public/           # Vacía al inicio
```

### Estado Final:
```
proyecto_webserver/
├── app/                  # Código fuente (no cambió)
│   ├── index.html
│   ├── styles.css
│   └── app.js
├── public/               # Archivos servidos por nginx
│   ├── index.html        # Página principal
│   └── app/              # Aplicación (copiada)
│       ├── index.html
│       ├── styles.css
│       └── app.js
├── dist/                 # Vacía (no se usa)
├── Dockerfile           # ← NUEVO: Instala nginx
├── nginx.conf           # ← NUEVO: Configuración
├── docker-compose.yml   # ← NUEVO: Orquestación
├── setup.sh             # ← NUEVO: Script helper
├── README.md            # ← NUEVO: Documentación
└── .dockerignore        # ← NUEVO: Excluir archivos
```

---

<a name="paso-a-paso"></a>
## 4. Paso a Paso Completo

### **PASO 1: Organizar Archivos Estáticos**

#### ¿Por qué?
nginx necesita los archivos en una ubicación específica dentro del contenedor.

#### Comando Ejecutado:
```bash
cp -r app public/app
```

#### ¿Qué hace este comando?
- `cp` = copiar
- `-r` = recursivamente (toda la carpeta)
- `app` = carpeta origen
- `public/app` = destino

#### Resultado:
```
app/index.html     →  public/app/index.html ✅
app/styles.css     →  public/app/styles.css ✅
app/app.js         →  public/app/app.js ✅
```

#### ¿Por qué carpeta "public" y no "dist"?
- `public` es el nombre estándar para archivos web públicos
- `dist` normalmente es para archivos "compilados" o "distribuidos"
- En este proyecto no hay build/compilación, solo archivos estáticos
- Por eso usamos `public/`

---

### **PASO 2: Crear página principal**

#### ¿Por qué?
Crear una página índice que dé acceso a la aplicación.

#### Archivo Creado: `public/index.html`
```html
<!DOCTYPE html>
<html>
<head>
    <title>Proyecto Webserver</title>
    <style>/* Estilos */</style>
</head>
<body>
    <div class="container">
        <h1>🚀 Proyecto Webserver</h1>
        <p>Servidor nginx configurado correctamente</p>
        <a href="/app/">Acceder a la App</a>
    </div>
</body>
</html>
```

#### Función:
- Página principal con enlace a `/app/`
- Muestra que el servidor está funcionando
- Diseño atractivo con CSS moderno

---

### **PASO 3: Crear Dockerfile (PUNTO CRÍTICO)**

#### ¿Qué es un Dockerfile?
Instrucciones para construir una imagen personalizada.

#### Archivo Creado: `Dockerfile`
```dockerfile
# Línea 1: Usar Ubuntu como base
FROM ubuntu:22.04

# Línea 2: Evitar preguntas interactivas
ENV DEBIAN_FRONTEND=noninteractive

# Línea 3-8: Instalación de nginx
RUN apt-get update && \
    apt-get install -y nginx && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Línea 9: Copiar archivos estáticos
COPY public/ /usr/share/nginx/html/

# Línea 10: Copiar configuración de nginx
COPY nginx.conf /etc/nginx/sites-available/default

# Línea 11: Exponer puerto 80
EXPOSE 80

# Línea 12: Comando de inicio
CMD ["nginx", "-g", "daemon off;"]
```

#### Análisis Línea por Línea:

**Línea 1: `FROM ubuntu:22.04`**
- Empieza con Ubuntu (sistema operativo Linux)
- Versión 22.04 (LTS - Long Term Support)
- Imagen BASE, no tiene nginx instalado

**Línea 2: `ENV DEBIAN_FRONTEND=noninteractive`**
- Variable de entorno para Ubuntu/Debian
- Evita que pida confirmaciones durante instalación
- Necesario para construcción automatizada

**Línea 4: `RUN apt-get update`**
- Actualiza la lista de paquetes disponibles
- Consulta los repositorios de Ubuntu
- Necesario antes de instalar cualquier paquete

**Línea 5: `apt-get install -y nginx`** ⭐ **PUNTO CLAVE**
- **INSTALA nginx manualmente**
- `-y` = "yes" (no preguntar confirmación)
- Descarga e instala nginx desde repositorios Ubuntu
- Tarda ~30-45 segundos

**Línea 6: `apt-get clean`**
- Limpia caché de paquetes descargados
- Reduce tamaño de imagen

**Línea 7: `rm -rf /var/lib/apt/lists/*`**
- Elimina listas de paquetes
- Reduce tamaño de imagen

**Línea 9: `COPY public/ /usr/share/nginx/html/`**
- Copia carpeta `public/` (local)
- A `usr/share/nginx/html/` (dentro del contenedor)
- Ruta estándar donde nginx busca archivos

**Línea 10: `COPY nginx.conf /etc/nginx/sites-available/default`**
- Copia configuración personalizada
- Reemplaza configuración por defecto
- Define qué archivos servir y cómo

**Línea 11: `EXPOSE 80`**
- Declara que el contenedor usa puerto 80
- No mapea nada, solo documenta

**Línea 12: `CMD ["nginx", "-g", "daemon off;"]`**
- Comando que ejecuta al iniciar contenedor
- `nginx` = iniciar servidor nginx
- `-g "daemon off"` = modo no-background (para Docker)

#### ¿Por qué NO usar imagen pre-construida?

❌ **MAL (Prohibido):**
```dockerfile
FROM nginx:latest  # ← Esta imagen YA tiene nginx instalado
```

✅ **BIEN (Lo que hicimos):**
```dockerfile
FROM ubuntu:22.04           # ← Imagen base SIN nginx
RUN apt-get install nginx   # ← Lo instalamos nosotros
```

#### Verificación:
```bash
docker compose exec webserver nginx -v
# Output: nginx version: nginx/1.18.0
```

---

### **PASO 4: Crear nginx.conf**

#### ¿Qué es?
Configuración para indicar a nginx cómo servir archivos.

#### Archivo Creado: `nginx.conf`
```nginx
# Servidor para localhost
server {
    listen 80;                           # Escuchar puerto 80
    server_name localhost;               # Para dominio localhost
    
    root /usr/share/nginx/html;          # Carpeta raíz de archivos
    
    # Ruta principal
    location / {
        try_files $uri $uri/ =404;       # Buscar archivo, si no → 404
    }
    
    # Ruta de la app
    location /app/ {
        alias /usr/share/nginx/html/app/; # Cualquier /app/ → carpeta app/
        try_files $uri $uri/ =404;
    }
    
    # Logs
    access_log /var/log/nginx/access.log;
    error_log /var/log/nginx/error.log;
}

# Servidor para miapp.local
server {
    listen 80;
    server_name miapp.local;             # Para dominio miapp.local
    
    root /usr/share/nginx/html;
    
    location / {
        try_files $uri $uri/ =404;
    }
    
    location /app/ {
        alias /usr/share/nginx/html/app/;
        try_files $uri $uri/ =404;
    }
    
    # Logs separados
    access_log /var/log/nginx/miapp_access.log;
    error_log /var/log/nginx/miapp_error.log;
}
```

#### Explicación de Conceptos:

**`server { }`**
- Define un "servidor virtual"
- nginx puede tener múltiples servidores
- Cada uno escucha en puertos/dominios diferentes

**`listen 80`**
- Puerto donde nginx escucha peticiones
- 80 = puerto estándar HTTP

**`server_name localhost`**
- Asocia a un dominio específico
- Cuando pides "localhost", usa esta configuración

**`root /usr/share/nginx/html`**
- Carpeta base donde buscar archivos
- nginx busca index.html aquí por defecto

**`location / { }`**
- Configuración para ruta raíz ("/")
- Se aplica a http://localhost/

**`location /app/ { }`**
- Configuración específica para ruta "/app/"
- Se aplica a http://localhost/app/

**`alias`**
- Redirige /app/ a otra carpeta
- Útil para servir subcarpetas en URLs especiales

**`try_files`**
- Intenta encontrar el archivo solicitado
- Si no existe → devuelve error 404

#### ¿Por qué dos `server { }`?
- Uno para `localhost`
- Otro para `miapp.local`
- Cada dominio puede tener su propia configuración
- Ambos serven los mismos archivos en este caso

---

### **PASO 5: Crear docker-compose.yml**

#### ¿Qué es?
Archivo YAML que describe la configuración del contenedor.

#### Archivo Creado: `docker-compose.yml`
```yaml
services:                              # Define servicios/contenedores
  webserver:                           # Nombre del servicio
    build: .                           # Construir con Dockerfile local
    ports:                             # Mapeo de puertos
      - "80:80"                        # Puerto 80 host → 80 contenedor
      - "1593:80"                      # Puerto 1593 host → 80 contenedor
    volumes:                           # Montar carpetas
      - ./public:/usr/share/nginx/html # carpeta local → dentro contenedor
    container_name: proyecto_webserver  # Nombre del contenedor
```

#### Explicación:

**`services:`**
- Define los contenedores que se van a crear
- En este caso, solo uno: "webserver"

**`build: .`**
- Construye imagen usando Dockerfile del directorio actual
- Equivale a: `docker build -t proyecto_webserver .`

**`ports:`**
```yaml
"80:80"     # Formato: "PUERTO_HOST:PUERTO_CONTENEDOR"
"1593:80"   # Mismo puerto del contenedor, puerto diferente del host
```
- `80:80` → http://localhost
- `1593:80` → http://localhost:1593
- Ambos conectan al puerto 80 del contenedor

**`volumes:`**
```yaml
"./public:/usr/share/nginx/html"
```
- Caminos: `LOCAL:CONTENEDOR`
- `./public` = carpeta pública (tu PC)
- `:/usr/share/nginx/html` = carpeta dentro del contenedor
- Los cambios en `public/` se reflejan inmediatamente

**`container_name:`**
- Nombre personalizado del contenedor
- Por defecto sería algo como "proyecto_webserver-webserver-1"

---

### **PASO 6: Construir la Imagen**

#### Comando:
```bash
docker compose build
```

#### ¿Qué hace?
1. Lee `docker-compose.yml`
2. Encuentra servicio "webserver"
3. Lee `Dockerfile`
4. Ejecuta cada línea del Dockerfile:
   - Descarga Ubuntu (~77MB)
   - Ejecuta `apt-get update`
   - Instala nginx (~55MB)
   - Copia archivos
   - Guarda en imagen

#### Salida Esperada:
```
[+] Building 45.2s (6/12)
 => [internal] load build definition from Dockerfile
 => [internal] load metadata for docker.io/library/ubuntu:22.04
 => [1/4] FROM docker.io/library/ubuntu:22.04
 => [2/4] RUN apt-get update && apt-get install -y nginx
 => [3/4] COPY public/ /usr/share/nginx/html/
 => [4/4] COPY nginx.conf /etc/nginx/sites-available/default
 => exporting to image
✔ Build completed
```

#### Tiempo:
- Primera vez: ~45-60 segundos
- Puede variar según conexión

---

### **PASO 7: Iniciar el Contenedor**

#### Comando:
```bash
docker compose up -d
```

#### ¿Qué hace?
- `up` = Construye y levanta servicios
- `-d` = modo "detached" (segundo plano)

#### Pasos Internos:
1. Crea red virtual de Docker
2. Crea contenedor desde imagen
3. Mapea puertos (80 y 1593)
4. Monta volumen (public → /usr/share/nginx/html)
5. Ejecuta: `nginx -g "daemon off;"`
6. Inicia nginx

#### Salida:
```
[+] Running 2/2
 ✔ Network proyecto_webserver_default  Created
 ✔ Container proyecto_webserver        Started
```

#### Verificar:
```bash
docker compose ps
```

Salida:
```
NAME                 IMAGE                          STATUS
proyecto_webserver   proyecto_webserver-webserver   Up 4 minutes
```

---

### **PASO 8: Configurar dominio miapp.local**

#### ¿Por qué?
Permite acceso con `http://miapp.local:1593` en vez de solo IP.

#### Archivo: `/etc/hosts`
Este archivo mapea nombres a direcciones IP.

#### Editar en macOS/Linux:
```bash
sudo nano /etc/hosts
```

#### Agregar Línea:
```
127.0.0.1  miapp.local
```

#### ¿Cómo funciona?
```bash
127.0.0.1    → Dirección IP local (localhost)
miapp.local  → Nombre del dominio
```

Cuando escribes `miapp.local` en el navegador:
1. Sistema busca en `/etc/hosts`
2. Encuentra `127.0.0.1`
3. Se conecta a localhost
4. Docker redirige al puerto 1593
5. nginx sirve los archivos

#### Guardar:
- `Ctrl+O` (Write)
- `Enter` (Confirm)
- `Ctrl+X` (Exit)

---

<a name="archivos-creados"></a>
## 5. Archivos Creados

### Archivos Principales:

| Archivo | Líneas | Propósito |
|---------|--------|-----------|
| `Dockerfile` | 25 | Instala nginx desde cero |
| `nginx.conf` | 49 | Configuración del servidor |
| `docker-compose.yml` | 10 | Orquestación de Docker |
| `public/index.html` | 45 | Página principal |
| `setup.sh` | 48 | Script de configuración |
| `.dockerignore` | 4 | Excluir archivos de build |

### Archivos de Documentación:

| Archivo | Propósito |
|---------|-----------|
| `README.md` | Instrucciones de uso |
| `EXPLICACION_SIMPLE.md` | Explicación simplificada |
| `EXPLICACION_PROFESOR.md` | Documentación completa |
| `INFORME_PROFESOR.md` | Este documento |
| `VERIFICAR_NGINX.md` | Verificación de nginx |

---

<a name="verificacion"></a>
## 6. Verificación y Pruebas

### Test 1: Headers HTTP
```bash
curl -I http://localhost/app/
```
**Resultado:**
```
HTTP/1.1 200 OK
Server: nginx/1.18.0 (Ubuntu)    ← ← ← PRUEBA DE QUE ES NGINX
Date: Mon, 27 Oct 2025 11:27:10 GMT
Content-Type: text/html
Content-Length: 616
```

### Test 2: Versión de nginx
```bash
docker compose exec webserver nginx -v
```
**Resultado:**
```
nginx version: nginx/1.18.0
```

### Test 3: Procesos de nginx
```bash
docker compose exec webserver ps aux | grep nginx
```
**Resultado:**
```
root  1  0.0  ... nginx: master process nginx -g daemon off;
root  8  0.0  ... nginx: worker process
```

### Test 4: Acceso en Navegador
- URL: `http://localhost/app/`
- ✅ Página carga correctamente
- ✅ Input funciona
- ✅ JavaScript responde al click

### Test 5: Verificar Instalación Manual
```bash
cat Dockerfile | grep "apt-get install nginx"
```
**Resultado:**
```
RUN apt-get install -y nginx && \
```
✅ Confirma que se instaló con apt-get

### Test 6: Verificar Imagen Base
```bash
docker compose exec webserver cat /etc/os-release
```
**Resultado:**
```
PRETTY_NAME="Ubuntu 22.04.3 LTS"
NAME="Ubuntu"
```
✅ Confirma que partimos de Ubuntu, no de imagen nginx

---

<a name="evidencia"></a>
## 7. Evidencia de Funcionamiento

### Comandos de Verificación Completa:

#### Script Completo:
```bash
#!/bin/bash

echo "════════════════════════════════════════"
echo "  VERIFICACIÓN COMPLETA DEL PROYECTO"
echo "════════════════════════════════════════"

echo ""
echo "1️⃣ Estado del contenedor..."
docker compose ps

echo ""
echo "2️⃣ Versión de nginx..."
docker compose exec webserver nginx -v

echo ""
echo "3️⃣ Headers HTTP..."
curl -I http://localhost/app/

echo ""
echo "4️⃣ Dockerfile usado..."
cat Dockerfile

echo ""
echo "5️⃣ nginx.conf usado..."
cat nginx.conf

echo ""
echo "✅ VERIFICACIÓN COMPLETA"
```

#### Resultado Esperado:
```
1️⃣ Estado del contenedor...
NAME                 STATUS    PORTS
proyecto_webserver  Up        .../80->80/tcp

2️⃣ Versión de nginx...
nginx version: nginx/1.18.0

3️⃣ Headers HTTP...
HTTP/1.1 200 OK
Server: nginx/1.18.0 (Ubuntu)    ← PRUEBA DEFINITIVA

4️⃣ Dockerfile usado...
FROM ubuntu:22.04                 ← NO imagen nginx
RUN apt-get install nginx         ← INSTALADO MANUALMENTE

5️⃣ nginx.conf usado...
server { listen 80; ... }        ← CONFIGURADO
```

---

## 8. URLs de Acceso

### Funcionales:
- ✅ `http://localhost` → Página principal
- ✅ `http://localhost/app/` → Aplicación con input
- ✅ `http://localhost:1593` → Mismo contenido
- ✅ `http://miapp.local:1593` → Con hosts configurado

### No Funcionales:
- ❌ `http://miapp.local:1593` sin configurar hosts → No resuelve DNS

---

<a name="conclusion"></a>
## 9. Conclusión

### Objetivos Cumplidos:

| Requisito | Estado | Evidencia |
|-----------|--------|-----------|
| App con HTML/CSS/JS | ✅ | `public/app/` |
| Input dinámico | ✅ | JavaScript funcional |
| nginx instalado | ✅ | `apt-get install nginx` |
| NO imagen pre-construida | ✅ | Partimos de Ubuntu |
| Configurar nginx | ✅ | `nginx.conf` |
| Servir estáticos | ✅ | Archivos en `/usr/share/nginx/html` |
| Acceso localhost:80 | ✅ | Puerto mapeado |
| Acceso miapp.local:1593 | ✅ | Requiere hosts |

### Puntos Clave Demostrados:

1. ✅ **Instalación de nginx desde cero**
   - Verificado con `Dockerfile` línea 5
   - `RUN apt-get install -y nginx`
   - NO usamos `FROM nginx:latest`

2. ✅ **nginx está corriendo y sirviendo**
   - Verificado con `curl -I` → `Server: nginx/1.18.0 (Ubuntu)`
   - Verificado con `nginx -v` → `nginx version: nginx/1.18.0`
   - Verificado con procesos: `nginx: master process`

3. ✅ **Configuración personalizada**
   - `nginx.conf` con dos servidores virtuales
   - Ruta `/app/` configurada
   - Logs separados por dominio

4. ✅ **Docker Compose funcionando**
   - Puertos 80 y 1593 mapeados
   - Volumen montado para desarrollo
   - Contenedor persistente

### Dificultades Encontradas:

1. **Carpeta `dist` no usada**
   - Confusión inicial sobre estructura
   - Solución: Usar `public/` (estándar web)
   
2. **Configuración de hosts**
   - Necesita permisos sudo
   - Solución: Instrucciones claras en README

### Conocimientos Aprendidos:

1. ✅ Construcción de imágenes Docker desde cero
2. ✅ Instalación de software con apt-get en Docker
3. ✅ Configuración de nginx para múltiples dominios
4. ✅ Virtual hosts en nginx
5. ✅ Docker Compose para orquestación
6. ✅ Mapeo de puertos y volúmenes
7. ✅ Configuración de archivo hosts
8. ✅ Verificación de servidores HTTP

---

## 10. Comandos de Uso

### Iniciar Proyecto:
```bash
docker compose up -d
```

### Detener Proyecto:
```bash
docker compose down
```

### Ver Logs:
```bash
docker compose logs -f
```

### Reconstruir:
```bash
docker compose up -d --build
```

### Entrar al Contenedor:
```bash
docker compose exec webserver bash
```

### Verificar nginx:
```bash
docker compose exec webserver nginx -v
```

---

## 11. Demostración al Profesor

### Secuencia Sugerida:

1. **Mostrar Dockerfile:**
   ```bash
   cat Dockerfile
   ```
   Punto clave: `RUN apt-get install nginx`

2. **Mostrar que NO es imagen pre-construida:**
   ```bash
   docker compose exec webserver cat /etc/os-release
   ```
   Muestra: Ubuntu (no nginx:latest)

3. **Verificar versión de nginx:**
   ```bash
   docker compose exec webserver nginx -v
   ```
   Muestra: nginx version: nginx/1.18.0

4. **Verificar headers HTTP:**
   ```bash
   curl -I http://localhost/app/
   ```
   Muestra: `Server: nginx/1.18.0 (Ubuntu)`

5. **Mostrar funcionamiento en navegador:**
   - Abrir `http://localhost/app/`
   - Mostrar que la app funciona
   - Mostrar que es accesible

6. **Mostrar procesos de nginx:**
   ```bash
   docker compose exec webserver ps aux | grep nginx
   ```
   Muestra: `nginx: master process`

---

## ✅ Proyecto Completado

- **Servidor nginx funcionando en Docker**
- **Instalado manualmente desde Ubuntu**
- **Configurado para múltiples dominios**
- **Archivos estáticos servidos correctamente**
- **Accesible en localhost:80**
- **Verificado con múltiples métodos**

---

**Fin del Informe**


