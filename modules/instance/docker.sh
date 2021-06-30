#!/bin/bash
apt-get update
apt-get install -y\
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg \
    lsb-release



curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

echo \ "deb [arch=arm64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

apt-get update
apt-get purge docker-ce docker-ce-cli containerd.io
apt-get install -y docker.io
apt-get install -y docker-ce docker-ce-cli containerd.io

docker pull chentex/go-rest-api:latest

docker run -dp 8080:8080 chentex/go-rest-api




