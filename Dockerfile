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



