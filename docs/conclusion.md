# Conclusión

## Lo que he cumplido

He completado todos los requisitos del proyecto:

- Crear una aplicación web con HTML, CSS y JavaScript  
- Instalar nginx manualmente desde Ubuntu (sin usar imagen pre-hecha)  
- Configurar nginx para servir archivos estáticos  
- Hacer que funcione en localhost:80  
- Configurar un dominio personalizado miapp.local:1593

---

## Cómo verifiqué que funciona

Para demostrar que nginx está realmente instalado y funcionando:

```bash
curl -I http://localhost
```

Resultado:
```
HTTP/1.1 200 OK
Server: nginx/1.18.0 (Ubuntu)
```

También verifiqué la versión:
```bash
docker compose exec webserver nginx -v
```

Y accedí tanto con localhost como con miapp.local:1593 desde el navegador.

---

## Dificultades que encontré

### Qué carpeta usar: dist o public?

Al principio no sabía si usar `dist/` o `public/`. Después de investigar, usé `public/` porque es más estándar para archivos que sirve el servidor web. La carpeta `dist/` se usa más para archivos compilados.

### Configurar el archivo /etc/hosts

Tuve que editar el archivo hosts para que funcionara el dominio personalizado. En macOS fue fácil con `sudo nano /etc/hosts`, pero tuve que documentar cómo hacerlo también en Windows ya que es diferente.

La parte más difícil fue entender qué hacía cada línea del archivo nginx.conf al principio, pero con práctica y documentación lo fui entendiendo.

---

## Lo que aprendí

Lo más importante que aprendí fue:

**Docker y Dockerfiles:** Entendí cómo crear un Dockerfile que instala nginx desde cero en Ubuntu. Aprendí a usar comandos como `apt-get update` y `apt-get install` dentro del contenedor.

**Configuración de nginx:** Aprendí cómo configurar nginx con bloques `server` para servir diferentes dominios. Entendí qué significa `listen`, `server_name`, `location` y `alias`.

**Docker Compose:** Aprendí a usar docker-compose.yml para orquestar contenedores y mapear puertos. Es mucho más fácil que usar comandos docker largos.

**Configuración de hosts:** Aprendí cómo funciona el archivo /etc/hosts para crear dominios locales, algo que nunca había hecho antes.

**HTTP y servidores web:** Entendí mejor cómo funciona HTTP al ver los headers con curl, y aprendí a verificar que un servidor está respondiendo correctamente.

---

## Posibles mejoras

Si tuviera más tiempo, podría mejorar el proyecto de estas maneras:

1. **Agregar HTTPS** - Configurar certificados SSL para que sea más seguro
2. **Optimizar caché** - Agregar headers de caché para que los archivos se carguen más rápido
3. **Comprimir archivos** - Activar compresión gzip para reducir el tamaño de las respuestas
4. **Agregar más aplicaciones** - Servir varias aplicaciones desde el mismo servidor

Pero para este proyecto, lo que tengo es suficiente y funciona correctamente.

---

## Resultado final

**Servidor nginx funcionando en Docker**  
**Instalado manualmente desde Ubuntu**  
**Configurado para múltiples dominios**  
**Archivos estáticos servidos correctamente**  
**Accesible en localhost:80 y miapp.local:1593**  
**Verificado con curl y navegador**

Este proyecto me ha ayudado a entender mejor cómo funcionan los servidores web, Docker, y la configuración de nginx. Aunque fue un poco complicado al principio, al final conseguí hacerlo funcionar correctamente.
