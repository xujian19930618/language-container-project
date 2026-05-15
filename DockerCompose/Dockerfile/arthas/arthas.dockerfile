FROM eclipse-temurin:17-jdk

WORKDIR /opt/arthas

# 安装最小工具集
RUN apt-get update && apt-get install -y curl procps unzip \
    && rm -rf /var/lib/apt/lists/*

# 下载离线包（避免运行时联网）
RUN curl -L -o arthas.zip \
    https://github.com/alibaba/arthas/releases/download/arthas-all-4.1.1/arthas-bin.zip

RUN unzip arthas.zip -d /opt/arthas && rm arthas.zip

COPY Dockerfile/arthas/start.sh /start.sh
RUN chmod +x /start.sh

# 创建非 root 用户（安全核心）
#RUN useradd -m arthas \
#    && chown -R arthas:arthas /opt/arthas
#
#USER arthas


#ENTRYPOINT ["/start.sh"]
CMD ["tail", "-f", "/dev/null"]