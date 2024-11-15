#! /bin/bash
for port in $(seq 6371 6376); do
	mkdir -p ./data/redis/redis-cluster/$port/conf \
	&& PORT=$port envsubst < redis-cluster.tmpl | tee ./data/redis/redis-cluster/$port/conf/redis.conf \
	&& mkdir -p ./data/redis/redis-cluster/$port/data;
done

docker compose up -d
sleep 15
docker exec -it redis-6371 \
redis-cli -a 123456 --cluster create \
10.20.10.11:6371 10.20.10.12:6372 10.20.10.13:6373 4:6374 10.20.10.15:6375 10.20.10.16:6376 \
--cluster-replicas 1
sleep 10
# 测试是否配置成功

docker exec -it redis-6371 redis-cli -a 123456 --cluster redis-6371:6371