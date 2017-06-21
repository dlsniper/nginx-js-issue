#!/usr/bin/env bash

docker build -t mqttnx .

docker run --rm --name vernemq1 --ip 172.17.200.1 -p 127.0.0.1:18883:1883 -e "DOCKER_VERNEMQ_ALLOW_ANONYMOUS=on" erlio/docker-vernemq
docker run --rm --name vernemq2 --ip 172.17.200.2 -p 127.0.0.1:18884:1883 -e "DOCKER_VERNEMQ_ALLOW_ANONYMOUS=on" -e "DOCKER_VERNEMQ_DISCOVERY_NODE=172.17.200.1" erlio/docker-vernemq
docker run --rm --name vernemq3 --ip 172.17.200.3 -p 127.0.0.1:18885:1883 -e "DOCKER_VERNEMQ_ALLOW_ANONYMOUS=on" -e "DOCKER_VERNEMQ_DISCOVERY_NODE=172.17.200.1" erlio/docker-vernemq

docker run --rm --name mqttnx --ip 172.17.200.10 -p 127.0.0.1:1883:1883 mqttnx

docker exec vernemq1 vmq-admin show cluster status
