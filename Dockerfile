###############################################################################
# Setup the user and the environment
###############################################################################
# based on https://medium.com/faun/set-current-host-user-for-docker-container-4e521cef9ffc
ARG DOCKER_BASE_IMAGE=rocm/tensorflow
# this arguments will be overwritten by the
# host env vars
ARG USER=docker
ARG UID=1000
ARG GID=1000
ARG PW=password

# Import the base image
FROM $DOCKER_BASE_IMAGE

# Install the basic tools
RUN apt-get update -qyy && \
    apt-get install -qyy \
    build-essential\
    binutils-dev  \
    libunwind-dev \
    libblocksruntime-dev \
    liblzma-dev \
    libnuma-dev \
    wget curl tmux byobu htop nano vim 

# Using unencrypted password/ specifying password
RUN echo "${USER} ${UID} ${GID}" && useradd -m ${USER} --uid=${UID} && echo "${USER}:${PW}" | chpasswd

# Setup the user
USER ${UID}:${GID}
WORKDIR /home/${USER}
###############################################################################
# Actual app configuration
###############################################################################
RUN python3 -m pip install maturin

RUN curl https://sh.rustup.rs -sSf | sh -s -- -y \
    && python3 -m pip install --no-cache-dir cffi

ENV PATH /home/${USER}/.cargo/bin:$PATH

# Install the required rust version
RUN /home/${USER}/.cargo/bin/rustup default nightly-2020-06-01

RUN /home/${USER}/.cargo/bin/cargo install maturin
RUN /home/${USER}/.cargo/bin/cargo install cargo-fuzz
RUN /home/${USER}/.cargo/bin/cargo install honggfuzz

ADD requirements.txt /home/${USER}/requirements.txt
RUN python3 -m pip install -r /home/${USER}/requirements.txt

