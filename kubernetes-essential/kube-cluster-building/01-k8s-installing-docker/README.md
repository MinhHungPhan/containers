
# Installing Docker

## Table of Contents

- [Introduction](#introduction)
- [Commands](#commands)
    - [Retrieve GPG Key](#retrieve-gpg-key)
    - [Add Docker Repository](#add-docker-repository)
    - [Update Package List](#update-package-list)
    - [Install Docker](#install-docker)
    - [Hold Docker Package](#hold-docker-package)
    - [Verify Docker Installation](#verify-docker-installation)
- [Conclusion](#conclusion)
- [References](#references)

## Introduction

The first step in setting up a new cluster is to install a container runtime such as Docker. In this tutorial, we will be installing Docker on our three servers in preparation for standing up a Kubernetes cluster. After completing this lesson, you should have three playground servers, all with Docker up and running.

## Commands

Here are the commands used in this tutorial:

### Retrieve GPG Key

This command retrieves the GPG key for the Docker repository and adds it to the system's package manager keyring:

```bash
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
```

### Add Docker Repository

This command adds the Docker repository to the system's package repositories:

```bash
sudo add-apt-repository \
"deb [arch=amd64] https://download.docker.com/linux/ubuntu \
$(lsb_release -cs) \
stable"
```

### Update Package List

This command updates the local package list or index on a Linux system:

```bash
sudo apt-get update
```

### Install Docker

This command installs the specified version of Docker Community Edition:

```bash
sudo apt-get install -y docker-ce=18.06.1~ce~3-0~ubuntu
```
### Hold Docker Package

This command marks the installed Docker package as "held," preventing automatic upgrades:

```bash
sudo apt-mark hold docker-ce
```

### Verify Docker Installation

You can verify that docker is working by running this command:

```bash
sudo docker version
```

## Conclusion

By following the steps outlined in this tutorial, you should now have Docker installed and running on your three servers. This setup is a crucial first step in preparing your environment for a Kubernetes cluster. With Docker up and running, you can now proceed to the next steps in your Kubernetes setup.

## References

- [Docker Documentation](https://docs.docker.com/)
- [Kubernetes Documentation](https://kubernetes.io/docs/)
- [Ubuntu Package Management](https://help.ubuntu.com/community/AptGet/Howto)