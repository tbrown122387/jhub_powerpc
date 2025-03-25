# Use a base image that supports ppc64le architecture
FROM ubuntu:20.04

# Install system dependencies including wget, curl, bzip2, ca-certificates, nodejs, npm
RUN apt-get update && apt-get install -y \
    wget \
    bzip2 \
    curl \
    ca-certificates \
    nodejs \
    npm \
    && rm -rf /var/lib/apt/lists/*

# Download Miniconda installer for ppc64le and install it
RUN wget -q https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-ppc64le.sh && \
    chmod +x Miniconda3-latest-Linux-ppc64le.sh && \
    ./Miniconda3-latest-Linux-ppc64le.sh -b && \
    rm Miniconda3-latest-Linux-ppc64le.sh

# Add Miniconda to PATH (make sure it's available for future commands)
ENV PATH="/root/miniconda3/bin:$PATH"

# Ensure conda is available
RUN /root/miniconda3/bin/conda --version

# Install mamba using conda (if it's not already installed)
RUN /root/miniconda3/bin/conda install mamba -c conda-forge

# Install JupyterHub and other dependencies using mamba
RUN /root/miniconda3/bin/mamba install --yes jupyterhub-singleuser \
    && /root/miniconda3/bin/mamba install --yes jupyterlab \
    && /root/miniconda3/bin/mamba install --yes nbclassic \
    && /root/miniconda3/bin/mamba install --yes notebook>=7.2.2

# Install configurable-http-proxy to handle JupyterHub traffic
RUN npm install -g configurable-http-proxy

# Generate JupyterHub server configuration
RUN /root/miniconda3/bin/jupyterhub --generate-config

# Clean up and fix permissions (with checks for required utilities)
RUN /root/miniconda3/bin/mamba clean --all -f -y && \
    /root/miniconda3/bin/jupyter lab clean && \
    rm -rf "/root/.cache/yarn" && \
    chmod -R 777 /root/miniconda3 && \
    chmod -R 777 /home/root

# Expose the necessary ports (JupyterHub default is 8000)
EXPOSE 8000

# Optional: Add a default command to start JupyterHub
CMD ["jupyterhub"]

