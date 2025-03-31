#!/bin/bash

# Default values
NOTEBOOK_DIR="$HOME/jupyter-notebooks"
PORT=8888
SERVER_IP=$(hostname -I | awk '{print $1}')  # Get the server's IP address

# Create notebook directory if it doesn't exist
mkdir -p "$NOTEBOOK_DIR"
mkdir -p "$NOTEBOOK_DIR/ssl"

# Generate SSL certificate if it doesn't exist
if [ ! -f "$NOTEBOOK_DIR/ssl/jupyter.pem" ]; then
    openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
        -keyout "$NOTEBOOK_DIR/ssl/jupyter.key" \
        -out "$NOTEBOOK_DIR/ssl/jupyter.pem" \
        -subj "/C=US/ST=State/L=City/O=Organization/CN=localhost"
fi

# Run the container
docker run -d \
    --name jupyter-server \
    -p 0.0.0.0:$PORT:8888 \
    -v "$NOTEBOOK_DIR":/home/jovyan/work \
    -v "$NOTEBOOK_DIR/ssl":/home/jovyan/ssl \
    --restart unless-stopped \
    jupyter-r-python

echo "Jupyter server is starting..."
echo "Your notebooks will be stored in: $NOTEBOOK_DIR"
echo "Access Jupyter at: https://$SERVER_IP:$PORT"
echo ""
echo "To view the logs, run: docker logs jupyter-server" 