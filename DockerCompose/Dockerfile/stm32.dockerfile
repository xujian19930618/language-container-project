FROM ubuntu:24.04
LABEL authors="xujian"

# 使用阿里云镜像加速 apt
RUN sed -i 's|http://ports.ubuntu.com/ubuntu-ports/|http://mirrors.aliyun.com/ubuntu-ports/|g' /etc/apt/sources.list && \
    apt-get update && \
    apt-get install -y build-essential cmake git \
      gcc-arm-none-eabi \
      gdb-multiarch \
      openocd \
      python3 \
      unzip \
      vim \
      python3-pip \
      make \
      libusb-1.0-0-dev && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

ENTRYPOINT ["sleep", "360000"]