#!/bin/bash

# Exit on any error
set -e

# Create required directories with default values
mkdir -p /tmp/jupyter-notebooks/ssl

# Generate SSL certificate if it doesn't exist (using default paths)
if [ ! -f /tmp/jupyter-notebooks/ssl/jupyter.pem ]; then
    openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
        -keyout /tmp/jupyter-notebooks/ssl/jupyter.key \
        -out /tmp/jupyter-notebooks/ssl/jupyter.pem \
        -subj "/C=US/ST=State/L=City/O=Organization/CN=localhost"
fi

# Build the Docker image
echo "Building Jupyter notebook image..."
if docker-compose build; then
    echo "Jupyter image has been built successfully!"
else
    echo "Error: Failed to build Jupyter image"
    exit 1
fi 