#!/bin/bash

# Install required packages
sudo yum install -y yum-utils device-mapper-persistent-data lvm2

# Add Docker repository to yum configuration
sudo yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo

# Install Docker
sudo yum install docker-ce

# Enable and start Docker
sudo systemctl enable docker
sudo systemctl start docker

# Add current user to Docker group
sudo usermod -a -G docker $(whoami)

# Verify Docker installation with "hello-world" container
sudo docker run hello-world
