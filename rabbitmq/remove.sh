#! /bin/bash
sudo rm -rf ./data
docker stop rabbitmaster rabbitslave1 rabbitslave2 \
&& docker rm rabbitmaster rabbitslave1 rabbitslave2 
