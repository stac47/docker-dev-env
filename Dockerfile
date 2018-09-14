FROM debian:testing

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update
RUN apt-get install -y build-essential git wget autotools-dev \
    autoconf libtool vim gdb htop sudo zsh debconf locales-all \
    locales

ENV TERM linux
RUN dpkg-reconfigure locales

RUN groupadd stac
RUN useradd --create-home --gid stac stac
RUN sudo -v -g stac -u stac
RUN echo "stac ALL=(ALL:ALL) NOPASSWD: ALL" >> /etc/sudoers

USER stac
WORKDIR /home/stac

RUN git clone https://github.com/stac47/stac-dot-files.git .stac-dot-file
RUN git -C .stac-dot-file submodule update --init --recursive
RUN ln -s .stac-dot-file/.vimrc .vimrc
RUN ln -s .stac-dot-file/.vim .vim
RUN ln -s .stac-dot-file/.zshrc .zshrc
RUN ln -s .stac-dot-file/.zshenv .zshenv
RUN ln -s .stac-dot-file/.gitconfig .gitconfig
RUN ln -s .stac-dot-file/.gitignore_global .gitignore_global

ENTRYPOINT /bin/zsh
