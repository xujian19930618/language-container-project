# ARM64 原生 OpenJDK 17
FROM --platform=linux/arm64 openjdk:17-slim-bullseye

ARG HADOOP_VERSION=3.3.6

# 安装依赖工具（编译 + 运行）
RUN apt-get update && apt-get install -y \
    curl wget ssh rsync vim net-tools iputils-ping maven python3 git \
    && rm -rf /var/lib/apt/lists/*

# 下载 Hadoop 官方二进制包
RUN curl -O https://downloads.apache.org/hadoop/common/hadoop-${HADOOP_VERSION}/hadoop-${HADOOP_VERSION}.tar.gz \
    && tar -xzf hadoop-${HADOOP_VERSION}.tar.gz -C /opt/ \
    && mv /opt/hadoop-${HADOOP_VERSION} /opt/hadoop \
    && rm hadoop-${HADOOP_VERSION}.tar.gz

# 设置环境变量
ENV HADOOP_HOME=/opt/hadoop
ENV PATH=$PATH:$HADOOP_HOME/bin:$HADOOP_HOME/sbin
ENV JAVA_HOME=/usr/local/openjdk-17

# SSH 配置
RUN mkdir /root/.ssh && ssh-keygen -q -N "" -t rsa -f /root/.ssh/id_rsa \
    && cat /root/.ssh/id_rsa.pub >> /root/.ssh/authorized_keys

# 拷贝官方 log4j
COPY log4j.properties /opt/hadoop/etc/hadoop/log4j.properties

# 拷贝 entrypoint
COPY entrypont.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

WORKDIR /opt/hadoop
ENTRYPOINT ["/entrypoint.sh"]