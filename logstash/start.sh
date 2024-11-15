#! /bin/bash
elastic_password=$(sed -n 's/.*elastic = \(.*\)/\1/p' ../elasticsearch/pwd.txt)
sed -i "s/password => \".*\"/password => \"$elastic_password\"/g" logstash.conf

# 启动logstash容器
docker compose up -d
docker exec -it logstash /bin/bash -c "cd /bin && logstash-plugin install logstash-codec-json_lines"
# 修改完后重启容器
docker restart logstash
