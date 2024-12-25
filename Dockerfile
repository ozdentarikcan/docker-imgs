FROM anibali/pytorch:2.0.1-cuda11.8

USER root
RUN apt-get update
RUN apt-get install openssh-server sudo -y
ARG PORT=65142

# change port and allow root login
RUN echo "Port ${PORT}" >> /etc/ssh/sshd_config
# RUN echo "LogLevel DEBUG3" >> /etc/ssh/sshd_config

RUN mkdir -p /run/sshd
RUN ssh-keygen -A

RUN service ssh start

# init conda env
RUN conda init
RUN conda install pytorch torchvision torchaudio pytorch-cuda=12.1 -c pytorch -c nvidia
RUN pip install -q lightning click transformers goatools toml wget fastobo pydantic loguru

EXPOSE ${PORT}

CMD ["/usr/sbin/sshd","-D", "-e"]
