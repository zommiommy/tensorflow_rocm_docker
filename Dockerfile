FROM rocm/tensorflow

RUN apt-get update -qyy && \
    apt-get install -qyy \
    build-essential\
    binutils-dev  \
    libunwind-dev \
    libblocksruntime-dev \
    liblzma-dev \
    libnuma-dev \
    wget curl tmux byobu htop nano vim 

USER ${UID}:${GID}
WORKDIR /home/${USER}

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

