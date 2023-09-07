# Installing Docker on CentOS

## Table of Contents

- [Introduction](#introduction)
- [Tutorial Reference](#tutorial-reference)
- [Relevant Documentation](#relevant-documentation)
- [Conclusion](#conclusion)

## Introduction

Installing Docker CE on CentOS is a relatively straightforward process, although it may vary slightly depending on your specific environment. This tutorial will guide you through the installation and configuration of Docker CE on CentOS. Additionally, you'll learn how to grant a user permission to execute Docker commands. By following these steps, you will gain a comprehensive understanding of how to install Docker on your CentOS machine.

## Tutorial Reference

1. Install required packages:

```bash
sudo yum install -y device-mapper-persistent-data lvm2
```
2. Add the Docker CE repo:

```bash
sudo yum-config-manager \
--add-repo \
https://download.docker.com/linux/centos/docker-ce.repo
```

3. Install the Docker CE packages and `containerd.io` :

```bash
sudo yum install -y docker-ce-18.09.5 docker-ce-cli-18.09.5 containerd.io
```

4. Start and enable the Docker service:

```bash
sudo systemctl start docker
sudo systemctl enable docker
```

5. Add `cloud_user` to the `docker` group, giving the user permission to run `docker` commands:

```bash
sudo usermod -a -G docker cloud_user
```

6. Log out and back in.

7. Test the installation by running a simple container:

```bash
docker run hello-world
```

## Relevant Documentation

- [Install Docker Engine on CentOS](https://docs.docker.com/install/linux/docker-ce/centos/)

## Conclusion

This tutorial has guided you through the essential steps to install Docker CE on CentOS and configure user permissions. With Docker now running on your CentOS machine, you're set to explore its numerous functionalities. For any further details or troubleshooting, refer to the provided documentation. Happy containerizing! 🌱