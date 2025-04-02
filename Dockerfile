# Use a base image that supports ppc64le architecture
FROM ubuntu:20.04

# Set timezone
ENV TZ=America/New_York
RUN ln -fs /usr/share/zoneinfo/$TZ /etc/localtime && \
    echo $TZ > /etc/timezone && \
    DEBIAN_FRONTEND=noninteractive apt-get update && apt-get install -y tzdata

# Install system dependencies
RUN apt-get update && apt-get install -y \
    python3 \
    python3-pip \
    r-base \
    r-base-dev \
    libxml2-dev \
    libcurl4-openssl-dev \
    libssl-dev \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Install Python packages
RUN pip3 install --no-cache-dir \
    jupyter \
    jupyterlab \
    pandas \
    numpy \
    matplotlib \
    seaborn \
    scikit-learn

# Install IRkernel for Jupyter
RUN R -e "install.packages(c('IRkernel', 'tidyverse'), repos='http://cran.rstudio.com/')" \
    && R -e "IRkernel::installspec(user = FALSE)"

# Create jupyter user
RUN useradd -m -s /bin/bash jupyter

# Switch to jupyter user
USER jupyter
WORKDIR /home/jupyter

# Create config directory
RUN mkdir -p ~/.jupyter

# Generate config file
RUN jupyter notebook --generate-config

# Configure Jupyter
RUN echo "c.NotebookApp.ip = '0.0.0.0'" >> ~/.jupyter/jupyter_notebook_config.py \
    && echo "c.NotebookApp.allow_root = False" >> ~/.jupyter/jupyter_notebook_config.py \
    && echo "c.NotebookApp.open_browser = False" >> ~/.jupyter/jupyter_notebook_config.py \
    && echo "c.NotebookApp.certfile = '/home/jupyter/ssl/jupyter.pem'" >> ~/.jupyter/jupyter_notebook_config.py \
    && echo "c.NotebookApp.keyfile = '/home/jupyter/ssl/jupyter.key'" >> ~/.jupyter/jupyter_notebook_config.py \
    && echo "c.NotebookApp.allow_remote_access = True" >> ~/.jupyter/jupyter_notebook_config.py \
    && echo "c.NotebookApp.token = ''" >> ~/.jupyter/jupyter_notebook_config.py \
    && echo "c.NotebookApp.password = ''" >> ~/.jupyter/jupyter_notebook_config.py

# Expose the port Jupyter will run on
EXPOSE 8888

# Start Jupyter notebook
CMD ["jupyter", "notebook", "--no-browser", "--ip=0.0.0.0", "--port=8888"]

