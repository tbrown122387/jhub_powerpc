#!/bin/bash

# Start Docker daemon if not running
if ! docker info > /dev/null 2>&1; then
    echo "Starting Docker daemon..."
    sudo systemctl start docker
fi

# Wait for Docker to be ready
while ! docker info > /dev/null 2>&1; do
    echo "Waiting for Docker daemon to be ready..."
    sleep 1
done

echo "Docker daemon is running" 