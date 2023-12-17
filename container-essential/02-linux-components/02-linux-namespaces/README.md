# Understanding Linux Namespaces

## Table of Contents

- [Introduction](#introduction)
- [What are Namespaces?](#what-are-namespaces)
- [Understanding the Difference: Namespaces vs Cgroups](#understanding-the-difference-namespaces-vs-cgroups)
- [Types of Linux Namespaces](#types-of-linux-namespaces)
   - [User Namespace](#user-namespace)
   - [Interprocess Communication Namespace](#interprocess-communication-namespace)
   - [Unix Time-Sharing Namespace](#unix-time-sharing-namespace)
   - [Mount Namespace](#mount-namespace)
   - [PID Namespace](#pid-namespace)
   - [Network Namespace](#network-namespace)
- [Conclusion](#conclusion)
- [References](#references)

## Introduction

Welcome to our guide on Linux Namespaces, a core concept in the Linux operating system that plays a vital role in creating isolated environments like containers. This guide is designed to be beginner-friendly, explaining complex concepts in an easy-to-understand manner.

## What are Namespaces?

Namespaces in Linux can be likened to a global system wrap. They provide a unique way of isolating and virtualizing system resources. For instance, a namespace can take a global resource like a mount point and wrap it, making it appear as an isolated instance to processes within that namespace.

```plaintext
                                        +-------------------------------+
                                        |        Linux Namespaces       |
                                        +-------------------------------+
                                        |                               |
                                        | +---------------------------+ |
                                        | |       PID Namespace       | |
                                        | +---------------------------+ |
                                        | | - Process IDs             | |
                                        | | - Isolation               | |
                                        | +---------------------------+ |
                                        |                               |
                                        | +---------------------------+ |
                                        | |       UTS Namespace       | |
                                        | +---------------------------+ |
                                        | | - Hostname                | |
                                        | | - NIS Domain              | |
                                        | +---------------------------+ |
                                        |                               |
                                        | +---------------------------+ |
                                        | |      Mount Namespace      | |
                                        | +---------------------------+ |
                                        | | - Filesystems             | |
                                        | | - Mount Points            | |
                                        | +---------------------------+ |
                                        |                               |
                                        | +---------------------------+ |
                                        | |    Network Namespace      | |
                                        | +---------------------------+ |
                                        | | - Network Devices         | |
                                        | | - IP Addressing           | |
                                        | +---------------------------+ |
                                        |                               |
                                        | +---------------------------+ |
                                        | |       IPC Namespace       | |
                                        | +---------------------------+ |
                                        | | - System V IPC            | |
                                        | | - POSIX Message Queues    | |
                                        | +---------------------------+ |
                                        |                               |
                                        | +---------------------------+ |
                                        | |      User Namespace       | |
                                        | +---------------------------+ |
                                        | | - User IDs                | |
                                        | | - Group IDs               | |
                                        | +---------------------------+ |
                                        |                               |
                                        +-------------------------------+

                                                © Minh Hung Phan
```

## Understanding the Difference: Namespaces vs Cgroups

It's crucial to distinguish between Linux namespaces and control groups (cgroups):
- **Namespaces**: Limit what a process can _see_, creating isolation.
- **Cgroups**: Control the extent to which a process can _access_ system resources.

```plaintext
Container A:
+-----------+
| PID NS    | --> [P1, P2, P3]
| NET NS    | --> [eth0, lo]
| IPC NS    | --> [Shared Memory, Semaphores]
| UTS NS    | --> [hostname, NIS domain name]
| MNT NS    | --> [/lib, /usr, /home]
| USER NS   | --> [UIDs, GIDs]
| CGROUPS   | --> [CPU, Memory, Disk I/O]
+-----------+

Container B:
+-----------+
| PID NS    | --> [P1, P2, P3]
| NET NS    | --> [eth0, lo]
| IPC NS    | --> [Shared Memory, Semaphores]
| UTS NS    | --> [hostname, NIS domain name]
| MNT NS    | --> [/lib, /usr, /home]
| USER NS   | --> [UIDs, GIDs]
| CGROUPS   | --> [CPU, Memory, Disk I/O]
+-----------+

© Minh Hung Phan
```


```plaintext
┌──────────────────────────────────────────────────────────────────────────────────────────────┐
│                                                                                              │
│  Host                                                                                        │
│                                                                                              │
│          ┌ ─ ─ ─ ─ ─ ─ ─ ─ ─ ┐     ┌ ─ ─ ─ ─ ─ ─ ─ ─ ─ ┐     ┌ ─ ─ ─ ─ ─ ─ ─ ─ ─ ┐           │
│                                                                                              │
│          │    Container 1    │     │    Container 2    │     │    Container 3    │           │
│                                                                                              │
│          │   (Namespaces)    │     │   (Namespaces)    │     │   (Namespaces)    │           │
│                                                                                              │
│          └ ─ ─ ─ ─ ┬ ─ ─ ─ ─ ┘     └ ─ ─ ─ ─ ┬ ─ ─ ─ ─ ┘     └ ─ ─ ─ ─ ┬ ─ ─ ─ ─ ┘           │
│                    │                         │                         │                     │
│                    │                         │                         │                     │
│                    │                         │                         │                     │
└────────────────────┼─────────────────────────┼─────────────────────────┼─────────────────────┘
                     │                         │                         │                      
                     │                         │                         │                      
                     │                         │                         │                      
┌────────────────────┼─────────────────────────┼─────────────────────────┼─────────────────────┐
│                    │                         │                         │                     │
│ Kernel             │                         │                         │                     │
│                    │                         │                         │                     │
│                    │                         │                         │                     │
│          ┌─────────┴─────────┐     ┌─────────┴─────────┐     ┌─────────┴─────────┐           │
│          │                   │     │                   │     │                   │           │
│          │                   │     │                   │     │                   │           │
│          │      Cgroups      │     │      Cgroups      │     │      Cgroups      │           │
│          │                   │     │                   │     │                   │           │
│          │                   │     │                   │     │                   │           │
│          └───────────────────┘     └───────────────────┘     └───────────────────┘           │
│                                                                                              │
│                                                                                              │
└──────────────────────────────────────────────────────────────────────────────────────────────┘
                                        © Minh Hung Phan
```

## Types of Linux Namespaces

Linux features several types of namespaces, each serving a specific purpose:

### User Namespace

Introduced in Linux kernel 3.8, this namespace isolates user IDs and group IDs. It enables a process to have different identifiers in a container and on the host machine, enhancing security.

**Example**: Inside a Linux container, a user is root (UID 0). With User Namespace, this 'root' is actually a regular user (e.g., UID 1001) on the host system, preventing it from having root powers outside the container.

**Scenario**:
- A Docker container is created on a Linux host.

**Without User Namespace**:
- Inside the container, a process is running as root (UID 0).
- If this process escapes the container, it has root privileges on the host system, posing a security risk.

**With User Namespace**:
- The container is started with User Namespace mapping.
- Inside the container, the process still runs as root (UID 0).
- However, this root UID is mapped to a non-privileged UID on the host, say UID 1001.
- If the process escapes the container, it only has the privileges of a regular user (UID 1001) on the host, greatly reducing the security risk.

**Technical Command Example** (in Docker):

```bash
docker run --rm -it --userns-remap=default my_container_image
```

This command starts a Docker container with User Namespace enabled, where the root user inside the container is mapped to a non-root user on the host system.

### Interprocess Communication Namespace

This namespace isolates System V IPC mechanisms, ensuring secure data exchange between processes in different namespaces.

**Example**: Each namespace gets its separate message queue, allowing containers to communicate securely.

### Unix Time-Sharing Namespace

This namespace isolates hostnames within each container, allowing each container to have its unique name.

**Example**: Containers can use hostnames as identifiers, making it easier to manage and interact with them.

### Mount Namespace

It isolates file system mount points for each container, akin to creating a chrooted environment.

**Example**: Containers have different views of the system's mount points, enhancing process isolation.

### PID Namespace

PID Namespace isolates process IDs, allowing each container to have its process tree. This functionality allows containers to be moved or suspended without PID conflicts.

**Example**: A process could be PID 1 in a container but mapped to PID 2000 on the host, preventing root access breaches from the container.

### Network Namespace

Each container gets its copy of the network stack, including routing tables, firewall rules, and network devices.

**Example**: Containers can have independent network configurations, improving network management and security.

## Conclusion

Linux namespaces are a fundamental component in building isolated environments like containers. Understanding these namespaces helps in appreciating the security and flexibility offered by containerization technologies.

## References

- [The 7 most used Linux namespaces](https://www.redhat.com/sysadmin/7-linux-namespaces)
- [How to List Namespaces in Linux](https://www.baeldung.com/linux/list-namespaces)
- [Differences Between cgroups and Namespaces in Linux](https://www.baeldung.com/linux/cgroups-and-namespaces)
- [namespaces(7) - Linux manual page](https://www.man7.org/linux/man-pages/man7/namespaces.7.html)
- [user_namespaces(7) - Linux manual page](https://www.man7.org/linux/man-pages/man7/user_namespaces.7.html)
- [ipc_namespaces(7) - Linux manual page](https://www.man7.org/linux/man-pages/man7/ipc_namespaces.7.html)
