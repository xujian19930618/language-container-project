## Redis--Docker

**Redis**

```shell
docker run -d \
-p 6381:6379 \
--network MySQL \
--ip 192.168.10.31 \
--name redis1 \
redis:latest
```

## Docker 部署 Redis

### (一)Docker 部署 Redis(单机版) 

- 拉取 Redis 镜像

  ```
  docker pull redis:6.0.8
  ```

- 创建 Redis 容器

  ```
  docker run -d -p 6379:6379 --name redis redis:6.0.8
  docker exec -it redis /bin/bash
  redis-cli
  ```

- 配置文件redis.conf

  ```
  开启redis验证    可选
  requirepass 123
  
  允许redis外地连接  必须
  注释掉 # bind 127.0.0.1
  
  daemonize no
  将daemonize yes注释起来或者 daemonize no设置，因为该配置和docker run中-d参数冲突，会导致容器一直启动失败
  
  开启redis数据持久化  appendonly yes  可选
  ```

- 创建 Redis 容器

  ```
  docker run  -p 6379:6379 --name myredis 
  	--privileged=true 
  	-v /app/redis/redis.conf:/etc/redis/redis.conf 
  	-v /app/redis/data:/data 
  	-d redis:6.0.8 
  	redis-server /etc/redis/redis.conf
  ```

- 进入容器,redis-cli连接

  ```
  docker exec -it myredis /bin/bash
  redis-cli
  ```

### (二)Docker 配置 Redis (集群)

```
1. 哈希取余分区(扩容所容麻烦,宕机)
2. 一致性哈希算法分区(数据倾斜)
3. 哈希槽分区
```

#### 1. 三主三从 Redis 集群配置

- 新建六个实例容器

  ```
  docker run -d  				// 创建容器
  	--name redis-node-1  	//容器名称
  	--net host 				//使用宿主机的 IP 和端口,默认
  	--privileged=true 		// 获取宿主机root 用户权限
  	-v /data/redis/share/redis-node-1:/data  // 容器卷 宿主机地址:docker 内部地址
  	redis:6.0.8 			// redis 镜像和版本号
  	--cluster-enabled yes 	// 开启 redis 集群
  	--appendonly yes 		// 开启持久化
  	--port 6381				// redis 端口号
  
  docker run -d 
  	--name redis-node-2 
  	--net host 
  	--privileged=true 
  	-v /data/redis/share/redis-node-2:/data 
  	redis:6.0.8 
  	--cluster-enabled yes 
  	--appendonly yes 
  	--port 6382
  
  docker run -d 
  	--name redis-node-3 
  	--net host 
  	--privileged=true 
  	-v /data/redis/share/redis-node-3:/data 
  	redis:6.0.8 
  	--cluster-enabled yes 
  	--appendonly yes 
  	--port 6383
  
  docker run -d 
  	--name redis-node-4 
  	--net host 
  	--privileged=true 
  	-v /data/redis/share/redis-node-3:/data 
  	redis:6.0.8 
  	--cluster-enabled yes 
  	--appendonly yes 
  	--port 6384
  	
  docker run -d 
  	--name redis-node-5
  	--net host 
  	--privileged=true 
  	-v /data/redis/share/redis-node-3:/data 
  	redis:6.0.8 
  	--cluster-enabled yes 
  	--appendonly yes 
  	--port 6385
  	
  docker run -d 
  	--name redis-node-6
  	--net host 
  	--privileged=true 
  	-v /data/redis/share/redis-node-3:/data 
  	redis:6.0.8 
  	--cluster-enabled yes 
  	--appendonly yes 
  	--port 6386
  ```

- 进入容器

  ```
  docker exec -it redis-node-1 /bin/bash
  ```

- 构建主从关系

  ```
  redis-cli --cluster 
  	create 192.168.111.147:6381 
  	192.168.111.147:6382 
  	192.168.111.147:6383 
  	192.168.111.147:6384 
  	192.168.111.147:6385 
  	192.168.111.147:6386 
  	--cluster-replicas 1 // 为每个master 创建一个 slave 节点
  ```

- 常用命令

  ```
  # -c 防止路由失效加参数 -c 
  redis-cli -p 6381 -c 
  # 查看集群状态
  cluster info
  cluster nodes 
  # 查看集群信息
  redis-cli --cluster check 192.168.111.147:6381
  ```

#### 2. 主从容错迁移

```
# 1. 停止 6381 
	docker stop redis-node-1
# 2. 查看集群信息
	cluster nodes
	redis-cli --cluster check 10.168.1.152:6382
# 3. 启动 6381
	docker start redis-node-1
# 4. 关闭6385
	docker stop redis-node-5
# 5. 再次启动 6385
	docker start redis-node-5
# 6. 查看集群状态
	redis-cli --cluster check IP:6381
```

#### 3. 主从扩容案例

```
# 1. 新建 6387、6388 两个节点 启动
	docker run -d 
		--name redis-node-7 
		--net host 
		--privileged=true 
		-v /data/redis/share/redis-node-7:/data 
		redis:6.0.8 
		--cluster-enabled yes 
		--appendonly yes 
		--port 6387
	docker run -d 
		--name redis-node-8
		--net host 
		--privileged=true 
		-v /data/redis/share/redis-node-7:/data 
		redis:6.0.8 
		--cluster-enabled yes 
		--appendonly yes 
		--port 6388
# 2. 进入 6387容器实例内部
	docker exec -it redis-node-7 /bin/bash
# 3. 将新增的6387作为master节点加入集群
	redis-cli --cluster add-node 新增IP地址:新增端口 集群节点头IP地址:端口
	redis-cli --cluster add-node 192.168.111.147:6387 192.168.111.147:6381
# 4. 查看集群状态(新节点没槽号)
	redis-cli --cluster check 真实IP地址:端口 6381
# 5. 重新分派槽号 （16384 / master 台数）
	redis-cli --cluster reshard IP地址:端口号  # 重新分派槽号
	redis-cli --cluster reshard 192.168.111.147:6381
# 6. 为主节点分配从节点 (主节点 6387 从节点 6388)
	redis-cli --cluster add-node ip:新slave端口 ip:新master端口 --cluster-slave --cluster-master-id 新主机节点ID
	redis-cli --cluster add-node 192.168.111.147:6388 192.168.111.147:6387 --cluster-slave --cluster-master-id 新主机节点编号
# 7. 查看集群信息
	redis-cli --cluster check 192.168.111.147:6382
```

#### 4. 主从所容案例

```
# 1. 查看集群 获取 6388节点 ID
	redis-cli --cluster check 192.168.111.147:6382
# 2. 从集群中删除 从节点 6388 节点
	redis-cli --cluster del-node ip:从机端口 从机6388节点ID
	redis-cli --cluster del-node 192.168.111.147:6388  7a874ed7a1a284a8
# 3. 查看集群信息
	redis-cli --cluster check 192.168.111.147:6382
# 4. 将6387槽号清空，重新分配
	redis-cli --cluster reshard 192.168.111.147:6381
# 5. 检查集群
	redis-cli --cluster check 192.168.111.147:6381
# 6. 删除 6388
	redis-cli --cluster del-node ip:端口 6387节点ID
	redis-cli --cluster del-node 192.168.111.147:6387  b9ba8144631451
# 7. 检查集群
	redis-cli --cluster check 192.168.111.147:6381
```

##
