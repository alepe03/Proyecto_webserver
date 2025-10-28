#!/bin/bash

echo "Configurando proyecto webserver..."

# Verificar si Docker está instalado
if ! command -v docker &> /dev/null; then
    echo "Docker no está instalado. Por favor instálalo primero."
    exit 1
fi

# Verificar si Docker Compose está instalado
if ! docker compose version &> /dev/null; then
    echo "Docker Compose no está instalado. Por favor instálalo primero."
    exit 1
fi

# Configurar el archivo hosts
echo ""
echo "Configurando archivo /etc/hosts..."

# Verificar si ya existe la entrada
if grep -q "miapp.local" /etc/hosts; then
    echo "   Entrada 'miapp.local' ya existe en /etc/hosts"
else
    echo "   [ADVERTENCIA] Necesitas agregar 'miapp.local' a /etc/hosts manualmente:"
    echo "   sudo echo '127.0.0.1  miapp.local' >> /etc/hosts"
fi

echo ""
echo "Construyendo la imagen Docker..."
docker compose build

echo ""
echo "Iniciando el servidor..."
docker compose up -d

echo ""
echo "Servidor iniciado!"
echo ""
echo "Puedes acceder a:"
echo "   - http://localhost:80"
echo "   - http://miapp.local:1593"
echo ""
echo "Para ver los logs: docker compose logs -f"
echo "Para detener: docker compose down"
echo ""

