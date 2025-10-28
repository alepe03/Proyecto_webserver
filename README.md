# Proyecto Webserver

Proyecto con nginx instalado desde cero en Docker.

## 📁 Estructura del proyecto

```
proyecto_webserver/
├── app/                    # Archivos fuente de la aplicación
│   ├── index.html
│   ├── styles.css
│   └── app.js
├── public/                 # Archivos estáticos servidos por nginx
│   ├── index.html
│   └── app/               # Carpeta de la aplicación
│       ├── index.html
│       ├── styles.css
│       └── app.js
├── dist/                  # VACÍA - No se usa en este proyecto
├── Dockerfile             # Dockerfile para instalar nginx
├── nginx.conf            # Configuración de nginx
├── docker-compose.yml    # Configuración de Docker Compose
└── README.md             # Este archivo
```

## 🚀 Cómo usar

### 1. Construir la imagen Docker

```bash
docker compose build
```

### 2. Iniciar el servidor

```bash
docker compose up -d
```

### 3. Acceder a la aplicación

- **localhost** → http://localhost (puerto 80)
- **miapp.local** → http://miapp.local:1593 (necesitas configurar el archivo hosts primero)

### 4. Detener el servidor

```bash
docker compose down
```

## 🌐 Configurar acceso con dominio local

Para acceder con `miapp.local:1593`, necesitas modificar el archivo `/etc/hosts`:

### En macOS/Linux:

```bash
sudo nano /etc/hosts
```
    
Agrega esta línea:

```
127.0.0.1  miapp.local
```

Luego guarda y sal (Ctrl+X, Y, Enter).

Ahora podrás acceder a:
- http://localhost:80
- http://miapp.local:1593

## 📝 Comandos útiles

- **Ver logs**: `docker compose logs -f`
- **Reconstruir**: `docker compose up -d --build`
- **Entrar al contenedor**: `docker compose exec webserver bash`

## ⚙️ Configuración

El nginx está configurado para servir:
- `/` → Página principal
- `/app/` → La aplicación con los controles dinámicos

