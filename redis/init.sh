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
192.168.123.81:6371 192.168.123.81:6372 192.168.123.81:6373 192.168.123.81:6374 192.168.123.81:6375 192.168.123.81:6376 \
--cluster-replicas 1
sleep 10
# 测试是否配置成功

docker exec -it redis-6371 redis-cli -a 123456 --cluster check redis-6371:6371