ARG BASE_CONTAINER=jupyter/scipy-notebook:2ce7c06a61a1
ARG DATAHUB_CONTAINER=ucsdets/datahub-base-notebook:2019.4.9

FROM $DATAHUB_CONTAINER as datahub

FROM $BASE_CONTAINER

LABEL maintainer="UC San Diego ITS/ETS <ets-consult@ucsd.edu>"

USER root

COPY --from=datahub /usr/share/datahub/scripts/* /usr/share/datahub/scripts/
RUN /usr/share/datahub/scripts/install-all.sh

######################################
# CLI (non-conda) CUDA compilers, etc.

ENV CUDAREPO https://developer.download.nvidia.com/compute/cuda/repos/ubuntu1804/x86_64/cuda-repo-ubuntu1804_10.0.130-1_amd64.deb
RUN P=/tmp/$(basename $CUDAREPO) && curl -s -o $P $CUDAREPO && dpkg -i $P && \
	apt-key adv --fetch-keys https://developer.download.nvidia.com/compute/cuda/repos/ubuntu1804/x86_64/7fa2af80.pub && \
	apt-get update && \
	apt-get install -y cuda-libraries-dev-10-0 cuda-compiler-10-0 cuda-minimal-build-10-0 cuda-command-line-tools-10-0 && \
	apt-get clean && \
	ln -s cuda-10.0 /usr/local/cuda && \
	ln -s /usr/lib64/nvidia/libcuda.so /usr/lib64/nvidia/libcuda.so.1 /usr/local/cuda/lib64/

# Pre-generate font cache so the user does not see fc-list warning when
# importing datascience. https://github.com/matplotlib/matplotlib/issues/5836
RUN pip install --no-cache-dir datascience okpy PyQt5 && \
	python -c 'import matplotlib.pyplot' && \
	conda remove --quiet --yes --force qt pyqt || true && \
	conda clean -tipsy

###########################
# Now the ML toolkits (cuda9 until we update our Nvidia drivers)
RUN conda install -c anaconda --yes  \
                cudatoolkit=10.0 \
                cudnn nccl \
		tensorboard=1.14.0 \
		tensorflow=1.14.0 \
		tensorflow-base=1.14.0 \
		tensorflow-gpu=1.14.0 \
                numpy=1.16.4 \
        && conda install -c pytorch --yes \
                pytorch \
                torchvision \
        && conda install --yes \
                nltk spacy \
        && conda clean -afy && fix-permissions $CONDA_DIR

# Install tensorboard plugin for Jupyter notebooks
RUN pip install --no-cache-dir jupyter-tensorboard && \
	jupyter tensorboard enable --sys-prefix

# Additional requirements
COPY pip-requirements.txt /tmp
RUN pip install --no-cache-dir -r /tmp/pip-requirements.txt  && \
	fix-permissions $CONDA_DIR

COPY --from=datahub /run_jupyter.sh /

######################################
# Install python packages unprivileged where possible
USER $NB_UID:$NB_GID
