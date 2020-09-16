FROM ucsdets/datahub-base-notebook:2020.2-stable

USER root

# tensorflow, pytorch stable versions
# https://pytorch.org/get-started/previous-versions/
# https://www.tensorflow.org/install/source#linux

RUN conda install cudatoolkit=10.1 \
				  cudnn \
				  nccl \
				  -y

RUN pip install --no-cache-dir tensorflow \
								datascience \
								PyQt5 \
								scapy \
								nltk \
								opencv-contrib-python-headless \
								jupyter-tensorboard \
								opencv-python \
								pycocotools

# torch must be installed separately since it requires a non-pypi repo. See stable version above
RUN pip install --no-cache-dir torch==1.6.0+cu101 torchvision==0.7.0+cu101 -f https://download.pytorch.org/whl/torch_stable.html
RUN jupyter tensorboard enable --sys-prefix

COPY ./tests/ /usr/share/datahub/tests/scipy-ml-notebook
RUN chmod -R +x /usr/share/datahub/tests/scipy-ml-notebook

RUN chown -R 1000:1000 /home/jovyan

USER $NB_UID:$NB_GID
