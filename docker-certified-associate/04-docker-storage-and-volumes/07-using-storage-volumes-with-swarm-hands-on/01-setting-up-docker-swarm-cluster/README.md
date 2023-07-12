# Docker Swarm Cluster Setup

## Table of Contents

- [Introduction](#introduction)
- [Prerequisites](#prerequisites)
- [Solution](#solution)
  - [Setup Cloud Servers](#step-1-setup-cloud-servers)
  - [Install Docker CE](#step-2-install-docker-ce)
  - [Initialize Docker Swarm](#step-3-initialize-docker-swarm)
  - [Join Swarm as Workers](#step-4-join-swarm-as-workers)
- [Relevant Documentation](#relevant-documentation)
- [Conclusion](#conclusion)

## Introduction

This guide will walk you through the process of setting up a Docker Swarm cluster with 3 nodes. We'll be using Docker Swarm because it's an easy-to-use and powerful orchestration tool. In this setup, we will have one Swarm Manager, one Swarm Worker, and one Storage Server.

Here is a short description of each type of node:
- **Swarm Manager**: This node is in charge of the whole swarm and the services deployed on it.
- **Swarm Worker**: This node executes tasks assigned by the Swarm Manager.
- **Storage Server**: This node is used for storing data. It can be a worker in the Swarm cluster, but in this setup, we're keeping it separate for clarity.

## Prerequisites

You should have the following before starting this tutorial:
1. Three Cloud Servers with SSH access.
2. A SSH client installed on your local machine.

## Solution

### Step 1: Setup Cloud Servers

Assuming you have your cloud servers ready, let's set up a new user on each of them. 

SSH into each server using the provided credentials, then execute the following commands to create a new user `cloud@user`:

```bash
sudo adduser cloud@user
```

Set the password for the new user when prompted. Once done, add the user to the `sudo` group:

```bash
sudo usermod -aG sudo cloud@user
```

Now, you can log in to your servers using the new credentials. 

### Step 2: Install Docker CE

After creating the new user, the next step is to install Docker on each server. We can do this by executing the following commands:

```bash
sudo apt-get update
sudo apt-get -y install \
  apt-transport-https \
  ca-certificates \
  curl \
  gnupg-agent \
  software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"
sudo apt-get update
sudo apt-get install -y docker-ce=5:18.09.5~3-0~ubuntu-bionic docker-ce-cli=5:18.09.5~3-0~ubuntu-bionic containerd.io
```

To confirm Docker is installed correctly, run:

```bash
docker --version
```

You should see the Docker version displayed.

### Step 3: Initialize Docker Swarm

Choose one of the servers to be the Swarm Manager. Log into the server and initialize Docker Swarm by running:

```bash
docker swarm init --advertise-addr [MANAGER-IP]
```

Replace `[MANAGER-IP]` with the IP address of the Manager server. The output will include a command to add a worker to the swarm. Copy this command, we will need it in the next step.

Verify the swarm initialization by checking the swarm status:

```bash
docker info
```

List the nodes in the swarm using the following command:

```bash
docker node ls
```

In the output of the `docker node ls` command, you should see the swarm manager listed as an active node.

### Step 4: Join Swarm as Workers

Log into your other two servers (Worker and Storage) and execute the command you copied from the last step. It will look something like this:

```bash
docker swarm join --token <token> [MANAGER-IP]:2377
```

Remember to replace `[MANAGER-IP]` with the IP address of the Manager server. If everything is done correctly, you'll see a message saying "This node joined a swarm as a worker".

## Relevant Documentation

- [Docker Swarm Overview](https://docs.docker.com/engine/swarm/)
- [Docker Get Started](https://docs.docker.com/get-started/)
- [Creating a user on Ubuntu](https://www.digitalocean.com/community/tutorials/how-to-create-a-new-sudo-enabled-user-on-ubuntu-18-04-quickstart)

## Conclusion

That's it! You now have a working Docker Swarm cluster with one manager and two workers. With this, you can start deploying scalable, distributed applications using Docker Swarm.