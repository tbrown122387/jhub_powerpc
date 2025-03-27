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
git clone https://github.com/tbrown122387/jhub_powerpc.git
cd jhub_powerpc
docker build -t my-jupyter-ppc64le .
docker run -d -p 443:443 --name jhub my-jupyter-ppc64le
```

These are tentative things I do to try to set an admin password, but it hasn't been working lately...


```bash
sudo docker exec -it my-jupyterhub bash
useradd -m -s /bin/bash adminuser
passwd adminuser
apt update && apt install -y vim
vim /jupyterhub_config.py
```

and edit the file to have

```
c.Authenticator.admin_users = {"adminuser"}
c.Authenticator.allowed_users = {"adminuser"}
c.JupyterHub.authenticator_class = 'jupyterhub.auth.LocalAuthenticator'
```

then restart the container:
```
sudo docker restart jhub
```
