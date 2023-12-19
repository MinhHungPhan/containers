# Network Namespaces

Welcome to our tutorial on network namespaces, an integral part of container technology. This README aims to simplify your understanding of network namespaces, especially if you're new to Linux systems or containerization.

## Table of Contents

- [Introduction](#introduction)
- [Creating a Network Namespace](#creating-a-network-namespace)
- [Experimenting with IP Tables in a Namespace](#experimenting-with-ip-tables-in-a-namespace)
- [Demonstrating Network Namespace Isolation](#demonstrating-network-namespace-isolation)
- [Relevant Documentation](#relevant-documentation)
- [Conclusion](#conclusion)

## Introduction

Network namespaces are a powerful feature in Linux that allow you to isolate network environments. This isolation is crucial for containerization, where each container can have its own network stack, independent of the host or other containers.

## Creating a Network Namespace

1. Let's dive into the practical aspect. We'll start by creating a network namespace named `sample1`. In a Linux terminal, execute:

```bash
sudo ip netns add sample1
```

2. You can verify its creation with `ip netns list`.

```bash
sudo ip netns list
```

## Experimenting with IP Tables in a Namespace

1. Install `iptables` on your system:

- You can check if iptables is installed on your system by running the following command:

```bash
which iptables
```

- If it's not installed, you may need to install it. The method for installing iptables depends on your Linux distribution. For example, on a Debian-based system like Ubuntu, you can use the `apt` package manager:

```bash
sudo apt-get update
sudo apt-get install iptables
```

- On a Red Hat-based system like CentOS or Amazon Linux, you can use the `yum` package manager:

```bash
sudo yum install iptables
```

2. With our namespace `sample1` created, let's explore how IP table rules can be modified within it. First, view the IP table rules on the host system using `sudo iptables -L`:

```bash
sudo iptables -L
```

Expected output:

```bash
Chain INPUT (policy ACCEPT)
target     prot opt source               destination         

Chain FORWARD (policy ACCEPT)
target     prot opt source               destination         

Chain OUTPUT (policy ACCEPT)
target     prot opt source               destination 
```

Remember these rules, as they will serve as a baseline for comparison.

3. Next, enter the network namespace and list its IP table rules:

```bash
sudo ip netns exec sample1 iptables -L
```

or you can use this command:

```bash
sudo ip netns exec sample1 bash
iptables -L
```

Initially, these rules will mirror the host's. 

4. Now, let's modify them within `sample1`:

```bash
iptables -A INPUT -p tcp --dport 80 -j ACCEPT
```

This command allows HTTP traffic on port 80 within the namespace.

5. Check the IP table rules again:

```bash
iptables -L
```

As you can see, our rule has definitely taken effect:

```bash
Chain INPUT (policy ACCEPT)
target     prot opt source               destination         
ACCEPT     tcp  --  anywhere             anywhere             tcp dpt:http

Chain FORWARD (policy ACCEPT)
target     prot opt source               destination         

Chain OUTPUT (policy ACCEPT)
target     prot opt source               destination  
```

## Demonstrating Network Namespace Isolation

Exit the namespace and list the host's IP table rules again:

```bash
exit
sudo iptables -L
```

You'll find that the changes made within `sample1` do not affect the host's IP tables, illustrating the isolation provided by network namespaces.

Expected output:

```bash
Chain INPUT (policy ACCEPT)
target     prot opt source               destination         

Chain FORWARD (policy ACCEPT)
target     prot opt source               destination         

Chain OUTPUT (policy ACCEPT)
target     prot opt source               destination 
```

## Relevant Documentation

- [Linux Network Namespaces](https://man7.org/linux/man-pages/man8/ip-netns.8.html)
- [Introduction to Containers and Docker](https://www.docker.com/101-tutorial)
- [Understanding Cgroups](https://www.kernel.org/doc/Documentation/cgroup-v1/cgroups.txt)

## Conclusion

Through this hands-on demonstration, we've seen how network namespaces can isolate network environments, essential for containerized applications. We haven't yet created a fully containerized environment, as we'll need to integrate other concepts like chroot and cgroups. But now, you have a foundational understanding of how network namespaces contribute to container technology.