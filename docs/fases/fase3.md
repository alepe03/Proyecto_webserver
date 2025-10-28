# Fase 3: Configuración básica del servidor web

## Objetivo

Configurar nginx para que sirva mis archivos estáticos cuando accedo a localhost.

---

## Archivo de configuración

Creé el archivo `nginx.conf` que le dice a nginx cómo servir mis archivos:

```nginx
# Servidor para localhost
server {
    listen 80;
    server_name localhost;
    
    root /usr/share/nginx/html;
    
    # Ruta principal
    location / {
        try_files $uri $uri/ =404;
    }
    
    # Ruta de la app
    location /app/ {
        alias /usr/share/nginx/html/app/;
        try_files $uri $uri/ =404;
    }
    
    # Logs
    access_log /var/log/nginx/access.log;
    error_log /var/log/nginx/error.log;
}
```

---

## Qué significa

- `listen 80` - nginx escucha en el puerto 80
- `server_name localhost` - Esta configuración es para cuando accedas con localhost
- `root /usr/share/nginx/html` - Carpeta donde están mis archivos
- `location /` - Configuración para la ruta principal
- `location /app/` - Configuración especial para acceder a mi app
- `try_files` - Si no encuentra el archivo, devuelve 404
- Los logs registran todas las peticiones y errores

---

## Configurar los puertos

En el archivo `docker-compose.yml` mapeo el puerto:

```yaml
services:
  webserver:
    build: .
    ports:
      - "80:80"
```

Esto mapea el puerto 80 de mi ordenador al puerto 80 del contenedor, así puedo acceder con http://localhost

---

## Probar que funciona

Para verificar que todo funciona:

1. Abro el navegador
2. Voy a http://localhost
3. Debería ver mi página principal
4. Voy a http://localhost/app/
5. Debería ver mi aplicación

También puedo probar con curl:

```bash
curl http://localhost
```

Esto me muestra el HTML de la página.

Si quiero ver los headers:

```bash
curl -I http://localhost
```

Y debería mostrar: `Server: nginx/1.18.0` confirmando que es nginx quien responde.

---

## Dónde están los archivos

Los archivos están en `/usr/share/nginx/html/` dentro del contenedor.

Para ver los archivos dentro del contenedor:

```bash
docker compose exec webserver ls -la /usr/share/nginx/html/
```

---

**Configuración básica completa y funcionando**
