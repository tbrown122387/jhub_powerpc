#!/bin/bash

# Check if password is provided
if [ -z "${JUPYTER_PASSWORD}" ]; then
    echo "Error: JUPYTER_PASSWORD environment variable is not set"
    exit 1
fi

# Generate the password hash
python -c "from jupyter_server.auth import passwd; print(passwd('${JUPYTER_PASSWORD}'))" > ~/.jupyter/password.txt

# Add password config
echo "c.NotebookApp.password = open('/home/jovyan/.jupyter/password.txt').read().strip()" >> ~/.jupyter/jupyter_notebook_config.py

# Start Jupyter notebook
exec jupyter notebook --no-browser --ip=0.0.0.0 --port=8888 