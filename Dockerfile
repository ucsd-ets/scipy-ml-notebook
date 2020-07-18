
FROM ucsdets/datahub-base-notebook:2020.2-stable

LABEL maintainer="UC San Diego ITS/ETS <ets-consult@ucsd.edu>"

USER root

######################################
# CLI (non-conda) CUDA compilers, etc.

ENV CUDAREPO https://developer.download.nvidia.com/compute/cuda/repos/ubuntu1804/x86_64/cuda-repo-ubuntu1804_10.2.89-1_amd64.deb
RUN P=/tmp/$(basename $CUDAREPO) && curl -s -o $P $CUDAREPO && dpkg -i $P && \
	apt-key adv --fetch-keys https://developer.download.nvidia.com/compute/cuda/repos/ubuntu1804/x86_64/7fa2af80.pub && \
	apt-get update && \
	apt-get install -y cuda-libraries-dev-10-0 cuda-compiler-10-0 cuda-minimal-build-10-0 cuda-command-line-tools-10-0 && \
	apt-get clean && \
	ln -s cuda-10.0 /usr/local/cuda && \
	ln -s /usr/lib64/nvidia/libcuda.so /usr/lib64/nvidia/libcuda.so.1 /usr/local/cuda/lib64/

# Pre-generate font cache so the user does not see fc-list warning when
# importing datascience. https://github.com/matplotlib/matplotlib/issues/5836
RUN pip install --no-cache-dir datascience \
							   okpy \
							   PyQt5 \
							   tensorflow \
							   tensorboard==2.2.0 \
							   torch \
							   torchvision \
							   nltk \
							   scapy \
							   gym \
							   opencv-contrib-python-headless==3.4.5.20

RUN	python -c 'import matplotlib.pyplot'

# # Install tensorboard plugin for Jupyter notebooks
RUN pip install --no-cache-dir jupyter-tensorboard && \
	jupyter tensorboard enable --sys-prefix

# ###########################
# # Now the ML toolkits (cuda9 until we update our Nvidia drivers)

# ## cudatoolkit
# # https://docs.nvidia.com/cuda/cuda-installation-guide-linux/index.html
# # samples https://docs.nvidia.com/cuda/cuda-samples/index.html#cudalibraries

RUN apt-get install pciutils dkms -y
RUN wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu1804/x86_64/cuda-ubuntu1804.pin && \
	mv cuda-ubuntu1804.pin /etc/apt/preferences.d/cuda-repository-pin-600 && \
	wget http://developer.download.nvidia.com/compute/cuda/10.2/Prod/local_installers/cuda-repo-ubuntu1804-10-2-local-10.2.89-440.33.01_1.0-1_amd64.deb && \
	dpkg -i cuda-repo-ubuntu1804-10-2-local-10.2.89-440.33.01_1.0-1_amd64.deb && \
	apt-key add /var/cuda-repo-10-2-local-10.2.89-440.33.01/7fa2af80.pub && apt-get -y install cuda

# ## cudnn, nccl
# # https://docs.nvidia.com/deeplearning/sdk/cudnn-install/index.html

ARG APIKEY
RUN mkdir /tmp/cuda
RUN	curl -H https://developer.download.nvidia.com/compute/machine-learning/repos/ubuntu1804/x86_64/nvidia-machine-learning-repo-ubuntu1804_1.0.0-1_amd64.deb --output /tmp/cuda/nvidia-machine-learning-repo-ubuntu1804_1.0.0-1_amd64.deb

RUN	dpkg -i /tmp/cuda/nvidia-machine-learning-repo-ubuntu1804_1.0.0-1_amd64.deb && \
	rm -rf /tmp/cuda

RUN apt-get update -y
RUN	apt-get install apt-utils \ 
				libcudnn7 \
				libcudnn7-dev \
				libnccl2 \
				libc-ares-dev \
				-y
RUN apt autoremove -y && apt upgrade -y

RUN pip install --upgrade --force-reinstall tensorflow-gpu
COPY ./tests /usr/share/datahub/tests/scipy-ml-notebook

RUN chown -R 1000:1000 /home/jovyan

# install tensorflow1 environment
COPY ./kernels /usr/share/datahub/kernels
RUN chmod -R 777 /usr/share/datahub/kernels/tensorflow1 && \
	conda update -n base conda && \
	conda env create --file /usr/share/datahub/kernels/tensorflow1/tf1.yaml

RUN conda init bash && \
	conda run -n tensorflow1 /bin/bash -c "ipython kernel install --name=tensorflow1"

RUN fix-permissions $CONDA_DIR
USER $NB_UID:$NB_GID
