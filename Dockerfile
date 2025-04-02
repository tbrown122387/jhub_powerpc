# Use a base image that supports ppc64le architecture
FROM ubuntu:20.04

# Set timezone
ENV TZ=America/New_York
RUN ln -fs /usr/share/zoneinfo/$TZ /etc/localtime && \
    echo $TZ > /etc/timezone && \
    DEBIAN_FRONTEND=noninteractive apt-get update && apt-get install -y tzdata

# Install system dependencies
RUN apt-get update && apt-get install -y \
    wget \
    bzip2 \
    curl \
    ca-certificates \
    git \
    build-essential \
    && rm -rf /var/lib/apt/lists/*

# Install NVM
ENV NVM_DIR=/root/.nvm
RUN curl -fsSL https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.4/install.sh | bash

# Install Node.js and npm using NVM
RUN bash -c "source $NVM_DIR/nvm.sh && nvm install 18 && nvm use 18 && nvm alias default 18"

# Set Node.js and npm in the PATH
ENV PATH="/root/.nvm/versions/node/v18.20.7/bin:$PATH"

# Verify Node.js and npm installation
RUN bash -c "source $NVM_DIR/nvm.sh && node -v && npm -v"

# Install yarn and configurable-http-proxy globally
RUN bash -c "source $NVM_DIR/nvm.sh && npm install -g yarn configurable-http-proxy"

# Ensure configurable-http-proxy is available globally
RUN echo "export PATH=\$PATH:/root/.nvm/versions/node/v18.20.7/bin" >> /root/.bashrc

# Download and install Miniconda
RUN wget -q https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-ppc64le.sh && \
    chmod +x Miniconda3-latest-Linux-ppc64le.sh && \
    ./Miniconda3-latest-Linux-ppc64le.sh -b && \
    rm Miniconda3-latest-Linux-ppc64le.sh

# Add Miniconda to PATH
ENV PATH="/root/miniconda3/bin:$PATH"

# Ensure conda is available
RUN conda --version

# Install mamba using conda
RUN conda install mamba -c conda-forge -y

# Install JupyterHub and dependencies using mamba
RUN mamba install --yes jupyterhub-singleuser jupyterlab nbclassic "notebook>=7.2.2" jupyterhub[localauth]

# Create SSL directory
RUN mkdir -p /etc/jupyterhub/ssl

# Copy SSL certificate and key (Make sure you have these files before building)
COPY cert.pem /etc/jupyterhub/ssl/cert.pem
COPY key.pem /etc/jupyterhub/ssl/key.pem

# Set correct permissions for SSL files
RUN chmod 600 /etc/jupyterhub/ssl/cert.pem /etc/jupyterhub/ssl/key.pem

# Create JupyterHub config directory
RUN mkdir -p /etc/jupyterhub

# Generate JupyterHub server configuration with LocalAuthenticator
# NB: change "taylor" to your system username you're using outside of Docker
RUN echo "c.Authenticator.admin_users = {'taylor'}" > /etc/jupyterhub/jupyterhub_config.py && \
    echo "c.JupyterHub.authenticator_class = 'jupyterhub.auth.LocalAuthenticator'" >> /etc/jupyterhub/jupyterhub_config.py && \
    echo "c.LocalAuthenticator.create_system_users = True" >> /etc/jupyterhub/jupyterhub_config.py && \
    echo "c.JupyterHub.ip = '0.0.0.0'" >> /etc/jupyterhub/jupyterhub_config.py && \
    echo "c.JupyterHub.port = 443" >> /etc/jupyterhub/jupyterhub_config.py && \
    echo "c.JupyterHub.ssl_cert = '/etc/jupyterhub/ssl/cert.pem'" >> /etc/jupyterhub/jupyterhub_config.py && \
    echo "c.JupyterHub.ssl_key = '/etc/jupyterhub/ssl/key.pem'" >> /etc/jupyterhub/jupyterhub_config.py

# Expose SSL port
EXPOSE 443

# Ensure that the configurable-http-proxy path is set during JupyterHub startup
ENV PATH="/root/.nvm/versions/node/v18.20.7/bin:$PATH"

# Default command to start JupyterHub with SSL
CMD ["bash", "-c", "source $NVM_DIR/nvm.sh && exec npx configurable-http-proxy & exec jupyterhub --config /etc/jupyterhub/jupyterhub_config.py"]

