# SciPy / ML Jupyter Notebook

This Jupyter notebook is intended for use on the UCSD DataHub platform.

# Base Images

* [jupyter/scipy-notebook](https://hub.docker.com/r/jupyter/scipy-notebook)
* [ucsdets/datahub-base-notebook](https://hub.docker.com/r/ucsdets/datahub-base-notebook)

# Packages

**Ubuntu**

[Standard packages](https://hub.docker.com/r/ucsdets/datahub-base-notebook)

**Python**

| Package     | Version |
| ----------- | ------- |
| jupyterhub  | 1.0.0   |
| tensorboard | 1.12.2  |
| tensorflow  | 1.14    |
| numpy       | 1.16.4  |
| pytorch     | latest  |

**GPU Support**

CUDA 10.0

# Changes

**2019.4.1 (Fall 2019)**

* Updated Python packages:
  * tensorflow 1.14
  * numpy 1.16.4 (compatible with tf 1.14)
* Updated CUDA 9 -> CUDA 10.0
