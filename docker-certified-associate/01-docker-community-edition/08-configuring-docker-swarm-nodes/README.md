# Configuring Docker Swarm Nodes

## Table of Contents

- [Introduction](#introduction)
- [Installing Docker CE on Worker Nodes](#installing-docker-ce-on-worker-nodes)
- [Joining Worker Nodes to the Swarm](#joining-worker-nodes-to-the-swarm)
- [Verifying Worker Nodes](#verifying-worker-nodes)
- [Relevant Documentation](#relevant-documentation)
- [Conclusion](#conclusion)

## Introduction

Welcome to this tutorial on configuring swarm nodes. In this guide, we will discuss how to set up worker nodes in a Docker swarm cluster. Worker nodes are responsible for executing the workloads in the cluster, while the swarm manager delegates and assigns containers to the worker nodes. We will cover the steps required to install Docker CE on the worker nodes and join them to the swarm.

## Installing Docker CE on Worker Nodes

Before adding worker nodes to the swarm, Docker CE needs to be installed on each worker node. The following steps outline the installation process:

1. Update the system packages:
```bash
sudo apt-get update
```

2. Install the necessary packages for Docker CE:
```bash
sudo apt-get -y install apt-transport-https ca-certificates curl gnupg-agent software-properties-common
```

3. Add Docker's official GPG key:
```bash
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
```

4. Verify the fingerprint of the GPG key:
```bash
sudo apt-key fingerprint 0EBFCD88
```

5. Add the Docker repository:
```bash
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
```

6. Update the package database:
```bash
sudo apt-get update
```

7. Install Docker CE and the Docker CLI:
```bash
sudo apt-get install -y docker-ce docker-ce-cli containerd.io
```

8. Add the current user to the `docker` group to run Docker commands without `sudo`:
```bash
sudo usermod -a -G docker cloud_user
```
9. Log out of the worker nodes and log back in to apply the group changes.

## Joining Worker Nodes to the Swarm

To join the worker nodes to the swarm, you need to obtain the join token from the swarm manager and execute it on each worker node. Follow these steps:

1. On the swarm manager, obtain the join token by running the following command:
```bash
docker swarm join-token worker
```

2. Copy the complete join command provided in the output.

3. Run the join command on each worker node to join them to the swarm. For example:
```bash
docker swarm join --token <token> <swarm manager private IP>:2377
```

Replace `<token>` with the token obtained from the manager and `<swarm manager private IP>` with the private IP address of the swarm manager.

## Verifying Worker Nodes

Once the worker nodes have joined the swarm, you can verify their status on the swarm manager. Use the following command:
```bash
docker node ls
```

This command lists all the swarm nodes, including the manager and worker nodes. Ensure that the worker nodes are listed as "Ready" and "Active" in the output.

## Relevant Documentation

For more information, you can refer to the [Docker Swarm tutorial on adding nodes](https://docs.docker.com/engine/swarm/swarm-tutorial/add-nodes/).

## Conclusion

Congratulations! You have successfully configured worker nodes in your Docker swarm cluster. In this tutorial, we covered the installation of Docker CE on the worker nodes and the process of joining them to the swarm.