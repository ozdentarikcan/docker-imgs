FROM nvcr.io/nvidia/pytorch:23.09-py3

USER root
RUN apt-get update
RUN apt-get install openssh-server sudo -y

# change port and allow root login
RUN echo "Port 65142" >> /etc/ssh/sshd_config
RUN echo "LogLevel DEBUG3" >> /etc/ssh/sshd_config

RUN mkdir -p /run/sshd
RUN ssh-keygen -A

RUN service ssh start

# init conda env
RUN conda init

EXPOSE 65142

CMD ["/usr/sbin/sshd","-D", "-e"]
