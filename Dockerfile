FROM ucsdets/datahub-base-notebook:2021.2.2

USER root


RUN apt-get update && \
	apt-get install -y \
			libtinfo5 

RUN conda install cudatoolkit=11.2 \
				  cudnn \
				  nccl \
				  -y

# Install pillow<7 due to dependency issue https://github.com/pytorch/vision/issues/1712
RUN pip install --no-cache-dir  datascience \
								PyQt5 \
								scapy \
								nltk \
								opencv-contrib-python-headless \
								jupyter-tensorboard \
								opencv-python \
								pycocotools \
								"pillow<7" \
								tensorflow-gpu>=2.2 \
								torch \
								torchvision


COPY ./tests/ /usr/share/datahub/tests/scipy-ml-notebook
RUN chmod -R +x /usr/share/datahub/tests/scipy-ml-notebook && \
    chown -R 1000:1000 /home/jovyan && \
	chmod +x /run_jupyter.sh

RUN ln -s /usr/local/nvidia/bin/nvidia-smi /opt/conda/bin/nvidia-smi


USER $NB_UID:$NB_GID
ENV PATH=${PATH}:/usr/local/nvidia/bin
ENV LD_LIBRARY_PATH=/opt/conda/pkgs/cudatoolkit-11.2.2-he111cf0_8/lib/:${LD_LIBRARY_PATH}
