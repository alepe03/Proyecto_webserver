# Fase 4: Configuración avanzada

## Objetivo

Configurar nginx para acceder a mi aplicación con un dominio personalizado `miapp.local:1593` en vez de solo localhost.

---

## Configurar nginx

Agregué un segundo bloque server en `nginx.conf` para el dominio personalizado:

```nginx
# Servidor para miapp.local
server {
    listen 80;
    server_name miapp.local;
    
    root /usr/share/nginx/html;
    
    # Servir los archivos de la app
    location / {
        try_files $uri $uri/ =404;
    }
    
    # Servir la app desde /app
    location /app/ {
        alias /usr/share/nginx/html/app/;
        try_files $uri $uri/ =404;
    }
    
    # Logs separados
    access_log /var/log/nginx/miapp_access.log;
    error_log /var/log/nginx/miapp_error.log;
}
```

La diferencia es el `server_name miapp.local` y los logs separados.

---

## Configurar puertos en Docker

Agregué el puerto 1593 en `docker-compose.yml`:

```yaml
services:
  webserver:
    build: .
    ports:
      - "80:80"     # Para localhost
      - "1593:80"   # Para miapp.local
```

Con esto puedo acceder en http://miapp.local:1593

---

## Configurar el archivo /etc/hosts

Para que mi ordenador reconozca `miapp.local`, necesito editar el archivo hosts.

**En macOS/Linux:**
```bash
sudo nano /etc/hosts
```

**En Windows:**
Editar: `C:\Windows\System32\drivers\etc\hosts`

**Agregar esta línea:**
```
127.0.0.1  miapp.local
```

Esto hace que cuando escriba `miapp.local` en el navegador, vaya a localhost (127.0.0.1).

---

## Probar que funciona

Después de configurar el archivo hosts, puedo acceder a http://miapp.local:1593 en el navegador y debería ver mi aplicación funcionando.

También puedo verificar con curl:

```bash
curl -I http://miapp.local:1593
```

Esto confirma que nginx responde con el dominio personalizado.

---

## Por qué es escalable

Lo bueno de esta configuración es que puedo agregar más aplicaciones fácilmente:

1. Agregar otro bloque `server` en nginx.conf con un nuevo nombre
2. Agregar otro puerto en docker-compose.yml
3. Agregar otra línea en /etc/hosts

Así nginx puede servir múltiples aplicaciones desde el mismo servidor, cada una con su propio dominio y puerto.

---

## Entregable

**Dominio personalizado funcionando: miapp.local:1593**  
**Configuración de /etc/hosts documentada**  
**nginx configurado para múltiples dominios**  
**Probado y funcionando**

La configuración avanzada está completa y demuestra que el servidor puede escalar para servir más aplicaciones.
