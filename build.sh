#!/bin/bash

# Create required directories
mkdir -p ~/jupyter-notebooks/ssl

# Generate SSL certificate if it doesn't exist
if [ ! -f ~/jupyter-notebooks/ssl/jupyter.pem ]; then
    openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
        -keyout ~/jupyter-notebooks/ssl/jupyter.key \
        -out ~/jupyter-notebooks/ssl/jupyter.pem \
        -subj "/C=US/ST=State/L=City/O=Organization/CN=localhost"
fi

# Build the Docker image
docker-compose build

echo "Jupyter image has been built successfully!" 