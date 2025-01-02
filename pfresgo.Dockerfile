FROM tensorflow/tensorflow:2.4.1-gpu

USER root

# Add NVIDIA repository keys and update
RUN apt-key adv --fetch-keys https://developer.download.nvidia.com/compute/cuda/repos/ubuntu1804/x86_64/3bf863cc.pub && \
  apt-get update

RUN apt-get install openssh-server sudo curl tmux git -y
ARG PORT=65142

# change port and allow root login
RUN echo "Port ${PORT}" >> /etc/ssh/sshd_config

RUN mkdir -p /run/sshd
RUN ssh-keygen -A

RUN service ssh start

# init conda env
# RUN curl -L -O "https://github.com/conda-forge/miniforge/releases/latest/download/Miniforge3-$(uname)-$(uname -m).sh"
# RUN bash Miniforge3-$(uname)-$(uname -m).sh -b -f
# Add conda to PATH and initialize
# ENV PATH="/root/miniforge3/bin:$PATH"
# RUN conda init bash && \
#   . /root/.bashrc && \
#   mamba init && \
#   mamba install numpy -y
RUN pip install --upgrade pip
RUN pip install --no-cache-dir -q lightning click transformers goatools toml wget fastobo pydantic loguru wandb tqdm einops wandb obonet fastobo h5py seaborn scikit-learn pydantic

EXPOSE ${PORT}

CMD ["/usr/sbin/sshd","-D", "-e"]
