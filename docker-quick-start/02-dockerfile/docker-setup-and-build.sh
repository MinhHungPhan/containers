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

# Create and navigate to /onboarding directory
sudo mkdir /onboarding
cd /onboarding

# Create Dockerfile with Python installation
sudo bash -c 'cat <<EOF > Dockerfile
FROM ubuntu:16.04
LABEL maintainer="@minhhung.phan@kientree.com"
RUN apt-get update && apt-get install -y python3
EOF'

# Build Docker image from Dockerfile
sudo docker build .
