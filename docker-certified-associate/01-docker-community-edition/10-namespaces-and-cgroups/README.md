# Docker Namespaces and Control Groups

## Table of Contents

- [Introduction](#introduction)
- [Namespaces](#namespaces)
- [Control Groups (cgroups)](#control-groups-cgroups)
- [Example](#example)
- [Relevant Documentation](#relevant-documentation)
- [Conclusion](#conclusion)

## Introduction

This README provides an overview of Docker namespaces and control groups, two key Linux kernel features that Docker utilizes to enable containerization. Understanding these concepts is essential for the Docker Certified Associate Exam. In this document, we will discuss namespaces and cgroups, their functions, and how Docker employs them to provide container functionality.

## Namespaces

Namespaces are a Linux technology that facilitates process isolation by controlling the visibility of resources. When an application interacts with resources like storage, memory, and CPU, it communicates with the operating system. Namespaces allow you to limit the resources accessible to a specific application and restrict its visibility of other resources on the host system. Importantly, the application remains unaware of these limitations while interacting with the operating system as usual.

Docker leverages namespaces to isolate containers. When an application runs in a container, it perceives itself as operating on a separate operating system environment. The application does not require code modifications to function within a container; it behaves as it normally would. Docker employs namespaces to enforce separation between containers, preventing interference or communication between them.

Docker uses the following namespaces:

- **PID Namespace**: Isolates processes, allowing Docker to only observe processes within the container and preventing visibility of processes in other containers or the host system.
- **Network Namespace**: Manages network resources, ensuring that a container can only see the network interfaces available to it.
- **IPC Namespace**: Controls interprocess communication, preventing a container from communicating with processes outside its own namespace.
- **Mount Namespace**: Isolates the container's filesystem mounts, controlling the available file system mounts accessible to the container.
- **UTS Namespace**: Isolates kernel and version identifiers, allowing different containers to run varying versions of the Linux kernel transparently.

The **User Namespace** requires special configuration. It allows a container process to run as root within the container while mapping to an unprivileged user outside the container on the host system. This capability enhances security and minimizes the impact of a compromised container.

```plaintext
                                        +-------------------------------+
                                        |        Docker Namespaces      |
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

```plaintext
┌───────────────────────┐
│   Docker Namespaces   │
└───────────────────────┘
          │
   ┌──────┴───────┐
   │ PID Namespace│
   └──────────────┘
   Description: Isolates process IDs within containers.
   Components:
   - Process IDs: Each container has its unique set of process IDs.
   - Isolation: Processes within a container are isolated from other containers.

          │
   ┌──────┴───────┐
   │ UTS Namespace│
   └──────────────┘
   Description: Isolates the hostname and NIS domain name within containers.
   Components:
   - Hostname: Each container has its own hostname.
   - NIS Domain: Each container has its own NIS domain name.

          │
   ┌──────────────-┐
   │Mount Namespace│
   └──────────────-┘
   Description: Provides an isolated view of the file system mount points within containers.
   Components:
   - Filesystems: Each container has its own isolated file systems.
   - Mount Points: Containers have separate mount points for accessing file systems.

          │
   ┌────────────────-┐
   │Network Namespace│
   └────────────────-┘
   Description: Isolates the network stack within containers.
   Components:
   - Network Devices: Each container has its own virtual network devices.
   - IP Addressing: Containers have separate IP addresses and routing tables.

          │
   ┌───────────────┐
   │ IPC Namespace │
   └───────────────┘
   Description: Isolates interprocess communication mechanisms within containers.
   Components:
   - System V IPC: Containers have their isolated System V IPC mechanisms.
   - POSIX Message Queues: Containers have separate POSIX message queues for interprocess communication.

          │
   ┌────────────────┐
   │User Namespace  │
   └────────────────┘
   Description: Isolates user and group IDs within containers.
   Components:
   - User IDs: Containers have their unique user IDs.
   - Group IDs: Containers have their unique group IDs.

© Minh Hung Phan
```
## Control Groups (cgroups)

Control groups, commonly referred to as cgroups, are another Linux kernel feature that Docker employs to restrict processes to specific sets of resources. Unlike namespaces, cgroups primarily focus on resource usage limitation rather than process visibility. A cgroup limits the resources that a process can utilize without restricting its visibility of those resources.

Docker utilizes control groups to enforce rules regarding resource usage. For instance, when running a container, Docker can enforce limitations on memory usage using the `docker run` command's memory-related flags. These resource limits are enforced through cgroups, a kernel feature that Docker leverages.

```plaintext
                                        +-----------------------+
                                        |       Cgroups         |
                                        +-----------------------+
                                        |                       |
                                        | +-------------------+ |
                                        | |     Cgroup        | |
                                        | +-------------------+ |
                                        | | - Resource Limits | |
                                        | | - Process Control | |
                                        | | - Accounting      | |
                                        | +-------------------+ |
                                        |                       |
                                        | +-------------------+ |
                                        | |    Subsystem      | |
                                        | +-------------------+ |
                                        | | - CPU             | |
                                        | | - Memory          | |
                                        | | - Block I/O       | |
                                        | | - Network         | |
                                        | | - Devices         | |
                                        | +-------------------+ |
                                        |                       |
                                        | +-------------------+ |
                                        | |    Hierarchy      | |
                                        | +-------------------+ |
                                        | | - Cgroup Trees    | |
                                        | | - Inheritance     | |
                                        | | - Membership      | |
                                        | +-------------------+ |
                                        |                       |
                                        +-----------------------+

                                            © Minh Hung Phan
```

```plaintext
┌───────────────────────────┐
│          Cgroups          │
└───────────────────────────┘
          │
   ┌──────┴───────┐
   │    Cgroup    │
   └──────────────┘
   Description: Represents a control group, a collection of processes with common resource control and accounting settings.
   Components:
   - Resource Limits: Defines resource allocation and limits for the processes within the control group.
   - Process Control: Provides mechanisms for managing and controlling processes within the control group.
   - Accounting: Tracks resource usage and provides accounting information for the control group.

          │
   ┌──────┴───────┐
   │   Subsystem  │
   └──────────────┘
   Description: Represents a subsystem of Cgroups responsible for managing specific resources or behaviors.
   Components:
   - CPU: Controls CPU resource allocation and usage for the processes within the control group.
   - Memory: Manages memory resource allocation and usage.
   - Block I/O: Regulates block I/O (input/output) access to storage devices.
   - Network: Controls network resource allocation and bandwidth.
   - Devices: Manages access to devices for processes within the control group.

          │
   ┌───────────────┐
   │   Hierarchy   │
   └───────────────┘
   Description: Represents the hierarchical structure of control groups.
   Components:
   - Cgroup Trees: Organizes control groups in a tree-like structure, allowing for nested and parent-child relationships.
   - Inheritance: Allows child control groups to inherit resource limits and settings from parent control groups.
   - Membership: Specifies the membership of processes in control groups.

© Minh Hung Phan
```
## Example

Here's a simple example that demonstrates the use of Docker namespaces and control groups:

```dockerfile
# Dockerfile

# Start with a base image
FROM ubuntu:latest

# Run a command inside the container
RUN echo "Hello, Docker!"

# Set resource limits using cgroups
# Limit the maximum memory usage to 128MB
# Limit the CPU usage to 50% of one core
CMD stress --vm-bytes 128M --cpu 0.5 --timeout 10s
```

In this example, we create a Docker image based on the latest Ubuntu image. Inside the container, we run a command to print "Hello, Docker!" to the console. Additionally, we use control groups (cgroups) to set resource limits for the container. We restrict the maximum memory usage to 128MB and limit the CPU usage to 50% of one core. Finally, we specify a command using `CMD` to run the `stress` tool, which puts some load on the system for a limited time.

When the container is built and run, Docker creates separate namespaces for the container, including the PID namespace (to isolate processes), network namespace (for network isolation), IPC namespace (for interprocess communication isolation), mount namespace (to control file system mounts), and UTS namespace (for kernel and version identifier isolation).

The control groups (cgroups) ensure that the container's resource usage is limited according to the specified constraints. In this case, the container will be restricted to a maximum of 128MB of memory and will use only 50% of one CPU core.

## Cgroup vs Namespace

A Linux namespace limits what a process can see, while a cgroup limits what a process can access. Namespaces wrap global resources to provide an isolated instance of that resource to a process, while cgroups limit a process's access to system resources.

Let's say we have a container running a database application. We want to isolate the resources used by the database application from the rest of the system to prevent it from consuming too many resources and impacting other applications.

To achieve this, we can use a combination of Linux namespaces and cgroups. We can use the mount namespace to isolate the container's file system, the network namespace to isolate its network stack, and the PID namespace to isolate its process tree.

Then, we can use cgroups to limit the amount of CPU, memory, and disk I/O that the container's processes can use. This will prevent the database application from consuming too many resources and impacting other applications running on the system.

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

This example showcases the basic usage of Docker namespaces and control groups to isolate processes and control resource usage within a container.

In summary, namespaces provide an isolated environment for the container's processes, while cgroups limit their access to system resources to prevent resource exhaustion and ensure fair resource allocation.

## Relevant Documentation

For further information on namespaces and control groups, refer to the following documentation:

- [Docker Overview - The Underlying Technology](https://docs.docker.com/engine/docker-overview/#the-underlying-technology)
- [User Namespace Remapping in Docker](https://docs.docker.com/engine/security/userns-remap/)

## Conclusion

Understanding Docker namespaces and control groups is crucial for comprehending the underlying technology behind Docker containers. Namespaces enable process isolation and resource restriction, while control groups facilitate resource usage limitations. By leveraging these Linux kernel features, Docker provides a robust containerization platform. Aspiring Docker Certified Associates should grasp the fundamentals of namespaces and cgroups to excel in the exam. Refer to the provided documentation for further details and dive deeper into these concepts. 

In summary, a Linux namespace limits what a process can see, while a cgroup limits what a process can access.
