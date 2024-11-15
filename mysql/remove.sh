#!/bin/bash

docker stop mysql-master mysql-slave1 mysql-slave2
docker rm mysql-master mysql-slave1 mysql-slave2
