FROM debian:testing

ENV DEBIAN_FRONTEND noninteractive
ENV TERM linux
ENV SHELL zsh

RUN apt-get update \
    && apt-get install -y \
        autoconf \
        autotools-dev \
        build-essential \
        debconf \
        elfutils \
        gdb \
        git \
        htop \
        libtool \
        locales \
        locales-all \
        man-db \
        python
        sudo \
        vim \
        wget \
        zsh \
    && dpkg-reconfigure locales

RUN groupadd user \
    && useradd --create-home --gid user user \
    && sudo -v -g user -u user \
    && echo "user ALL=(ALL:ALL) NOPASSWD: ALL" >> /etc/sudoers \
    && chsh --shell /bin/zsh user

USER user
WORKDIR /home/user

RUN git clone https://github.com/stac47/stac-dot-files.git .stac-dot-file \
    && git -C .stac-dot-file submodule update --init --recursive \
    && ln -s .stac-dot-file/.vimrc .vimrc \
    && ln -s .stac-dot-file/.vim .vim \
    && ln -s .stac-dot-file/.zshrc .zshrc \
    && ln -s .stac-dot-file/.zshenv .zshenv \
    && ln -s .stac-dot-file/.gitconfig .gitconfig \
    && ln -s .stac-dot-file/.gitconfig_common .gitconfig_common \
    && ln -s .stac-dot-file/.gitignore_global .gitignore_global

ENTRYPOINT /bin/zsh
