# JupyterHub Docker Image for PowerPC (ppc64le)

This Docker image provides a JupyterHub environment designed to run on **PowerPC (ppc64le)** architecture. It includes a Miniconda installation with the necessary JupyterHub, JupyterLab, and notebook dependencies.

## Features
- **Miniconda**: Lightweight and flexible package management.
- **JupyterHub**: A multi-user environment for Jupyter notebooks.
- **JupyterLab**: Next-generation user interface for Jupyter notebooks.
- **Notebook**: Jupyter notebook support.
- **nbclassic**: Classic notebook support.
- **Built for PowerPC (ppc64le)**: Optimized to run on PowerPC architecture.

## Requirements
- Docker: To build and run the container.
- PowerPC-based system or a compatible architecture.

## Build Instructions

### Clone the repository

```bash
wget https://github.com/tbrown122387/jhub_powerpc/archive/refs/heads/main.zip
unzip main.zip -d ./
cd jhub_powerpc-main
```

Generate some (temporary ssl stuff)
```
openssl req -x509 -newkey rsa:4096 -keyout key.pem -out cert.pem -days 365 -nodes
```

then build and run the image:

```
docker build -t my-jupyter-ppc64le .
docker run -d -p 443:443 --name jhub my-jupyter-ppc64le
```
