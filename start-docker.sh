#!/bin/bash

# Check for docker-compose
if ! command -v docker-compose &> /dev/null; then
    echo "docker-compose is not installed"
    echo "Install it with: sudo apt install docker-compose"
    exit 1
fi

# Start Docker daemon if not running
if ! systemctl is-active --quiet docker; then
    echo "Starting Docker daemon..."
    sudo systemctl start docker
    
    # Wait for service to start
    echo "Waiting for Docker service to start..."
    sleep 5
fi

# Make sure docker socket is accessible
if [ ! -w "/var/run/docker.sock" ]; then
    echo "Fixing docker socket permissions..."
    sudo chmod 666 /var/run/docker.sock
fi

# Test Docker connection
if ! docker info &> /dev/null; then
    echo "Error: Still cannot connect to Docker daemon"
    echo "Trying to restart Docker service..."
    sudo systemctl restart docker
    sleep 5
fi

# Final check
if ! docker info &> /dev/null; then
    echo "Error: Could not establish connection to Docker daemon"
    echo "Please try manually: sudo systemctl restart docker"
    exit 1
fi

echo "Docker daemon is running and accessible"

# Verify docker-compose works
if ! docker-compose version > /dev/null 2>&1; then
    echo "Error: docker-compose is not working properly"
    exit 1
fi 