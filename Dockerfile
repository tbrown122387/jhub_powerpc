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
    python3-notebook \
    # R
    r-base \
    r-base-dev \
    # R system dependencies
    libxml2-dev \
    libcurl4-openssl-dev \
    libssl-dev \
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
    && apt-get remove -y python3-zmq \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Upgrade pip and install pyzmq
RUN python3 -m pip install --upgrade pip && \
    pip3 install --no-cache-dir pyzmq

# Copy requirements files
COPY requirements.txt /tmp/
COPY r-requirements.R /tmp/

# Install remaining Python packages
RUN pip3 install --no-cache-dir jupyterlab && \
    pip3 install --no-cache-dir -r /tmp/requirements.txt

# Install R packages
RUN Rscript /tmp/r-requirements.R

# Create entrypoint script
COPY entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/entrypoint.sh

# Expose the port Jupyter will run on
EXPOSE 8888

# Use entrypoint script
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]

