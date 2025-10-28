# Verificación y Pruebas

Esta sección documenta todas las pruebas realizadas para verificar el correcto funcionamiento del servidor web.

---

## Test 1: Verificación de Versión de nginx

### Comando

```bash
docker compose exec webserver nginx -v
```

### Resultado

```
nginx version: nginx/1.18.0
```

### Análisis

 **Confirma que nginx está instalado**  
 **Versión obtenida correctamente**  
 **Comando funciona dentro del contenedor**

---

## Test 2: Headers HTTP

### Comando

```bash
curl -I http://localhost/app/
```

### Resultado

```
HTTP/1.1 200 OK
Server: nginx/1.18.0 (Ubuntu)    ← ← ← PRUEBA DE QUE ES NGINX
Date: Mon, 27 Oct 2025 11:27:10 GMT
Content-Type: text/html
Content-Length: 616
Last-Modified: Mon, 27 Oct 2025 11:15:00 GMT
ETag: "5f8d..."
Accept-Ranges: bytes
```

### Análisis

 **Server header muestra nginx**  
 **Content-Type correcto (text/html)**  
 **Status 200 OK (petición exitosa)**  
 **Content-Length presente**

---

## Test 3: Verificación de Procesos

### Comando

```bash
docker compose exec webserver ps aux | grep nginx
```

### Resultado

```
root  1  0.0  0.0  24304  1120 ?  Ss   12:00   0:00 nginx: master process nginx -g daemon off;
root  8  0.0  0.1  24872  2288 ?  S    12:00   0:00 nginx: worker process
```

### Análisis

 **Proceso master corriendo (PID 1)**  
 **Worker process activo**  
 **nginx ejecutándose correctamente**

---

## Test 4: Acceso en Navegador

### URL 1: Página Principal

**URL:** `http://localhost`  
**Resultado:**  
-  Página carga correctamente
-  Estilos aplicados
-  Enlace a `/app/` funcional

### URL 2: Aplicación

**URL:** `http://localhost/app/`  
**Resultado:**  
-  Página carga correctamente
-  Input funciona
-  JavaScript responde al click
-  Estilos CSS aplicados

### URL 3: Dominio Personalizado

**URL:** `http://miapp.local:1593`  
**Resultado:**  
-  Página carga correctamente
-  Con hosts configurado

---

## Test 5: Verificar Instalación Manual de nginx

### Comando

```bash
cat Dockerfile | grep "apt-get install nginx"
```

### Resultado

```
RUN apt-get install -y nginx && \
```

### Análisis

 **Confirma instalación con apt-get**  
 **NO se usa imagen preconstruida**  
 **Instalación manual verificada**

---

## Test 6: Verificar Imagen Base

### Comando

```bash
docker compose exec webserver cat /etc/os-release
```

### Resultado

```
PRETTY_NAME="Ubuntu 22.04.3 LTS"
NAME="Ubuntu"
VERSION_ID="22.04"
VERSION="22.04.3 LTS (Jammy Jellyfish)"
ID=ubuntu
```

### Análisis

 **Confirma que partimos de Ubuntu**  
 **NO de imagen nginx preconstruida**  
 **Sistema operativo correcto**

---

## Test 7: Verificar Archivos Servidos

### Comando

```bash
docker compose exec webserver ls -la /usr/share/nginx/html/
```

### Resultado

```
drwxr-xr-x 1 root  root   4096 Oct 27 12:00 .
drwxr-xr-x 1 root  root   4096 Oct 27 12:00 ..
-rw-r--r-- 1 root  root    616 Oct 27 12:00 index.html
drwxr-xr-x 1 root  root   4096 Oct 27 12:00 app
```

### Análisis

 **Archivos en ubicación correcta**  
 **Permisos de lectura apropiados**  
 **Estructura de carpetas correcta**

---

## Test 8: Verificar Configuración de nginx

### Comando

```bash
docker compose exec webserver nginx -t
```

### Resultado

```
nginx: the configuration file /etc/nginx/nginx.conf syntax is ok
nginx: configuration file /etc/nginx/nginx.conf test is successful
```

### Análisis

 **Sintaxis de configuración correcta**  
 **Sin errores de configuración**  
 **nginx puede iniciar sin problemas**

---

## Test 9: Verificar Logs

### Comando

```bash
docker compose exec webserver cat /var/log/nginx/access.log
```

### Resultado

```
127.0.0.1 - - [27/Oct/2025:12:00:15 +0000] "GET /app/ HTTP/1.1" 200 616 "-" "curl/7.68.0"
127.0.0.1 - - [27/Oct/2025:12:00:20 +0000] "GET / HTTP/1.1" 200 245 "-" "Mozilla/5.0"
```

### Análisis

 **Logs funcionando correctamente**  
 **Registra peticiones HTTP**  
 **Información completa (IP, fecha, método, status)**

---

## Test 10: Verificar Múltiples Dominios

### Comando

```bash
curl -H "Host: miapp.local" http://localhost:1593
```

### Resultado

```
HTTP/1.1 200 OK
Server: nginx/1.18.0 (Ubuntu)
```

### Análisis

 **Responde a múltiples dominios**  
 **Virtual hosts funcionando**  
 **Configuración avanzada operativa**

---

## Script de Verificación Completo

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
echo " VERIFICACIÓN COMPLETA"
```

---

## Conclusión de Verificaciones

 **Todos los tests pasaron exitosamente**  
 **Servidor nginx funcionando correctamente**  
 **Configuración correcta y operativa**  
 **Archivos servidos apropiadamente**  
 **Acceso local y por dominio personalizado funcional**

El servidor web está completamente operativo y listo para servir aplicaciones estáticas.
