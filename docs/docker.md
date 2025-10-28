# Docker

Explicación detallada del Dockerfile y docker-compose.yml utilizados en el proyecto.

---

## Dockerfile

El Dockerfile define cómo construir la imagen del contenedor con nginx instalado desde cero.

### Contenido Completo

```dockerfile
# Dockerfile para instalar nginx desde cero
FROM ubuntu:22.04

# Variables de entorno para evitar prompts interactivos
ENV DEBIAN_FRONTEND=noninteractive

# Instalar nginx
RUN apt-get update && \
    apt-get install -y nginx && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Copiar archivos estáticos
COPY public/ /usr/share/nginx/html/

# Copiar configuración de nginx
COPY nginx.conf /etc/nginx/sites-available/default

# Exponer puerto 80
EXPOSE 80

# Iniciar nginx
CMD ["nginx", "-g", "daemon off;"]
```

---

## Análisis del Dockerfile

### FROM ubuntu:22.04

```dockerfile
FROM ubuntu:22.04
```

**¿Qué hace?**
- Selecciona imagen base de Ubuntu 22.04
- Descarga la imagen si no existe localmente
- Establece punto de partida para el build

**¿Por qué Ubuntu?**
-  Amplia documentación
-  Fácil instalación de paquetes
-  Estabilidad LTS
-  Comunidad grande

**Alternativas consideradas:**
- Alpine Linux (más pequeña, pero menos familiar)
- Debian (similar a Ubuntu)

---

### ENV DEBIAN_FRONTEND=noninteractive

```dockerfile
ENV DEBIAN_FRONTEND=noninteractive
```

**¿Qué hace?**
- Configura variable de entorno
- Evita prompts interactivos durante instalación
- Necesario para build automatizado

**¿Por qué es necesario?**
- Durante `apt-get install`, Debian/Ubuntu puede pedir confirmaciones
- En Docker, no hay interacción del usuario
- Sin esto, el build fallaría

---

### RUN apt-get update

```dockerfile
RUN apt-get update && \
    apt-get install -y nginx && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*
```

**Descomposición del comando:**

**`apt-get update`**
- Actualiza lista de paquetes disponibles
- Consulta repositorios de Ubuntu
- Necesario antes de instalar cualquier paquete

**`apt-get install -y nginx`**
- ⭐ **PUNTO CRÍTICO:** Instala nginx manualmente
- `-y` = acepta todas las confirmaciones
- Descarga e instala nginx (~55MB)

**`apt-get clean`**
- Limpia caché de paquetes descargados
- Reduce tamaño de imagen

**`rm -rf /var/lib/apt/lists/*`**
- Elimina listas de paquetes
- Reduce tamaño de imagen

**¿Por qué && ?**
- Ejecuta comandos secuencialmente
- Si uno falla, se detiene el proceso
- Mejor práctica de Docker

---

### COPY public/ /usr/share/nginx/html/

```dockerfile
COPY public/ /usr/share/nginx/html/
```

**¿Qué hace?**
- Copia carpeta local `public/` al contenedor
- Destino: `/usr/share/nginx/html/` (ubicación estándar de nginx)

**Estructura resultante:**
```
/usr/share/nginx/html/
├── index.html
└── app/
    ├── index.html
    ├── styles.css
    └── app.js
```

---

### COPY nginx.conf

```dockerfile
COPY nginx.conf /etc/nginx/sites-available/default
```

**¿Qué hace?**
- Copia configuración personalizada
- Reemplaza configuración por defecto de nginx
- Define cómo nginx sirve archivos

**Ruta estándar:** `/etc/nginx/sites-available/default`

---

### EXPOSE 80

```dockerfile
EXPOSE 80
```

**¿Qué hace?**
- Documenta que el contenedor usa puerto 80
- NO mapea puertos (eso es de docker-compose)
- Solo informativo/metadata

**¿Por qué?**
- Buenas prácticas de documentación
- Indica a otros desarrolladores que usa puerto 80
- Docker puede usarlo para conexiones entre contenedores

---

### CMD ["nginx", "-g", "daemon off;"]

```dockerfile
CMD ["nginx", "-g", "daemon off;"]
```

**¿Qué hace?**
- Comando ejecutado al iniciar contenedor
- Inicia nginx en modo foreground

**Formato JSON array:**
- Forma preferida de especificar comando
- Evita interpretación del shell

**`nginx`:**
- Comando para iniciar nginx

**`-g "daemon off"`:**
- NO ejecuta nginx en background
- nginx corre en primer plano (necesario para Docker)
- Si fuera background, contenedor se cierra

---

## docker-compose.yml

Archivo de orquestación que define servicios, puertos y volúmenes.

### Contenido Completo

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

---

## Análisis de docker-compose.yml

### services

```yaml
services:
```

**¿Qué hace?**
- Define contenedores del proyecto
- Puede haber múltiples servicios

**En nuestro caso:**
- Un solo servicio: `webserver`

---

### webserver

```yaml
services:
  webserver:
```

**¿Qué hace?**
- Define servicio llamado "webserver"
- Nombre puede ser cualquier cosa

**Nomenclatura:**
- Uso snake_case por convención
- Descriptivo del propósito

---

### build

```yaml
build: .
```

**¿Qué hace?**
- Construye imagen desde Dockerfile en directorio actual
- Ejecuta `docker build .`

**Equivalente CLI:**
```bash
docker build -t proyecto_webserver .
```

**Notación:**
- `.` = directorio actual
- Busca Dockerfile en esa ubicación

---

### ports

```yaml
ports:
  - "80:80"
  - "1593:80"
```

**¿Qué hace?**
- Mapea puertos del host a puertos del contenedor

**Formato:** `"PUERTO_HOST:PUERTO_CONTENEDOR"`

**Puerto 1:**
- `80:80` → puerto 80 del host → puerto 80 del contenedor
- Acceso: `http://localhost`

**Puerto 2:**
- `1593:80` → puerto 1593 del host → puerto 80 del contenedor
- Acceso: `http://localhost:1593` o `http://miapp.local:1593`

**¿Por qué dos puertos?**
- Flexibilidad de acceso
- Diferentes URLs para mismo servicio
- Preparado para múltiples dominios

---

### volumes

```yaml
volumes:
  - ./public:/usr/share/nginx/html
```

**¿Qué hace?**
- Monta carpeta local en el contenedor
- Sincroniza archivos en ambas direcciones

**Formato:** `RUTA_LOCAL:RUTA_CONTENEDOR`

**Ventajas:**
- Cambios locales se reflejan inmediatamente
- No necesitas reconstruir imagen
- Desarrollo más rápido

**En producción:**
- Normalmente NO se usan volúmenes para contenido estático
- Se copian archivos en la imagen
- Más eficiente para despliegue

---

### container_name

```yaml
container_name: proyecto_webserver
```

**¿Qué hace?**
- Nombre personalizado del contenedor
- Por defecto sería: `proyecto-webserver-webserver-1`

**Ventajas:**
- Nombre más corto y descriptivo
- Fácil referenciar en comandos
- Evita nombres largos automáticos

---

## Comandos Relacionados

### Construir imagen

```bash
docker compose build
```

**¿Qué hace?**
- Lee docker-compose.yml
- Construye imagen según Dockerfile
- Guarda en cache local

---

### Iniciar servicios

```bash
docker compose up -d
```

**`-d`:** Modo detached (segundo plano)

**¿Qué hace?**
1. Construye si es necesario
2. Crea contenedor
3. Mapea puertos
4. Monta volúmenes
5. Ejecuta CMD del Dockerfile

---

### Ver estado

```bash
docker compose ps
```

**Salida:**
```
NAME                 STATUS          PORTS
proyecto_webserver   Up 2 minutes    0.0.0.0:80->80/tcp, 0.0.0.0:1593->80/tcp
```

---

### Ver logs

```bash
docker compose logs -f
```

**`-f`:** Follow (sigue actualizando)

---

### Detener servicios

```bash
docker compose down
```

**¿Qué hace?**
- Detiene contenedores
- Elimina redes
- NO elimina imágenes ni volúmenes

---

## Comparación: CLI vs Compose

### Con docker CLI

```bash
# Construir
docker build -t proyecto .

# Crear red
docker network create proyecto_network

# Ejecutar
docker run -d \
  --name proyecto_webserver \
  -p 80:80 \
  -p 1593:80 \
  -v ./public:/usr/share/nginx/html \
  proyecto
```

### Con docker-compose

```bash
docker compose up -d
```

** Más simple**  
** Más legible**  
** Versionable**  
** Reproducible**

---

## Conclusión

La configuración de Docker implementada:

-  Instalación de nginx desde cero
-  Imagen base Ubuntu
-  Múltiples puertos expuestos
-  Volúmenes para desarrollo
-  Nombre personalizado
-  Comandos optimizados

Demuestra comprensión profunda de Docker y docker-compose.
