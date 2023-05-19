#!/bin/bash

# Step 1: Update package information
sudo apt-get update

# Step 2: Install required packages
sudo apt-get -y install \
 apt-transport-https \
 ca-certificates \
 curl \
 gnupg-agent \
 software-properties-common

# Step 3: Add Docker GPG key and repo
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo apt-key fingerprint 0EBFCD88

# Add the repository
sudo add-apt-repository \
"deb [arch=amd64] https://download.docker.com/linux/ubuntu \
 $(lsb_release -cs) \
 stable"

# Step 4: Update package information again
sudo apt-get update

# Step 5: Install Docker CE
sudo apt-get -y install docker-ce docker-ce-cli containerd.io

# Step 6: Give cloud_user permission to run Docker commands
sudo usermod -a -G docker cloud_user


# Step 7: Auto-delete the script
rm "$0"