# Docker Installation Guide

## Table of Contents

- [Introduction](#introduction)
- [Concepts](#concepts)
- [Installation](#installation)
- [Relevant Documentation](#relevant-documentation)
- [Conclusion](#conclusion)

## Introduction

In this guide, we will walk you through the process of installing Docker. Before we jump into the command line, let's take a moment to understand what happens during the Docker installation process.

## Concepts

When we install Docker, we are essentially installing a package that consists of three main components: the Docker daemon (dockerd), the RESTful API, and the Docker client (CLI). These components work together to enable us to run and manage containers on our system.

The Docker daemon is a long-running process that manages container creation, execution, and monitoring. It runs in the background and listens for requests from the Docker client.

The RESTful API is bundled with the Docker daemon and provides a communication interface. It allows us to send commands and instructions to the Docker daemon using API calls.

To interact with the Docker daemon more conveniently, we use the Docker client, which is a command-line interface (CLI). The Docker client provides us with a set of commands (such as docker run, docker images) that translate into API calls and send them to the Docker daemon.

## Installation

Now that we have a basic understanding of how Docker works, let's proceed with the installation process. Follow the steps below to install Docker on your system:

1. Confirm the required packages:

```bash
sudo yum install -y yum-utils device-mapper-persistent-data lvm2
```

2. Configure the Docker repository:

```bash
sudo yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
```

3. Install Docker Community Edition:

```bash
sudo yum install -y docker-ce
```

4. Enable and start Docker service:

```bash
sudo systemctl enable docker
sudo systemctl start docker
```

5. Grant permissions to your user:

```bash
sudo usermod -aG docker user
```

> Note: Replace `user` with your actual username.

6. Log out and log back in for the changes to take effect.

7. Test your Docker installation by running the `hello-world` container:

```bash
docker run hello-world
```

## Relevant Documentation

For more information and detailed documentation on Docker, refer to the [official Docker documentation](https://docs.docker.com/).

## Conclusion

That's it! You have successfully installed Docker on your system. Feel free to explore Docker further and experiment with running different containers. If you have any questions or encounter any issues during the installation process, don't hesitate to reach out for assistance. Happy Dockerizing! 🚀