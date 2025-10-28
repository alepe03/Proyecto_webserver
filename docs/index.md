# Proyecto Web Server

**Estudiante:** Alejandro  
**Asignatura:** DPL - Despliegue de Aplicaciones Web

---

## Resumen del proyecto

En este proyecto he configurado un servidor web usando nginx dentro de un contenedor Docker. La tarea consistía en crear un servidor que pueda servir archivos estáticos (HTML, CSS, JavaScript) desde una carpeta, y configurarlo para que funcione en localhost y con un dominio personalizado.

### Lo que he hecho

- Aplicación web con HTML, CSS y JavaScript
- Instalé nginx manualmente en un contenedor Docker
- Configuré nginx para servir archivos estáticos
- Probé que funciona en http://localhost
- Configuré un dominio personalizado para acceder

### Tecnologías que he usado

- **Docker** para crear el contenedor
- **nginx** como servidor web
- **HTML, CSS y JavaScript** para la aplicación
- **Ubuntu** como sistema operativo del contenedor

---

## Objetivos cumplidos

1. Crear una aplicación web con HTML, CSS y JavaScript
2. Instalar nginx desde cero en Docker (sin usar imagen pre-hecha)
3. Configurar nginx para servir archivos estáticos
4. Hacer que funcione en localhost
5. Configurar un dominio personalizado

---

## Estructura del proyecto

```
proyecto_webserver/
├── app/              # Código de mi aplicación
├── public/           # Archivos que sirve nginx
├── Dockerfile        # Instrucciones para crear el contenedor
├── nginx.conf       # Configuración de nginx
├── docker-compose.yml
└── docs/            # Esta documentación
```

---

## Cómo ejecutar el proyecto

Para levantar el servidor:

```bash
./setup.sh
```

O manualmente:
```bash
docker compose build
docker compose up -d
```

Después puedes acceder a:
- http://localhost para ver la aplicación
- http://miapp.local:1593 

---

## Navegación de la documentación

En esta documentación explico:
- [Fase 1](fases/fase1.md) - Preparar los archivos de la aplicación
- [Fase 2](fases/fase2.md) - Instalar nginx en Docker
- [Fase 3](fases/fase3.md) - Configurar nginx para localhost
- [Fase 4](fases/fase4.md) - Configurar dominio personalizado
- [Conclusión](conclusion.md) - Lo que he aprendido y dificultades
