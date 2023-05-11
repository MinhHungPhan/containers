#!/bin/bash

# Add Docker GPG key
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

# Add Docker repository
sudo add-apt-repository \
"deb [arch=amd64] https://download.docker.com/linux/ubuntu \
$(lsb_release -cs) \
stable"

# Update package lists
sudo apt-get update

# Install Docker CE
sudo apt-get install -y docker-ce=18.06.1~ce~3-0~ubuntu

# Mark Docker CE as held to prevent automatic upgrades
sudo apt-mark hold docker-ce

# Auto-delete the script
rm "$0"