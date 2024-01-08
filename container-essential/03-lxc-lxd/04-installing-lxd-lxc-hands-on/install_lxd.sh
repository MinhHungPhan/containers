#!/bin/bash

# Install LXD and LXD client
sudo apt-get update
sudo apt-get install -y lxd lxd-client

# Initialize LXD with default settings
sudo lxd init --auto

# Launch an instance of Alpine 3.14 image
sudo lxc launch images:alpine/3.14 my-alpine

# Execute command inside the instance
sudo lxc exec my-alpine -- /bin/ash -c "echo 'hello world' > hello.txt"
