# Fase 1: Preparación del entorno web

## Objetivo

Organizar los archivos de mi aplicación web (HTML, CSS, JavaScript) en una carpeta para que nginx los pueda servir después.

---

## Estructura inicial

Al empezar el proyecto, ya tenía una aplicación en la carpeta `app/` con estos archivos:

```
app/
├── index.html    # Mi página principal
├── styles.css    # Estilos CSS
└── app.js        # JavaScript
```

También había una carpeta `public/` vacía.

---

## Copiar los archivos

Para que nginx pueda servir mi aplicación, copié los archivos a la carpeta public:

```bash
cp -r app public/app
```

Este comando copia toda la carpeta app dentro de public. Así me quedó:

```
public/
└── app/
    ├── index.html
    ├── styles.css
    └── app.js
```

### ¿Por qué public?

Usé la carpeta `public` porque es donde normalmente van los archivos que el servidor web sirve al público. La carpeta `dist` se usa más para archivos compilados, y como mi aplicación no necesita compilación, usé public.

---

## Crear una página principal

También creé un archivo `public/index.html` que es la página de inicio. Esta página tiene un enlace para acceder a mi aplicación.

La estructura final quedó así:

```
public/
├── index.html          # Página principal
└── app/
    ├── index.html
    ├── styles.css
    └── app.js
```

---

## Mi aplicación

Mi aplicación tiene HTML, CSS y JavaScript. Básicamente es una página con un input de texto donde el usuario puede escribir y ver cambios en tiempo real. Usa JavaScript para manejar la interactividad.

---

## Verificación

Para asegurarme de que todo estaba bien, listé los archivos:

```bash
ls -la public/app/
```

Y confirmé que todos los archivos estaban en su lugar: index.html, styles.css y app.js.

**Todo listo para servir con nginx**
