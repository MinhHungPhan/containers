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

# Run a Docker container with nginx in detached mode
sudo docker container run -d nginx

# Run a Docker container with nginx in detached mode and publish ports
sudo docker container run -d -P nginx

# Run a Docker container with httpd in detached mode and publish port 80
sudo docker container run -d -p 80:80 httpd
