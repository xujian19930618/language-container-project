FROM ubuntu:24.04
LABEL authors="xujian"

# 使用阿里云镜像加速 apt
RUN sed -i 's|http://ports.ubuntu.com/ubuntu-ports/|http://mirrors.aliyun.com/ubuntu-ports/|g' /etc/apt/sources.list && \
    apt-get update && \
    apt-get install -y \
        build-essential git bc bison flex libssl-dev \
        libncurses-dev u-boot-tools device-tree-compiler \
        cpio rsync wget curl unzip xz-utils \
        gcc-aarch64-linux-gnu g++-aarch64-linux-gnu \
        minicom screen tmux kmod dosfstools mtools \
        python3 python3-pip && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

ENTRYPOINT ["sleep", "360000"]