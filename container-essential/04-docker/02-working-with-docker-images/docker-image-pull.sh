#!/bin/bash

# Install required packages
sudo yum install -y yum-utils device-mapper-persistent-data lvm2

# Add Docker repository to yum configuration
sudo yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo

# Install Docker
sudo yum install -y docker-ce

# Enable and start Docker
sudo systemctl enable docker
sudo systemctl start docker

# Pull Docker images
sudo docker image pull alpine:latest
sudo docker pull httpd:latest
sudo docker pull nginx:1.15
