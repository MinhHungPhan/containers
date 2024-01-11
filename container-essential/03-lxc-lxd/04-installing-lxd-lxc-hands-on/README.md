## LXD/LXC Installation Hands On

Welcome to the Linux Containers (LXC) guide! This guide provides an overview of LXC and LXD, their origins, installation steps, and basic usage. Let's dive in!

## Table of Contents

- [Introduction](#introduction)
- [Installation](#installation)
- [Usage](#usage)
- [Remotes](#remotes)
- [Relevant Documentation](#relevant-documentation)
- [Conclusion](#conclusion)

## Introduction

LXC, also known as "Lexy", is a technology that stands for LX (Linux) Containers. It was developed in 2008 by IBM developers, leveraging Linux containment features such as cgroups, namespaces, and chroot. LXC provides a user-friendly interface, powerful API, and simple tools to manage containers on Linux systems. Additionally, LXD (Linux Daemon) acts as the daemon to communicate with LXC applications.

## Installation

To install LXC and LXD, follow these steps:

1. Determine your Linux distribution by checking `/etc/issue`:

```bash
cat /etc/issue
```

2. Install LXD and LXD client:

```bash
sudo apt install lxd lxd-client
```

> Note: If you are running a minimal cloud server image, you may need to install these packages manually.

3. Initialize LXD:

```bash
sudo lxd init
```

During the initialization process, you will be prompted to set up storage, configure network access, and configure the LXD bridge.

## Usage

Once LXD is set up, you can start using LXC containers. Here are some basic commands to get you started:

1. List available containers:

```bash
sudo lxc list
```

2. Launch an Ubuntu container:

```bash
lxc launch ubuntu:16.04 my-ubuntu
```

3. Launch an Alpine container:

```bash
lxc launch images:alpine/3.5 my-alpine
```

4. Execute a command inside a container:

```bash
lxc exec <container-name> <command>
```

5. Example: Execute a Bash shell inside the Ubuntu container:

```bash
lxc exec my-ubuntu bash
```

6. Example: Create a file inside the Alpine container:

```bash
lxc exec my-alpine -- sh -c 'echo "hello" > hi.txt'
```

## Remotes

LXC and LXD use remotes to host container images, similar to repositories. To view available remotes, use the following command:

```bash
lxc remote list
```

Ensure that you only pull images from trusted sources, such as official distributions or trusted repositories.

## Relevant Documentation

- [LXC/LXD Official Documentation](https://linuxcontainers.org/lxc/introduction/)
- [IBM Research on Linux Containment](https://www.ibm.com/search?lang=en&cc=us&q=Linux+containment)
- [Ubuntu LXD Guides](https://ubuntu.com/lxd)

## Conclusion

Congratulations! You have learned the basics of Linux Containers with LXC and LXD. Feel free to explore further, experiment with different images, and expand your knowledge of containerization. Enjoy your journey with Linux Containers! 🚀