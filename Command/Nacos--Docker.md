## Nacos--Docker

**Docker网络**

```shell
docker network create -d bridge --subnet 192.168.10.0/24 --gateway 192.168.10.1 MySQL
```

**nacos1**

```shell
docker run -d \
-p 8851:8848 \
-p 9851:9848 \
-v ./nacos1/conf:/home/nacos/conf \
-e NACOS_SERVERS="192.168.10.21:8848 192.168.10.22:8848 192.168.10.23:8848" \
--network MySQL \
--ip 192.168.10.21 \
--name nacos1 \
nacos/nacos-server:v2.2.0-slim
```

**nacos2**

```shell
docker run -d \
-p 8852:8848 \
-p 9852:9848 \
-v ./nacos2/conf:/home/nacos/conf \
-e NACOS_SERVERS="192.168.10.21:8848 192.168.10.22:8848 192.168.10.23:8848" \
--network MySQL \
--ip 192.168.10.22 \
--name nacos2 \
nacos/nacos-server:v2.2.0-slim
```

**nacos3**

```shell
docker run -d \
-p 8853:8848 \
-p 9853:9848 \
-v ./nacos3/conf:/home/nacos/conf \
-e NACOS_SERVERS="192.168.10.21:8848 192.168.10.22:8848 192.168.10.23:8848" \
--network MySQL \
--ip 192.168.10.23 \
--name nacos3 \
nacos/nacos-server:v2.2.0-slim
```

