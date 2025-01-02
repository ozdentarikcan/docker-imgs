FROM ghcr.io/mmtftr/docker-pfresgo:latest

USER root
RUN apt-get update
RUN apt-get install openssh-server sudo curl tmux git -y
ARG PORT=65144

# change port and allow root login
RUN echo "Port ${PORT}" >> /etc/ssh/sshd_config
# RUN echo "LogLevel DEBUG3" >> /etc/ssh/sshd_config

RUN mkdir -p /run/sshd
RUN ssh-keygen -A

RUN service ssh start

EXPOSE ${PORT}

CMD ["/usr/sbin/sshd","-D", "-e"]
