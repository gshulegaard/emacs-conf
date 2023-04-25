FROM ubuntu:22.04

RUN apt update && apt install -y emacs make git curl
RUN curl -sL https://deb.nodesource.com/setup_18.x -o nodesource_setup.sh \
  && bash nodesource_setup.sh \
  && apt install -y nodejs

WORKDIR /opt/my-emacs
ENTRYPOINT bash