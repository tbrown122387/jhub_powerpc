# Start from jupyter scipy notebook base image
FROM jupyter/scipy-notebook:latest

USER root

# Install R and essential R packages
RUN apt-get update && apt-get install -y \
    r-base \
    r-base-dev \
    libxml2-dev \
    libcurl4-openssl-dev \
    libssl-dev \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Install IRkernel for Jupyter
RUN R -e "install.packages(c('IRkernel', 'tidyverse'), repos='http://cran.rstudio.com/')" \
    && R -e "IRkernel::installspec(user = FALSE)"

# Switch back to jovyan user (default jupyter user)
USER ${NB_UID}

# Install additional Python packages if needed
RUN pip install --no-cache-dir \
    pandas \
    numpy \
    matplotlib \
    seaborn \
    scikit-learn

# Create config directory
RUN mkdir -p ~/.jupyter

# Generate config file
RUN jupyter notebook --generate-config

# Configure Jupyter
RUN echo "c.NotebookApp.ip = '0.0.0.0'" >> ~/.jupyter/jupyter_notebook_config.py \
    && echo "c.NotebookApp.allow_root = False" >> ~/.jupyter/jupyter_notebook_config.py \
    && echo "c.NotebookApp.open_browser = False" >> ~/.jupyter/jupyter_notebook_config.py \
    && echo "c.NotebookApp.certfile = '/home/jovyan/ssl/jupyter.pem'" >> ~/.jupyter/jupyter_notebook_config.py \
    && echo "c.NotebookApp.keyfile = '/home/jovyan/ssl/jupyter.key'" >> ~/.jupyter/jupyter_notebook_config.py \
    && echo "c.NotebookApp.allow_remote_access = True" >> ~/.jupyter/jupyter_notebook_config.py \
    && echo "c.NotebookApp.token = ''" >> ~/.jupyter/jupyter_notebook_config.py \
    && echo "c.NotebookApp.password = ''" >> ~/.jupyter/jupyter_notebook_config.py

# Expose the port Jupyter will run on
EXPOSE 8888

# Start Jupyter notebook
CMD ["jupyter", "notebook", "--no-browser", "--ip=0.0.0.0", "--port=8888"]

