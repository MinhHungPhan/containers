# Configuring a Docker Swarm Manager

## Table of Contents

- [Introduction](#introduction)
- [Docker Swarm Manager](#docker-swarm-manager)
- [Relevant Documentation](#relevant-documentation)
- [Tutorial Reference](#tutorial-reference)
- [Conclusion](#conclusion)

## Introduction

Docker Swarm is a powerful tool that enables the creation and management of a distributed cluster, allowing containers to be deployed across multiple servers.

Docker Swarm offers a convenient way to leverage the full potential of containerization by enabling the deployment of containers across a cluster of interconnected servers. By using Docker Swarm, you can efficiently manage containerized applications and ensure high availability and scalability.

## Docker Swarm Manager

The Docker swarm manager plays a crucial role in managing and controlling a Docker swarm cluster. It is responsible for orchestrating container workloads and managing the overall cluster. In this tutorial, we will guide you through the process of configuring a swarm manager. This involves installing Docker CE and initializing a new swarm cluster.

## Tutorial Reference

Follow the steps below to configure a Docker swarm manager:

1. Install Docker Engine on the swarm manager:
```bash
sudo apt-get update

sudo apt-get -y install \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg-agent \
    software-properties-common

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

sudo apt-key fingerprint 0EBFCD88

sudo add-apt-repository \
    "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
    $(lsb_release -cs) \
    stable"

sudo apt-get update

sudo apt-get install -y docker-ce=5:18.09.5~3-0~ubuntu-bionic docker-ce-cli=5:18.09.5~3-0~ubuntu-bionic containerd.io
```

2. Add your user to the `docker` group to ensure access to Docker commands:
```bash
sudo usermod -a -G docker cloud_user
```

3. Log out of the server and log back in for the changes to take effect.

4. Initialize the swarm cluster by running the following command:
```bash
docker swarm init --advertise-addr <swarm-manager-private-ip>
```

Replace `<swarm-manager-private-ip>` with the private IP address of the swarm manager server. Make sure to use the private IP, as the public IP may have firewall restrictions.

5. Verify the swarm initialization by checking the swarm status:
```bash
docker info
```

6. List the nodes in the swarm using the following command:
```bash
docker node ls
```

In the output of the `docker node ls` command, you should see the swarm manager listed as an active node.

## Relevant Documentation

For more detailed information about Docker Swarm and its key concepts, refer to the [official Docker Swarm key concepts](https://docs.docker.com/engine/swarm/key-concepts/).

For more detailed information about creating and managing a Docker swarm, refer to the [official Docker Swarm Documentation](https://docs.docker.com/engine/swarm/swarm-tutorial/create-swarm/).

By exploring the provided documentation, you can gain a comprehensive understanding of the features and capabilities of Docker Swarm.

## Conclusion

By following the steps outlined in this tutorial, you have successfully configured a Docker swarm manager. The swarm manager plays a crucial role in managing and orchestrating container workloads within the swarm cluster.
