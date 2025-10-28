# Proyecto WebServer

Proyecto de despliegue de servidor web con Nginx y documentación técnica.

## 📋 Descripción

Este proyecto incluye la configuración completa de un servidor web con Nginx, incluyendo:

- Configuración de servidor web con Nginx
- Documentación técnica completa con MkDocs
- Dockerización del proyecto
- Configuración de balanceo de carga y SSL

## 🚀 Inicio Rápido

### Prerrequisitos

- Docker y Docker Compose
- Python 3.x (para MkDocs)

### Instalación

1. Clona el repositorio:
```bash
git clone https://github.com/alepe03/Proyecto_webserver.git
cd Proyecto_webserver
```

2. Construye y ejecuta con Docker:
```bash
docker-compose up -d
```

3. Accede a la aplicación:
- Aplicación: http://localhost
- Documentación: https://alepe03.github.io/Proyecto_webserver/

## 📚 Documentación

La documentación completa está disponible en:
- **GitHub Pages**: https://alepe03.github.io/Proyecto_webserver/

### Estructura de la Documentación

- Fase 1: Preparación del servidor
- Fase 2: Instalación de componentes
- Fase 3: Configuración básica
- Fase 4: Configuración avanzada (SSL, balanceo de carga)
- Verificación del sistema
- Documentación de Docker

## 🛠️ Tecnologías Utilizadas

- **Nginx**: Servidor web y reverse proxy
- **MkDocs**: Generador de documentación estática
- **Material for MkDocs**: Tema para la documentación
- **Docker**: Contenedorización
- **Docker Compose**: Orquestación de contenedores

## 📁 Estructura del Proyecto

```
proyecto_webserver/
├── app/                # Aplicación web
├── docs/               # Documentación MkDocs
├── public/             # Archivos públicos
├── site/               # Site generado (gitignore)
├── nginx.conf          # Configuración de Nginx
├── Dockerfile          # Imagen Docker
├── docker-compose.yml  # Orquestación Docker
└── requirements.txt    # Dependencias Python
```

## 🔧 Desarrollo

Para generar la documentación localmente:

```bash
# Activar entorno virtual
source venv/bin/activate

# Instalar dependencias
pip install -r requirements.txt

# Servir documentación localmente
mkdocs serve

# Construir documentación
mkdocs build
```

## 📖 Verificación

Ejecuta los siguientes comandos para verificar la instalación:

> **Documentación en línea**: https://alepe03.github.io/Proyecto_webserver/

```bash
# Verificar que el servidor está corriendo
curl http://localhost

# Ver logs de Docker
docker-compose logs
```

## 👤 Autor

Alejandro

## 📄 Licencia

Este proyecto es para fines educativos.
