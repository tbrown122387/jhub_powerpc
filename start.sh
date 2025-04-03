#!/bin/bash

# Ensure we exit on any error
set -e

# Get user information and export for docker-compose
export LOCAL_USER_NAME=$(whoami)
export LOCAL_USER_ID=$(id -u)
export HOME=$(eval echo ~$LOCAL_USER_NAME)

# Verify variables are set
if [ -z "$LOCAL_USER_NAME" ]; then
    echo "Error: Failed to get username"
    exit 1
fi

if [ -z "$LOCAL_USER_ID" ]; then
    echo "Error: Failed to get user ID"
    exit 1
fi

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
echo "Running as user: $LOCAL_USER_NAME (ID: $LOCAL_USER_ID)" 