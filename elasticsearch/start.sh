#!/bin/bash
sudo rm -rf ./data/
mkdir -p ./data/es/{es01,es02,es03}/data
mkdir -p ./data/es/{es01,es02,es03}/log
mkdir -p ./data/es/plugins/elasticsearch-analysis-ik
mkdir -p ./data/es/plugins/elasticsearch-analysis-pinyin
# install 分词 插件
wget https://ghp.ci/https://github.com/medcl/elasticsearch-analysis-ik/releases/download/v7.2.0/elasticsearch-analysis-ik-7.2.0.zip -O t.zip
unzip t.zip -d ./data/es/plugins/elasticsearch-analysis-ik

# install 拼音插件
wget https://release.infinilabs.com/analysis-pinyin/stable/elasticsearch-analysis-pinyin-7.2.0.zip -O t.zip
unzip t.zip -d ./data/es/plugins/elasticsearch-analysis-pinyin




sudo chmod -R 777 ./data 
sudo chmod -R 777 ./elastic-certificates.p12
sudo docker compose up -d
sleep 10
output=$(sudo docker exec es01 bin/elasticsearch-setup-passwords auto --batch)
echo $output | sed 's/Changed password for user /\n/g' | sed '/^$/d'| tee pwd.txt

