#!/bin/bash
set -e

ROLE=${ROLE:-bash}

# Hadoop 配置文件使用官方模板
cp $HADOOP_HOME/etc/hadoop/core-site.xml.template $HADOOP_HOME/etc/hadoop/core-site.xml
cp $HADOOP_HOME/etc/hadoop/hdfs-site.xml.template $HADOOP_HOME/etc/hadoop/hdfs-site.xml
cp $HADOOP_HOME/etc/hadoop/yarn-site.xml.template $HADOOP_HOME/etc/hadoop/yarn-site.xml
cp $HADOOP_HOME/etc/hadoop/mapred-site.xml.template $HADOOP_HOME/etc/hadoop/mapred-site.xml

# 启动 SSH 服务
service ssh start

# 初始化 HDFS（仅 NameNode）
if [ "$ROLE" = "namenode" ]; then
    if [ ! -d /hadoop/dfs/name/current ]; then
        hdfs namenode -format -force
    fi
fi

# 启动对应 Hadoop 服务
case "$ROLE" in
    namenode)
        hdfs namenode
        ;;
    datanode)
        hdfs datanode
        ;;
    resourcemanager)
        yarn resourcemanager
        ;;
    nodemanager)
        yarn nodemanager
        ;;
    *)
        bash
        ;;
esac