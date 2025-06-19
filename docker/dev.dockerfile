FROM ubuntu:24.04

RUN apt update && apt install -y emacs make git curl
RUN curl -fssL https://deb.nodesource.com/setup_22.x -o nodesource_setup.sh | bash - \
  && apt install -y nodejs

WORKDIR /opt/my-emacs
ENTRYPOINT bash