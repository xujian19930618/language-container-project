
#
# ARG

# 基础镜像,当前新镜像是基于哪个镜像的
FROM openjdk:8-jdk

# 镜像维护者的姓名和邮箱地址
# MAINTAINER xujian xujian19930618@163.com

# 标记镜像信息，添加元数据
LABEL version=1.01.001 key=value

# 用来构建镜像过程中设置环境变量   ENV MY_PATH /usr/mytest
ENV VERSION 1.01.001

# 使用 USER 指定用户时，可以使用用户名、UID 或 GID，或是两者的组合
USER root:root

# 指定在创建容器后,终端默认登陆进来工作目录,一个落脚点 WORKDIR $MY_PATH
WORKDIR /opt/tomcat

# 指令可以指定 RUN、ENTRYPOINT、CMD 指令的 SHELL, Linux 中默认为 ["/bin/sh", "-c"]
SHELL ["/bin/sh", "-c"]

# 容器构建时需要运行的命令
RUN java -version

# 类似 ADD,拷贝文件和目录到镜像中,
# 将从构建上下文目录中<源路径>的文件/目录复制到新的一层镜像内的<目标路径位置>
# COPY src dest    /    COPY ["src","dest"]
COPY src /src

# 创建一个匿名数据卷挂载点
VOLUME ["/data"]

# 将宿主机目录下的文件拷贝进镜像且ADD命令会自动处理 URL 和解压 tar 压缩包
ADD tomcat.tar.gz /opt/tomcat

# 当前容器对外暴露出的端口
EXPOSE 8080


# 指定一个容器启动时要运行的命令
# Dockerfile中可以有多个CMD指令,但只有最后一个生效,CMD会被 docker run 之后的参数替换
CMD ["java", "version"]

# 指定一个容器启动时要运行的命令
# ENTRYPOINT 的目的和 CMD 一样, 都是在指定容器启动程序及参数
# ENTRYPOINT ["java", "version"]

# 健康检查
HEALTHCHECK NONE

# 指定退出的信号值
#STOPSIGNAL

# 创建子镜像时指定自动执行的操作指令
# 当构建一个被继承的 Dockerfile时运行命令,父镜像在被子继承后父镜像的 ONBUILD被触发
# ONBUILD









