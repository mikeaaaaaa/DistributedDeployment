#! /bash/bin
# mkdir data
# chmod -R 777 ./data
docker compose up -d
# 这里必须等待一段时间，docker compose结束并不代表容器全部初始化成功，有些容器启动完成后还得执行一些列内置脚本，之后我们才能对其执行一些命令；
sleep 10
docker exec -it rabbitmaster bash -c "rabbitmqctl stop_app && rabbitmqctl reset && rabbitmqctl start_app && rabbitmq-plugins enable rabbitmq_stomp && rabbitmq-plugins enable rabbitmq_web_stomp"
docker exec -it rabbitslave1 bash -c "rabbitmqctl stop_app && rabbitmqctl reset && rabbitmqctl join_cluster --ram rabbit@host_master && rabbitmqctl start_app && rabbitmq-plugins enable rabbitmq_stomp && rabbitmq-plugins enable rabbitmq_web_stomp "
docker exec -it rabbitslave2 bash -c "rabbitmqctl stop_app && rabbitmqctl reset && rabbitmqctl join_cluster --ram rabbit@host_master && rabbitmqctl start_app && rabbitmq-plugins enable rabbitmq_stomp && rabbitmq-plugins enable rabbitmq_web_stomp && rabbitmqctl cluster_status"