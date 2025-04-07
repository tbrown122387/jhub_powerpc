# Use a base image that supports ppc64le architecture
FROM ubuntu:20.04

# Set timezone
ENV TZ=America/New_York
RUN ln -fs /usr/share/zoneinfo/$TZ /etc/localtime && \
    echo $TZ > /etc/timezone && \
    DEBIAN_FRONTEND=noninteractive apt-get update && apt-get install -y tzdata apt-utils

# Install system dependencies
RUN apt-get update && apt-get install -y \
    # Python
    python3 \
    python3-pip \
    python3-dev \
    python3-numpy \
    python3-scipy \
    python3-pandas \
    python3-markupsafe \
    python3-jinja2 \
    python3-matplotlib \
    python3-seaborn \
    python3-sklearn \
    # R
    r-base \
    r-base-dev \
    # R system dependencies
    libxml2-dev \
    libcurl4-openssl-dev \
    libssl-dev \
    # Additional R dependencies
    libfontconfig1-dev \
    libharfbuzz-dev \
    libfribidi-dev \
    libfreetype6-dev \
    libpng-dev \
    libtiff5-dev \
    libjpeg-dev \
    # Scientific computing dependencies
    libopenblas-dev \
    liblapack-dev \
    gfortran \
    # Build tools
    build-essential \
    cmake \
    pkg-config \
    # Additional dependencies
    libblas-dev \
    nodejs \
    npm \
    && apt-get remove -y python3-zmq python3-notebook python3-terminado \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Upgrade pip and install core dependencies
RUN python3 -m pip install --upgrade pip && \
    pip3 install --no-cache-dir pyzmq notebook terminado

# Install JupyterHub and dependencies
RUN python3 -m pip install --no-cache-dir \
    jupyterhub \
    jupyterlab \
    sudospawner \
    dockerspawner

# Copy requirements files
COPY requirements.txt /tmp/
COPY r-requirements.R /tmp/

# Install R packages
RUN Rscript /tmp/r-requirements.R

# Create jupyterhub config directory
RUN mkdir -p /etc/jupyterhub

# Copy configuration files
COPY jupyterhub_config.py /etc/jupyterhub/

# Create entrypoint script
COPY entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/entrypoint.sh

# Expose the port JupyterHub will run on
EXPOSE 8000

# Use entrypoint script
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]

