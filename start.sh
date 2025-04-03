#!/bin/bash

# Ensure we exit on any error
set -e

# Get user information and export for docker-compose
export USER=$(whoami)  # Using standard USER variable
export HOME=$(eval echo ~$USER)
export UID=$(id -u)    # Using standard UID variable

# Create SSL directory if it doesn't exist
mkdir -p $HOME/jupyter-notebooks/ssl

# Generate SSL certificate if it doesn't exist
if [ ! -f $HOME/jupyter-notebooks/ssl/jupyter.pem ]; then
    openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
        -keyout $HOME/jupyter-notebooks/ssl/jupyter.key \
        -out $HOME/jupyter-notebooks/ssl/jupyter.pem \
        -subj "/C=US/ST=State/L=City/O=Organization/CN=localhost"
fi

# Start the services
docker-compose up -d

# Get server IP
SERVER_IP=$(hostname -I | awk '{print $1}')

echo "Jupyter server is starting..."
echo "Your notebooks will be stored in: $HOME"
echo "Access Jupyter at: https://$SERVER_IP:${JUPYTER_PORT:-8888}"
echo ""
echo "To view the logs, run: docker-compose logs -f jupyter"
echo "Running as user: $USER (ID: $UID)" 