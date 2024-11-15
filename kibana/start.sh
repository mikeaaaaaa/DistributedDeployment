elastic_password=$(sed -n 's/.*elastic = \(.*\)/\1/p' ../elasticsearch/pwd.txt)
sed -i "s/ELASTICSEARCH_PASSWORD=\".*\"/ELASTICSEARCH_PASSWORD=\"$elastic_password\"/g" docker-compose.yml

docker compose up -d

