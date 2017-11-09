FROM ubuntu:16.04

RUN locale-gen en_US.UTF-8
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get -qq update && \
      sudo \
      wget \

RUN useradd -s /bin/zsh tester
ADD . /home/tester/Dotfiles
RUN chown -R tester:tester /home/tester && \
    echo 'tester ALL=(ALL) NOPASSWD:ALL' > /etc/sudoers.d/tester && \
    chmod 0440 /etc/sudoers.d/tester
USER tester

ENV HOME /home/tester

WORKDIR /home/tester/Dotfiles
RUN git submodule update --init
RUN ./install -i install
