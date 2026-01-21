## Elasticsearch--Docker安装

**步骤一**:获取elasticsearch镜像

```bash
docker pull docker.elastic.co/elasticsearch/elasticsearch:8.5.3
```

**步骤二**: docker网络创建

```bash
docker network create elastic
```

**步骤三**:Docker中启动Elasticsearch，为`elastic`用户生成密码并输出到终端

```bash
# docker run  --name es-node01 --net elastic -p 9200:9200 -p 9300:9300 -t docker.elastic.co/elasticsearch/elasticsearch:8.5.3
docker run -d \
	--name elasticsearch \
	--net MySQL \
	-p 9200:9200 \
	-p 9300:9300 \
	-it elasticsearch:8.5.3
	# -e "discovery.type=single-node" \ 7.0
```

**步骤四**: 终端查看密码或者进入容器

```bash
docker exec -it elasticsearch /usr/share/elasticsearch/bin/elasticsearch-reset-password -u elastic

# zuQ6BgIiEXZjI4DBBYtl
```

**步骤五**: 将`http_ca.crt`安全证书从Docker容器复制到本地机器

```bash
docker cp es01:/usr/share/elasticsearch/config/certs/http_ca.crt .
```

**步骤六**: 打开一个新的终端，并使用您从Docker容器复制的`http_ca.crt`文件进行身份验证调用，验证是否可以连接到Elasticsearch集群。在出现提示时输入`elastic`用户的密码。

```bash
curl --cacert http_ca.crt -u elastic https://localhost:9200
```

**步骤四**: 获取kibana镜像

```docker
docker pull docker.elastic.co/kibana/kibana:8.5.2
```

**步骤五**: 启动容器

```docker
docker run \
	--name kib-01 \
	--net elastic \
	-p 5601:5601 \
	docker.elastic.co/kibana/kibana:8.5.2
```



