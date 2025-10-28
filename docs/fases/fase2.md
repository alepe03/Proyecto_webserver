# Fase 2: Instalación del servidor web

## Objetivo

Instalar nginx en un contenedor Docker, eligiendo la distribución y el servidor web.

---

## Mis elecciones

### Sistema operativo: Ubuntu 22.04

**Por qué elegí Ubuntu:**
- Es muy conocido y tiene mucha documentación
- Es fácil de usar
- Tiene soporte a largo plazo
- Se usa mucho con Docker

Podría haber usado Alpine (más pequeño) pero Ubuntu me parece más fácil para empezar.

### Servidor web: nginx

**Por qué nginx en vez de Apache:**
- Es más ligero y rápido
- La configuración es más simple
- Funciona muy bien para archivos estáticos
- Es lo que usan muchos servicios modernos

Consideré Apache pero nginx me pareció más moderno y fácil de configurar para mi proyecto.

---

## Crear el Dockerfile

Creé un archivo `Dockerfile` con las instrucciones para instalar nginx:

```dockerfile
FROM ubuntu:22.04

# Evitar preguntas durante la instalación
ENV DEBIAN_FRONTEND=noninteractive

# Instalar nginx
RUN apt-get update && \
    apt-get install -y nginx && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Copiar mis archivos
COPY public/ /usr/share/nginx/html/
COPY nginx.conf /etc/nginx/sites-available/default

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
```

**Lo más importante:**
- Uso Ubuntu 22.04 como base
- Instalo nginx manualmente con `apt-get install nginx`
- Copio mis archivos a la carpeta de nginx
- Configuro nginx con mi archivo nginx.conf

---

## Lo más importante: NO usar imagen pre-hecha

Una parte importante del trabajo era instalar nginx manualmente, no usar una imagen que ya lo tuviera instalado.
        
```dockerfile
FROM ubuntu:22.04           # Sin nginx
RUN apt-get install -y nginx  # Lo instalo yo
```

Esto demuestra que realmente instalé nginx desde cero.

---

## Construir y ejecutar

Para construir la imagen de Docker:

```bash
docker compose build
```

Este comando lee el Dockerfile y crea la imagen con nginx instalado. Tarda unos 45-60 segundos la primera vez.

Para iniciar el contenedor:

```bash
docker compose up -d
```

---

## Verificar que funciona

Para comprobar que nginx está corriendo:

```bash
docker compose exec webserver nginx -v
```

Debería mostrar algo como: `nginx version: nginx/1.18.0`

También puedo verificar los procesos:

```bash
docker compose exec webserver ps aux | grep nginx
```

Y finalmente, probar si responde en el navegador abriendo http://localhost

---

## Comandos que usé

```bash
# Construir la imagen
docker compose build

# Iniciar el contenedor
docker compose up -d

# Ver los logs
docker compose logs -f

# Verificar versión de nginx
docker compose exec webserver nginx -v
```

---

**nginx instalado y funcionando**
    