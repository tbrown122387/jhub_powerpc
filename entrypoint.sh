#!/bin/bash

# Add local user
# Either use the LOCAL_USER_ID if passed in at runtime or fallback to 9001
USER_ID=${LOCAL_USER_ID:-9001}
USER_NAME=${LOCAL_USER_NAME:-jupyter}

echo "Starting with UID : $USER_ID"
useradd --shell /bin/bash -u $USER_ID -o -c "" -m $USER_NAME

# Create jupyter config for this user
mkdir -p /home/$USER_NAME/.jupyter
jupyter notebook --generate-config --config=/home/$USER_NAME/.jupyter/jupyter_notebook_config.py

# Configure Jupyter
cat >> /home/$USER_NAME/.jupyter/jupyter_notebook_config.py << EOF
c.NotebookApp.ip = '0.0.0.0'
c.NotebookApp.allow_root = False
c.NotebookApp.open_browser = False
c.NotebookApp.certfile = '/home/$USER_NAME/ssl/jupyter.pem'
c.NotebookApp.keyfile = '/home/$USER_NAME/ssl/jupyter.key'
c.NotebookApp.allow_remote_access = True
c.NotebookApp.token = ''
c.NotebookApp.password = ''
c.NotebookApp.notebook_dir = '/home/$USER_NAME/work'
EOF

# Fix permissions
chown -R $USER_NAME:$USER_NAME /home/$USER_NAME

# Switch to user
exec gosu $USER_NAME jupyter notebook --no-browser --ip=0.0.0.0 --port=8888 