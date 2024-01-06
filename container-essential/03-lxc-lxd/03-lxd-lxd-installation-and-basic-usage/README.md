# LXC/LXD Installation and Basic Usage

## Table of Contents

- [Introduction](#introduction)
- [Getting Started](#getting-started)
- [Usage and Examples](#usage-and-examples)
- [Best Practices](#best-practices)
- [Key Takeaways](#key-takeaways)
- [Relevant Documentation](#relevant-documentation)
- [Conclusion](#conclusion)

## Introduction

Welcome to the comprehensive guide on Linux containers, commonly referred to as LXC ("Lexy") and LXD ("Lexdy"). Developed in 2008 by IBM developers, LXC leverages Linux containment features like cgroups, namespaces, and chroot to offer a user-friendly interface for managing containers. LXD, the Linux daemon, facilitates communication with the LXC application. This document aims to provide a clear and accessible roadmap for installing and using LXC/LXD, targeting both beginners and seasoned users alike.

## Getting Started

### Prerequisites

- Basic knowledge of Linux commands.
- Access to a Linux system, preferably Ubuntu 16.04 or later.

### Installation

1. **Identify Your Linux Distribution**: Run the following command to determine your distribution:

```bash
cat /etc/issue
```

2. **Install LXD and LXD client**: For Ubuntu 16.04, use `apt install` to install LXD and LXD-client:

```bash
sudo apt install lxd lxd-client
```

3. **Initialize LXD**: Execute the following command to initialize LXD:

```bash
sudo lxd init
```

Follow the setup instructions for storage, networking, and LXD bridge configuration.

## Usage and Examples

### Basic Commands

1. **Initializing LXD**: Run the following command and follow the setup instructions:

```bash
sudo lxd init
```

2. **Launching Containers**: Use this command to launch an Ubuntu container named 'my-ubuntu':

```bash
lxc launch ubuntu:16.04 my-ubuntu
```

3. **Listing Containers**: The following command shows all running containers:

```bash
lxc list
```

4. **Executing Commands in Containers**: Use this command to execute commands inside the 'my-ubuntu' container:

```bash
lxc exec my-ubuntu -- bash
```

### Example Scenarios

1. **Accessing a Container**: 

- To access the 'my-ubuntu' container, use the following command:

```bash
lxc exec my-ubuntu -- bash
```

- Once inside the container, you can execute various Linux commands as if you were on a separate Ubuntu machine. For example, to check the operating system version, run:

```bash
cat /etc/os-release
```

- To exit the container, simply type:

```bash
exit
```

2. **File Creation and Isolation in Ubuntu Container**: 

- Inside the 'my-ubuntu' container, create a file named `hi.txt` with the following command:

```bash
echo "hello" > hi.txt
```

- Verify the file creation by listing the contents of the current directory:

```bash
ls
```

- Exit the container and observe that the file `hi.txt` is not present in the host system, demonstrating container isolation.

3. **Interacting with Alpine Container**:

- Launch an Alpine container named 'my-alpine':

```bash
lxc launch images:alpine/3.5 my-alpine
```

- Access the 'my-alpine' container using the `lxc exec` command with a different shell, as Alpine uses the Ash shell:

```bash
lxc exec my-alpine -- ash
```

- Inside the 'my-alpine' container, create a file `hello.txt` with content "hello world":

```bash
echo "hello world" > hello.txt
```

- Verify the file's existence and contents with `cat`:

```bash
cat hello.txt
```

- Exit the container and note that the file `hello.txt` remains isolated within the Alpine container.

## Best Practices

- **Security**: Only use official or trusted images from repositories.
- **Resource Management**: Monitor and allocate resources efficiently to avoid system strain.
- **Updates**: Regularly update LXC and LXD to the latest versions for security and feature improvements.

## Key Takeaways

- LXC/LXD offers an efficient way to manage lightweight, isolated Linux environments.
- Understanding basic commands and their functions is crucial for effective container management.
- Always prioritize security and resource optimization when working with containers.

## Relevant Documentation

- [LXC/LXD Official Documentation](https://linuxcontainers.org/lxc/introduction/)
- [IBM Research on Linux Containment](https://www.ibm.com/search?lang=en&cc=us&q=Linux+containment)
- [Ubuntu LXD Guides](https://ubuntu.com/lxd)

## Conclusion

LXC and LXD provide powerful tools for container management, enabling users to create and manage isolated Linux environments with ease. This guide aims to equip you with the knowledge to get started and effectively use these tools. We encourage your contributions and feedback to enrich the community's understanding and application of LXC/LXD.
