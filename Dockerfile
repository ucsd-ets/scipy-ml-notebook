FROM ucsdets/datahub-base-notebook:2020.2-stable

USER root

# tensorflow, pytorch stable versions
# https://pytorch.org/get-started/previous-versions/
# https://www.tensorflow.org/install/source#linux

RUN conda install cudatoolkit=10.0 -y
RUN conda install cudnn -y
RUN conda install nccl -y

RUN pip install tensorflow-gpu==1.15 \
		datascience \
		PyQt5 \
		scapy \
		nltk \
		opencv-contrib-python-headless==3.4.5.20 \
		jupyter-tensorboard \
		opencv-python

RUN pip install torch==1.2.0 torchvision==0.4.0 -f https://download.pytorch.org/whl/torch_stable.html
RUN jupyter tensorboard enable --sys-prefix

COPY ./kernels /usr/share/datahub/kernels
RUN ls /usr/share/datahub/kernels
RUN conda env create --file /usr/share/datahub/kernels/ml-latest.yml

RUN conda init bash && \
	conda run -n ml-latest /bin/bash -c "pip install torch==1.5.0+cu101 torchvision==0.6.0+cu101 -f https://download.pytorch.org/whl/torch_stable.html; ipython kernel install --name=ml-latest"

#RUN fix-permissions $CONDA_DIR

USER $NB_UID:$NB_GID
