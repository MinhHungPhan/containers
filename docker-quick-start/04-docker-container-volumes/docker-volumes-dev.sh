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

# Create a Docker volume
sudo docker volume create devvolume

# Run a Docker container with nginx in detached mode and mount the volume
sudo docker container run -d --name devcont --mount source=devvolume,target=/app nginx
