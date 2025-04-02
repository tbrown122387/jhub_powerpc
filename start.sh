#!/bin/bash

# Start the services
docker-compose up -d

# Get server IP
SERVER_IP=$(hostname -I | awk '{print $1}')

echo "Jupyter server is starting..."
echo "Your notebooks will be stored in: ${JUPYTER_NOTEBOOK_DIR:-$HOME/jupyter-notebooks}"
echo "Access Jupyter at: https://$SERVER_IP:${JUPYTER_PORT:-8888}"
echo ""
echo "To view the logs, run: docker-compose logs -f jupyter" 