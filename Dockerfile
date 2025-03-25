# Use a base image that supports ppc64le architecture
FROM ubuntu:20.04

# Set timezone to US Eastern Time (modify if needed)
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
    && rm -rf /var/lib/apt/lists/*

# Install NVM
ENV NVM_DIR=/root/.nvm
RUN curl -fsSL https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.4/install.sh | bash

# Install Node.js and npm using NVM
RUN bash -c "source $NVM_DIR/nvm.sh && nvm install 18 && nvm use 18 && nvm alias default 18"

# Set Node.js and npm in the PATH
ENV PATH="/root/.nvm/versions/node/v18.0.0/bin:$PATH"

# Verify Node.js and npm installation
RUN bash -c "source $NVM_DIR/nvm.sh && node -v && npm -v"

# Install yarn and configurable-http-proxy globally
RUN bash -c "source $NVM_DIR/nvm.sh && npm install -g yarn configurable-http-proxy"

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
RUN mamba install --yes jupyterhub-singleuser jupyterlab nbclassic "notebook>=7.2.2"

# Generate JupyterHub server configuration
RUN jupyterhub --generate-config

# Create required directories and set proper permissions
RUN mkdir -p /home/root && chmod -R 777 /home/root

# Clean up and fix permissions
RUN mamba clean --all -f -y && \
    jupyter lab clean || echo "Jupyter Lab Clean Failed (probably no staging directory)" && \
    rm -rf "/root/.cache/yarn" && \
    chmod -R 777 /root/miniconda3

# Expose the necessary ports (JupyterHub default is 8000)
EXPOSE 8000

# Default command to start JupyterHub
CMD ["jupyterhub"]

