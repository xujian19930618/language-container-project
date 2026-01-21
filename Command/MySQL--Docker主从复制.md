## MySQL--Docker主从复制

**配置文件**: `my.cnf`

```mysql
# master
[mysqld]
# 服务器唯一id，默认值1
server-id=1
# 设置日志格式，默认值ROW
binlog_format=STATEMENT
# 二进制日志名，默认binlog
# log-bin=binlog
# 设置需要复制的数据库，默认复制全部数据库
#binlog-do-db=mytestdb
# 设置不需要复制的数据库
#binlog-ignore-db=mysql
#binlog-ignore-db=infomation_schema
```

```mysql
# slave1
[mysqld]
# 服务器唯一id，默认值1
server-id=2
# 设置日志格式，默认值ROW
binlog_format=STATEMENT
# 二进制日志名，默认binlog
# log-bin=binlog
# 设置需要复制的数据库，默认复制全部数据库
#binlog-do-db=mytestdb
# 设置不需要复制的数据库
#binlog-ignore-db=mysql
#binlog-ignore-db=infomation_schema
```

```mysql
# slave2
[mysqld]
# 服务器唯一id，默认值1
server-id=3
# 设置日志格式，默认值ROW
binlog_format=STATEMENT
# 二进制日志名，默认binlog
# log-bin=binlog
# 设置需要复制的数据库，默认复制全部数据库
#binlog-do-db=mytestdb
# 设置不需要复制的数据库
#binlog-ignore-db=mysql
#binlog-ignore-db=infomation_schema
```

**步骤二**: `Docker 网络`

```shell
docker network create --driver bridge --subnet 192.168.10.0/24 --gateway 192.168.10.1 MySQL
```

**步骤三**: `Docker 创建`

```shell
# master
docker run -d \
-p 3307:3306 \
-p 33070:33060 \
-v /Users/xujian/Docker/mysql/master/conf.d:/etc/mysql/conf.d \
-v /Users/xujian/Docker/mysql/master/data:/var/lib/mysql \
-e MYSQL_ROOT_PASSWORD=123456 \
--network MySQL \
--ip 192.168.10.11 \
--name mysql-master \
mysql:latest
```

```shell
# slave1
docker run -d \
-p 3309:3306 \
-p 33090:33060 \
-v /Users/xujian/Docker/mysql/slave1/conf.d:/etc/mysql/conf.d \
-v /Users/xujian/Docker/mysql/slave1/data:/var/lib/mysql \
-e MYSQL_ROOT_PASSWORD=123456 \
--network MySQL \
--ip 192.168.10.12 \
--name mysql-slave1 \
mysql:latest
```

```shell
# slave2
docker run -d \
-p 3309:3306 \
-p 33090:33060 \
-v /Users/xujian/Docker/mysql/slave2/conf.d:/etc/mysql/conf.d \
-v /Users/xujian/Docker/mysql/slave2/data:/var/lib/mysql \
-e MYSQL_ROOT_PASSWORD=123456 \
--network MySQL \
--ip 192.168.10.13 \
--name mysql-slave2 \
mysql:latest
```

**步骤四**: `master创建slave用户并授权`

```shell
CREATE USER 'slave'@'%' IDENTIFIED BY '123456';
GRANT REPLICATION SLAVE ON *.* TO 'slave'@'%';
FLUSH PRIVILEGES;
```

**步骤五**: slave1与slave2设置连接主库

```shell
CHANGE MASTER TO MASTER_HOST='192.168.10.11', 
MASTER_USER='slave',MASTER_PASSWORD='123456', MASTER_PORT=3306,
MASTER_LOG_FILE='binlog.000002',MASTER_LOG_POS=867,  # 命令 SHOW MASTER STATUS;
GET_MASTER_PUBLIC_KEY=1;## MySQL8密码需要:caching_sha2_password; MySQL8密码前不需要:mysql_native_password 

START SLAVE; # 启动从机的复制功能

SHOW SLAVE STATUS\G; # 查看状态（不需要分号） 
```

**其他**

```mysql
-- 在从机上执行。功能说明：停止I/O 线程和SQL线程的操作。
stop slave; 

-- 在从机上执行。功能说明：用于删除SLAVE数据库的relaylog日志文件，并重新启用新的relaylog文件。
reset slave;

-- 在主机上执行。功能说明：删除所有的binglog日志文件，并将日志索引文件清空，重新开始所有新的日志文件。
-- 用于第一次进行搭建主从库时，进行主库binlog初始化工作；
reset master;
```

