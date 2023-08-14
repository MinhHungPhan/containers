# Default Docker Engine Security

Hello and welcome! In this guide, we'll introduce you to some of the default security features of Docker, particularly the features that are essential for the Docker Certified Associate exam. By the end, you'll have a clear understanding of the fundamental concepts and how Docker ensures a secure environment for your applications.

## Table of Contents

- [Introduction](#introduction)
- [Namespaces and Control Groups](#namespaces-and-control-groups)
- [Docker Daemon Attack Surface](#docker-daemon-attack-surface)
- [Linux Kernel Capabilities](#linux-kernel-capabilities)
- [Relevant Documentation](#relevant-documentation)
- [Conclusion](#conclusion)

## Introduction

Docker, a platform used for developing, shipping, and running applications inside containers, places a significant emphasis on security. This guide focuses on the default security features that Docker provides to ensure a secure operational environment for your containers.

## Namespaces and Control Groups

Namespaces and control groups, also known as cgroups, are fundamental to Docker's security strategy. Their primary role is to offer isolation to containers. 

**Isolation** ensures that processes inside a container:
- Cannot see other containers or processes on the host.
- Cannot affect other containers or processes on the host.

The essence of container isolation is the separation between what's happening inside the container from what's happening outside of it. If a vulnerability is exploited within a container, this isolation ensures that the impact doesn't spread to other containers or the host system. For instance, if an attacker gains control of a container, they can't easily compromise other containers or the host itself.

### Example:

Imagine a building with multiple sealed rooms. Each room is a container, and the walls are the namespaces and control groups. Even if one room catches fire (is compromised), the fire won't spread to the other rooms due to the sealed walls.

## Docker Daemon Attack Surface

The Docker daemon is a background process that manages Docker containers. However, this daemon presents a potential attack surface, especially if left unprotected. It operates with root privileges, which means that if a malicious actor gains control over it, they can potentially escalate their privileges on the host system.

Hence, it's crucial to:

- Understand the workings of the Docker daemon.
- Limit access only to trusted users and automated processes.

### Example:

Think of the Docker daemon as the main entrance to a secure facility. If left unguarded, attackers could gain entry and have access to the entire facility. Properly managing access ensures that only trusted individuals can enter.

## Linux Kernel Capabilities

Capabilities within the Linux kernel provide fine-grained control over system operations. Docker employs these capabilities to determine what containers and processes can or cannot do without granting excessive privileges.

An important thing to note is that Docker can utilize capabilities to let container processes perform specific actions without running as root, further reducing potential security risks.

### Example:

In a standard Linux environment, you'd need root privileges to listen on ports below 1024. However, using Docker and capabilities, an nginx container can listen on port 80 without needing root permissions. For example, Docker uses the `net_bind_service` capability to allow container processes to bind to a port below 1024 without running as root.

## Relevant Documentation

- [Namespaces and Cgroups](https://github.com/MinhHungPhan/containers/tree/main/docker-certified-associate/01-docker-community-edition/10-namespaces-and-cgroups)
- [Docker Security](https://docs.docker.com/engine/security/)
- [Linux namespaces](http://man7.org/linux/man-pages/man7/namespaces.7.html)
- [Linux capabilities](http://man7.org/linux/man-pages/man7/capabilities.7.html)

## Conclusion

In this guide, we've explored some critical security concepts related to Docker, such as namespaces, control groups, the Docker daemon, and Linux capabilities. Ensuring a secure Docker environment involves understanding these concepts and practicing recommended security measures. We hope this guide proves valuable as you prepare for the Docker Certified Associate exam or work with Docker in general. Stay tuned for more lessons! 

Happy Dockerizing! 🌱