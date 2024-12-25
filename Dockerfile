FROM pytorch/pytorch:2.5.1-cuda12.1-cudnn9-runtime

USER root
RUN apt-get update
RUN apt-get install openssh-server sudo curl -y
ARG PORT=65142

# change port and allow root login
RUN echo "Port ${PORT}" >> /etc/ssh/sshd_config
# RUN echo "LogLevel DEBUG3" >> /etc/ssh/sshd_config

RUN mkdir -p /run/sshd
RUN ssh-keygen -A

RUN service ssh start

# init conda env
RUN curl -L -O "https://github.com/conda-forge/miniforge/releases/latest/download/Miniforge3-$(uname)-$(uname -m).sh"
RUN bash Miniforge3-$(uname)-$(uname -m).sh
RUN mamba init
RUN mamba install pytorch torchvision torchaudio pytorch-cuda=12.1 -c pytorch -c nvidia
RUN pip install -q lightning click transformers goatools toml wget fastobo pydantic loguru

EXPOSE ${PORT}

CMD ["/usr/sbin/sshd","-D", "-e"]
