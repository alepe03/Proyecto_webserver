# Configuración de nginx

Explicación detallada del archivo `nginx.conf` y sus directivas.

---

## Arquitectura de nginx

nginx utiliza el concepto de **"servidores virtuales"** para configurar múltiples sitios web en una sola instancia.

Cada bloque `server { }` define un servidor virtual que puede responder a diferentes dominios o puertos.

---

## Configuración Completa

```nginx
# Servidor 1: Para localhost
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

# Servidor 2: Para miapp.local
server {
    listen 80;
    server_name miapp.local;

    root /usr/share/nginx/html;
    index index.html;

    location / {
        try_files $uri $uri/ =404;
    }

    location /app/ {
        alias /usr/share/nginx/html/app/;
        try_files $uri $uri/ =404;
    }

    access_log /var/log/nginx/miapp_access.log;
    error_log /var/log/nginx/miapp_error.log;
}
```

---

## Directivas Principales

### `listen`

```nginx
listen 80;
```

**Propósito:** Puerto donde nginx escuchará conexiones HTTP.

**Valores comunes:**
- `80` - HTTP estándar
- `443` - HTTPS
- `8080` - HTTP alternativo

**En nuestro caso:** Escucha en puerto 80 para ambos servidores.

---

### `server_name`

```nginx
server_name localhost;
server_name miapp.local;
```

**Propósito:** Define a qué nombre de dominio responde este servidor.

**Funcionamiento:**
- Cliente solicita `http://localhost/` → usa primer servidor
- Cliente solicita `http://miapp.local/` → usa segundo servidor

**Notas:**
- Permite múltiples servidores en mismo puerto
- nginx elige según el header `Host` de la petición

---

### `root`

```nginx
root /usr/share/nginx/html;
```

**Propósito:** Directorio raíz donde nginx busca archivos estáticos.

**Ejemplo:**
- Cliente solicita `/index.html`
- nginx busca en: `/usr/share/nginx/html/index.html`

**Ubicación estándar:** `/usr/share/nginx/html/`

---

### `index`

```nginx
index index.html;
```

**Propósito:** Archivo por defecto cuando se accede a un directorio.

**Ejemplo:**
- Cliente solicita `http://localhost/`
- nginx sirve: `/usr/share/nginx/html/index.html`

---

## Bloques location

Los bloques `location` definen cómo nginx maneja diferentes rutas URL.

### Sintaxis

```nginx
location [modificador] patrón {
    # directivas
}
```

### location /

```nginx
location / {
    try_files $uri $uri/ =404;
}
```

**Propósito:** Configuración para la ruta raíz.

**`try_files $uri $uri/ =404`:**
1. Busca el archivo exacto (`$uri`)
2. Si no existe, busca como directorio (`$uri/`)
3. Si tampoco existe, devuelve error 404

**Ejemplo:**
- `/index.html` → devuelve archivo
- `/` → devuelve index.html
- `/noexiste` → error 404

---

### location /app/

```nginx
location /app/ {
    alias /usr/share/nginx/html/app/;
    try_files $uri $uri/ =404;
}
```

**Propósito:** Configurar rutas que terminan con `/`.

**`alias`:**
- Reescribe la URL para buscar en otro directorio
- `/app/` se convierte en `/usr/share/nginx/html/app/`

**Diferencia con `root`:**
- `root` - añade el path al root
- `alias` - reemplaza el location path

**Ejemplo:**
- Cliente solicita: `/app/index.html`
- nginx busca: `/usr/share/nginx/html/app/index.html`

---

## Logs

nginx puede registrar peticiones y errores en archivos de log.

### `access_log`

```nginx
access_log /var/log/nginx/access.log;
```

**Propósito:** Registra todas las peticiones HTTP recibidas.

**Formato del log:**
```
127.0.0.1 - - [27/Oct/2025:12:00:15 +0000] "GET /app/ HTTP/1.1" 200 616 "-" "curl/7.68.0"
```

**Campos:**
- IP del cliente
- Fecha y hora
- Método HTTP (GET, POST, etc.)
- URL solicitada
- Status code (200, 404, etc.)
- Tamaño de respuesta
- User-Agent

---

### `error_log`

```nginx
error_log /var/log/nginx/error.log;
```

**Propósito:** Registra errores del servidor.

**Ejemplos de errores registrados:**
- Archivos no encontrados (404)
- Errores de configuración
- Problemas de permisos

---

## Logs Separados por Dominio

En la configuración avanzada, cada dominio tiene sus propios logs:

```nginx
# Servidor localhost
access_log /var/log/nginx/access.log;
error_log /var/log/nginx/error.log;

# Servidor miapp.local
access_log /var/log/nginx/miapp_access.log;
error_log /var/log/nginx/miapp_error.log;
```

**Ventajas:**
- Separar tráfico por dominio
- Facilitar debugging
- Análisis independiente

---

## Procesamiento de Peticiones

### Flujo de una petición

1. **Cliente solicita:** `http://localhost/app/index.html`

2. **nginx recibe petición**
   - Puerto: 80
   - Host header: `localhost`

3. **nginx selecciona servidor**
   - Busca servidor con `server_name localhost`
   - Encuentra primer bloque `server`

4. **nginx busca location**
   - Busca location que coincida con `/app/index.html`
   - Encuentra `location /app/`

5. **nginx aplica alias**
   - Ruta: `/app/index.html`
   - Alias: `/usr/share/nginx/html/app/`
   - Busca: `/usr/share/nginx/html/app/index.html`

6. **nginx sirve archivo**
   - Encuentra archivo
   - Devuelve contenido
   - Responde: `200 OK`

7. **nginx registra**
   - Escribe en `access.log`
   - Si hay error, en `error.log`

---

## Variables Útiles de nginx

**`$uri`** - URI normalizado de la petición  
**`$request_uri`** - URI original de la petición  
**`$host`** - Header Host  
**`$remote_addr`** - IP del cliente  
**`$status`** - Status code HTTP  

---

## Mejores Prácticas

### 1. Organizar logs

```nginx
access_log /var/log/nginx/access.log;
error_log /var/log/nginx/error.log;
```

### 2. Manejar errores

```nginx
try_files $uri $uri/ =404;
```

### 3. Usar alias para subcarpetas

```nginx
location /app/ {
    alias /usr/share/nginx/html/app/;
}
```

### 4. Logs por dominio

```nginx
# Cada dominio con sus propios logs
access_log /var/log/nginx/sitio_access.log;
```

---

## Verificar Configuración

### Test de sintaxis

```bash
docker compose exec webserver nginx -t
```

**Salida:**
```
nginx: the configuration file /etc/nginx/nginx.conf syntax is ok
nginx: configuration file /etc/nginx/nginx.conf test is successful
```

### Recargar configuración

```bash
docker compose exec webserver nginx -s reload
```

---

## Conclusión

La configuración de nginx implementada:

-  Múltiples servidores virtuales
-  Rutas configurables
-  Logs separados
-  Manejo de errores
-  Arquitectura escalable

Esta configuración demuestra el dominio de nginx y capacidades profesionales de despliegue web.
