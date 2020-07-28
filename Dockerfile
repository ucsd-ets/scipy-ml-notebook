
FROM ucsdets/datahub-base-notebook:2020.2-stable

LABEL maintainer="UC San Diego ITS/ETS <its-ets-dsml@ucsd.edu>"

USER root

####### TEST
# RUN [ -z "$(apt-get indextargets)" ]
# RUN set -xe && \
# 	echo '#!/bin/sh' > /usr/sbin/policy-rc.d &&\
#     echo 'exit 101' >> /usr/sbin/policy-rc.d && \
# 	chmod +x /usr/sbin/policy-rc.d 	&& \
# 	dpkg-divert --local --rename --add /sbin/initctl && \
# 	cp -a /usr/sbin/policy-rc.d /sbin/initctl && \
# 	sed -i 's/^exit.*/exit 0/' /sbin/initctl && \
# 	echo 'force-unsafe-io' > /etc/dpkg/dpkg.cfg.d/docker-apt-speedup && \
# 	echo 'DPkg::Post-Invoke { "rm -f /var/cache/apt/archives/*.deb /var/cache/apt/archives/partial/*.deb /var/cache/apt/*.bin || true"; };' > /etc/apt/apt.conf.d/docker-clean && \
# 	echo 'APT::Update::Post-Invoke { "rm -f /var/cache/apt/archives/*.deb /var/cache/apt/archives/partial/*.deb /var/cache/apt/*.bin || true"; };' >> /etc/apt/apt.conf.d/docker-clean 	&& \
# 	echo 'Dir::Cache::pkgcache ""; Dir::Cache::srcpkgcache "";' >> /etc/apt/apt.conf.d/docker-clean && \
# 	echo 'Acquire::Languages "none";' > /etc/apt/apt.conf.d/docker-no-languages && \
# 	echo 'Acquire::GzipIndexes "true"; Acquire::CompressionTypes::Order:: "gz";' > /etc/apt/apt.conf.d/docker-gzip-indexes && \
# 	echo 'Apt::AutoRemove::SuggestsImportant "false";' > /etc/apt/apt.conf.d/docker-autoremove-suggests
# RUN mkdir -p /run/systemd && echo 'docker' > /run/systemd/container
# RUN apt-get update && apt-get install -y --no-install-recommends     gnupg2 curl ca-certificates &&     curl -fsSL https://developer.download.nvidia.com/compute/cuda/repos/ubuntu1804/x86_64/7fa2af80.pub | apt-key add - &&     echo "deb https://developer.download.nvidia.com/compute/cuda/repos/ubuntu1804/x86_64 /" > /etc/apt/sources.list.d/cuda.list &&     echo "deb https://developer.download.nvidia.com/compute/machine-learning/repos/ubuntu1804/x86_64 /" > /etc/apt/sources.list.d/nvidia-ml.list &&     apt-get purge --autoremove -y curl     && rm -rf /var/lib/apt/lists/*
# ENV CUDA_VERSION=10.2.89
# ENV CUDA_PKG_VERSION=10-2=10.2.89-1
# RUN apt-get update && apt-get install -y --no-install-recommends     cuda-cudart-$CUDA_PKG_VERSION     cuda-compat-10-2     && ln -s cuda-10.2 /usr/local/cuda &&     rm -rf /var/lib/apt/lists/*
# RUN echo "/usr/local/nvidia/lib" >> /etc/ld.so.conf.d/nvidia.conf &&     echo "/usr/local/nvidia/lib64" >> /etc/ld.so.conf.d/nvidia.conf
# ENV PATH=/usr/local/nvidia/bin:/usr/local/cuda/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
# ENV LD_LIBRARY_PATH=/usr/local/nvidia/lib:/usr/local/nvidia/lib64
# ENV NVIDIA_VISIBLE_DEVICES=all
# ENV NVIDIA_DRIVER_CAPABILITIES=compute,utility
# ENV NVIDIA_REQUIRE_CUDA=cuda>=10.2 brand=tesla,driver>=396,driver<397 brand=tesla,driver>=410,driver<411 brand=tesla,driver>=418,driver<419 brand=tesla,driver>=440,driver<441
# ENV NCCL_VERSION=2.7.6
# RUN apt-get update && apt-get install -y --no-install-recommends     cuda-libraries-$CUDA_PKG_VERSION     cuda-npp-$CUDA_PKG_VERSION     cuda-nvtx-$CUDA_PKG_VERSION     libcublas10=10.2.2.89-1     libnccl2=$NCCL_VERSION-1+cuda10.2     && apt-mark hold libnccl2     && rm -rf /var/lib/apt/lists/*
# ENV CUDNN_VERSION=7.6.5.32
# RUN apt-get update && apt-get install -y --no-install-recommends     libcudnn7=$CUDNN_VERSION-1+cuda10.2     && apt-mark hold libcudnn7 &&     rm -rf /var/lib/apt/lists/*
#######


######################################
# CLI (non-conda) CUDA compilers, etc.

# ENV CUDAREPO https://developer.download.nvidia.com/compute/cuda/repos/ubuntu1804/x86_64/cuda-repo-ubuntu1804_10.0.130-1_amd64.deb
# RUN P=/tmp/$(basename $CUDAREPO) && curl -s -o $P $CUDAREPO && dpkg -i $P && \
# 	apt-key adv --fetch-keys https://developer.download.nvidia.com/compute/cuda/repos/ubuntu1804/x86_64/7fa2af80.pub && \
# 	apt-get update && \
# 	apt-get install -y cuda-libraries-dev-10-0 cuda-compiler-10-0 cuda-minimal-build-10-0 cuda-command-line-tools-10-0 && \
# 	apt-get clean && \
# 	ln -s cuda-10.0 /usr/local/cuda && \
# 	ln -s /usr/lib64/nvidia/libcuda.so /usr/lib64/nvidia/libcuda.so.1 /usr/local/cuda/lib64/


# ###########################
# # Now the ML toolkits (cuda9 until we update our Nvidia drivers)

# ## cudatoolkit
# https://developer.nvidia.com/cuda-10.2-download-archive?target_os=Linux&target_arch=x86_64&target_distro=Ubuntu&target_version=1804&target_type=deblocal
# samples https://docs.nvidia.com/cuda/cuda-samples/index.html#cudalibraries

ENV CUDA_PKG_VERSION=10-2=10.2.89-1

# RUN apt-get install pciutils dkms -y
# RUN wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu1804/x86_64/cuda-ubuntu1804.pin && \
# 	mv cuda-ubuntu1804.pin /etc/apt/preferences.d/cuda-repository-pin-600 && \
# 	wget https://developer.nvidia.com/compute/cuda/10.1/Prod/local_installers/cuda-repo-ubuntu1810-10-1-local-10.1.105-418.39_1.0-1_amd64.deb && \
# 	dpkg -i cuda-repo-ubuntu1810-10-1-local-10.1.105-418.39_1.0-1_amd64.deb && \
# 	apt-key adv --fetch-keys https://developer.download.nvidia.com/compute/cuda/repos/ubuntu1804/x86_64/7fa2af80.pub && \
# 	apt-get update && \
# 	apt-get -y install cuda && \
# 	ln -s cuda-10.2 /usr/local/cuda && \
# 	ln -s /usr/lib64/nvidia/libcuda.so /usr/lib64/nvidia/libcuda.so.1 /usr/local/cuda/lib64/

# apt-get install -y cuda-libraries-dev-10-0 cuda-compiler-10-0 cuda-minimal-build-10-0 cuda-command-line-tools-10-0 && \

# Pre-generate font cache so the user does not see fc-list warning when
# importing datascience. https://github.com/matplotlib/matplotlib/issues/5836

# RUN conda install -c anaconda cudatoolkit=10.0

# RUN pip install --no-cache-dir datascience \
# 							   okpy \
# 							   PyQt5 \
# 							   tensorflow \
# 							   tensorboard==2.2.0 \
# 							   torch \
# 							   torchvision \
# 							   nltk \
# 							   scapy \
# 							   gym \
# 							   opencv-contrib-python-headless==3.4.5.20 \
# 							   jupyter-tensorboard

# # ## cudnn, nccl
# # # https://docs.nvidia.com/deeplearning/sdk/cudnn-install/index.html

# RUN mkdir /tmp/cuda && \
# 	curl https://developer.download.nvidia.com/compute/machine-learning/repos/ubuntu1804/x86_64/nvidia-machine-learning-repo-ubuntu1804_1.0.0-1_amd64.deb --output /tmp/cuda/nvidia-machine-learning-repo-ubuntu1804_1.0.0-1_amd64.deb && \
# 	dpkg -i /tmp/cuda/nvidia-machine-learning-repo-ubuntu1804_1.0.0-1_amd64.deb && \
# 	rm -rf /tmp/cuda

# RUN apt-get update -y
# RUN	apt-get install apt-utils \ 
# 				libcudnn7 \
# 				libcudnn7-dev \
# 				libnccl2 \
# 				libc-ares-dev \
# 				-y
# RUN apt autoremove -y && apt upgrade -y

# RUN pip install --upgrade --force-reinstall tensorflow-gpu && \
# 	jupyter tensorboard enable --sys-prefix

# install tensorflow1 environment
COPY ./kernels /usr/share/datahub/kernels
RUN chmod -R 777 /usr/share/datahub/kernels && \
	chown -R 1000:1000 /home/jovyan && \
	conda update -n base conda && \
	conda env create --file /usr/share/datahub/kernels/tf1.yaml && \
	conda init bash

RUN	conda run -n tensorflow1 /bin/bash -c "ipython kernel install --name=tensorflow1"

# 	conda env create --file /usr/share/datahub/kernels/tensorflow1/tf1.yaml
# RUN conda create --name tensorflow1 --clone base
# RUN conda init bash && \
# 	conda run -n tensorflow1 /bin/bash -c "pip install tensorflow==1.15 tensorboard==1.15 tensorflow-gpu==1.15; ipython kernel install --name=tensorflow1"

RUN rm -rf /home/jovyan/*.deb

COPY ./tests /usr/share/datahub/tests/scipy-ml-notebook

# RUN fix-permissions $CONDA_DIR

USER $NB_UID:$NB_GID
ENV PATH=/usr/local/cuda/bin${PATH:+:${PATH}}
ENV LD_LIBRARY_PATH=/usr/local/cuda/lib64