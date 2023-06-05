# Building a Docker Swarm

## Table of Contents

- [Introduction](#introduction)
- [Instructions](#instructions)
- [Solution](#solution)
- [Conclusion](#conclusion)

## Introduction

Docker Swarm allows you to go beyond running individual containers and enables you to set up a cluster of Docker servers for orchestration and management. In this lab, you will learn how to build a simple Docker Swarm cluster with a swarm manager and two worker nodes. This will give you hands-on experience in setting up and configuring a swarm cluster.

## Instructions

Your company is ready to leverage Docker for running their applications and wants to explore the cluster management and orchestration capabilities of Docker Swarm. Your task is to set up a basic Docker Swarm cluster for initial testing. The following criteria should be met by the swarm cluster:

- One Swarm manager
- Two worker nodes
- All nodes should use Docker CE version `5:18.09.5~3-0~ubuntu-bionic`
- Both worker nodes should be joined to the cluster
- The user `cloud_user` should have the ability to run Docker commands on all three servers

If you encounter any difficulties, refer to the solution video or the detailed instructions provided for each objective. Good luck!

## Solution

1. Begin by logging in to the lab server using the provided credentials:

```bash
ssh cloud_user@PUBLIC_IP_ADDRESS
```

2. Install Docker CE on all three nodes:

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

3. Add cloud_user to the Docker group on each node to enable running Docker commands:

```bash
sudo usermod -a -G docker cloud_user
```

4. Log out of each server and then log back in.

5. Verify the Docker installation on each server:

```bash
docker version
```

6. Configure the swarm manager:

- Replace `<swarm manager private IP>` with the actual Private IP of the swarm manager (NOT the public IP).

```bash
docker swarm init --advertise-addr <swarm manager private IP>
```

7. Join the worker nodes to the cluster:

- On the swarm manager, get the join command with a token:

```bash
docker swarm join-token worker
```

- Copy the command that starts with `docker swarm join ...` and run it on both worker servers.

8. Go back to the swarm manager and list the nodes:

```bash
docker node ls
```

Verify that all three servers are listed, including the manager, and that all three have a status of `READY`.

```plaintext
ID                            HOSTNAME            STATUS              AVAILABILITY        MANAGER STATUS      ENGINE VERSION
pp5mpfayae9euq2rgfw0doruu *   ip-10-0-1-101       Ready               Active              Leader              18.09.5
t0kap10u0xepub598x9taq7os     ip-10-0-1-102       Ready               Active                                  18.09.5
zsssgzgl4e1xgi249et6drp01     ip-10-0-1-103       Ready               Active                                  18.09.5
```

Once all three servers are ready, you have successfully built your Docker swarm cluster!

## Conclusion

Congratulations! You have completed this hands-on lab.