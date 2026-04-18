FROM openjdk:21-jdk

USER root

ENV PARAM="-Xms256m -Xmx256m"
WORKDIR /opt/arthas

# 下载 arthas tunnel server
RUN curl -L --fail --create-dirs \
    -o /opt/arthas/arthas-tunnel-server.jar \
    https://github.com/alibaba/arthas/releases/download/arthas-all-4.1.1/arthas-tunnel-server-4.1.1-fatjar.jar

EXPOSE 8080 7777

ENTRYPOINT ["/bin/sh", "-c", "java -jar /opt/arthas/arthas-tunnel-server.jar $PARAM"]