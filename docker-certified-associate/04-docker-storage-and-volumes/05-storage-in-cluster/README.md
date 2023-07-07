# Docker Swarm Cluster Storage

Welcome to this guide on how to manage storage in a Docker Swarm cluster. We will be looking into the use of Docker volumes, primarily within the context of a single host, and then extend this understanding to a Swarm cluster. This guide provides practical steps and examples, simplifying the process of storing data in a Swarm cluster. 

## Table of Contents

- [Introduction](#introduction)
- [Setup](#setup)
- [Installing the Plugin](#installing-the-plugin)
- [Setting up External Storage](#setting-up-external-storage)
- [Creating a Docker Volume](#creating-a-docker-volume)
- [Creating a Docker Service](#creating-a-docker-service)
- [Automatic Volume Creation in Cluster](#automatic-volume-creation-in-cluster)
- [Relevant Documentation](#relevant-documentation)
- [Conclusion](#conclusion)

## Introduction

Docker volumes offer persistent storage to containers and permit them to share data. This becomes more complex in the context of a Swarm cluster where containers might run on different nodes. In this guide, we will demonstrate how to create shared volumes working across multiple Swarm nodes using the `vieux/sshfs` volume driver.

When working with multiple Docker machines, particularly in a swarm cluster, the need often arises to share Docker volume storage among these machines.

Here are a few options to consider:

1. Utilize application logic to store data in external object storage.
2. Employ a volume driver to create a volume that is independent of any specific machine within your cluster.

```plaintext
┌─────────────────────────────────────────────────────────────────────────────────────────┐
│Docker Swarm Cluster                                                                     │
│                                                                                         │
│   ┌────────────────────────────────────┐       ┌────────────────────────────────────┐   │
│   │Cluster Node                        │       │Cluster Node                        │   │
│   │                                    │       │                                    │   │
│   │  ┌─────────────┐                   │       │                   ┌─────────────┐  │   │
│   │  │  Container  │──────────┐        │       │         ┌─────────│  Container  │  │   │
│   │  └─────────────┘          │        │       │         │         └─────────────┘  │   │
│   │                           │        │       │         │                          │   │
│   │                           ▼        │       │         ▼                          │   │
│   │                    ┌ ─ ─ ─ ─ ─ ─ ┐ │       │  ┌ ─ ─ ─ ─ ─ ─ ┐                   │   │
│   │                        Volume      │       │      Volume                        │   │
│   │                    └ ─ ─ ─ ┬ ─ ─ ┘ │       │  └ ─ ─ ─ ┬ ─ ─ ┘                   │   │
│   └────────────────────────────┼───────┘       └──────────┼─────────────────────────┘   │
│                                │                          │                             │
│                                └────────────┬─────────────┘                             │
│                                             │                                           │
│                           ┌─────────────────┼────────────────┐                          │
│                           │External Storage │                │                          │
│                           │                 │                │                          │
│                           │                 ▼                │                          │
│                           │           ┌───────────┐          │                          │
│                           │           │   Data    │          │                          │
│                           │           └───────────┘          │                          │
│                           │                                  │                          │
│                           │                                  │                          │
│                           └──────────────────────────────────┘                          │
│                                                                                         │
└─────────────────────────────────────────────────────────────────────────────────────────┘

                                    © Minh Hung Phan
```

## Setup

This guide assumes you have a Docker Swarm cluster set up with at least one manager node and two worker nodes. 

## Installing the Plugin

To kick start, install the `vieux/sshfs` plugin on all nodes in your Swarm cluster. This can be done with the following command:

```bash
docker plugin install --grant-all-permissions vieux/sshfs
```

## Setting up External Storage

Next, set up a server separate from your Swarm nodes to be used for storage. Create a directory along with a test file. For simplicity, the directory will be in the home directory:

```bash
mkdir /home/cloud_user/external
echo "External storage!" > /home/cloud_user/external/message.txt
```

**Note**: Replace `cloud_user` with `<your-username>`

## Creating a Docker Volume

1. On your Swarm manager, manually create a Docker volume that uses the external storage server for storage. Replace `<STORAGE_SERVER_PRIVATE_IP>` and `<PASSWORD>` with your actual values:

```bash
docker volume create --driver vieux/sshfs \
-o sshcmd=cloud_user@<STORAGE_SERVER_PRIVATE_IP>:/home/cloud_user/external \
-o password=<PASSWORD> \
sshvolume
```

**Note**: Replace `cloud_user` with `<your-username>`

2. Let's break down the components:

- `docker volume create`: This command is used to create a Docker volume.

- `--driver vieux/sshfs`: This flag specifies the volume driver to be used, in this case, "vieux/sshfs". It enables creating volumes over SSH.

- `-o sshcmd=cloud_user@<STORAGE_SERVER_PRIVATE_IP>:/home/cloud_user/external`: This option specifies the SSH command to connect to the storage server. "cloud_user" is the username, and "<STORAGE_SERVER_PRIVATE_IP>" is the private IP address of the storage server. It also specifies the directory on the server to be used as the volume, which is "/home/cloud_user/external" in this example.

- `-o password=<PASSWORD>`: This option provides the password required to establish an SSH connection to the storage server. "<PASSWORD>" should be replaced with the actual password.

- `sshvolume`: This is the name assigned to the created Docker volume. In this case, it is named "sshvolume".

Overall, this command creates a Docker volume using the "vieux/sshfs" volume driver. It establishes an SSH connection to the storage server using the specified credentials and designates the "/home/cloud_user/external" directory on the server as the source of the volume. The volume is then given the name "sshvolume".

3. Check the existence of your new volume with:

```bash
docker volume ls
```

Now, let's address a minor drawback of the approach we just used. The volume was explicitly created on this particular machine, which happens to be our swarm manager. Consequently, the volume only exists on the swarm manager and not on the other nodes in the cluster.

Here's the issue: If we create a service and attempt to utilize that volume using the command `docker service create` with the `--mount` flag, a problem arises. When some of the tasks are assigned to worker nodes where this volume doesn't exist, Docker automatically creates a new volume. However, this newly created volume lacks the custom settings we specified earlier. Instead, it becomes a standard Docker volume residing on those local worker nodes, rendering it ineffective for our intended purposes.

## Creating a Docker Service

1. Now let's create a service that automatically manages the shared volume, creating the volume on Swarm nodes as needed. Replace `<STORAGE_SERVER_PRIVATE_IP>` and `<PASSWORD>` with your actual values:

```bash
docker service create \
--replicas=3 \
--name storage-service \
--mount volume-driver=vieux/sshfs,source=cluster-volume,destination=/app,volume-opt=sshcmd=cloud_user@<STORAGE_SERVER_PRIVATE_IP>:/home/cloud_user/external,volume-opt=password=<PASSWORD> \
busybox cat /app/message.txt
```

**Note**: Replace `cloud_user` with `<your-username>`

2. Let's break down the components:

- `docker service create`: This command is used to create a Docker service.

- `--replicas=3`: This flag specifies the number of replicas (instances) of the service to be created. In this case, it indicates that three replicas of the service should be launched.

- `--name storage-service`: This flag assigns the name "storage-service" to the created service.

- `--mount`: This flag specifies the volume mounting configuration for the service.

- `volume-driver=vieux/sshfs`: This option indicates the volume driver to be used, in this case, "vieux/sshfs". It enables mounting volumes over SSH.

- `source=cluster-volume`: This specifies the name of the volume to be mounted, which is "cluster-volume" in this case.

- `destination=/app`: This option sets the mount point inside the container where the volume will be mounted, which is "/app" in this example.

- `volume-opt=sshcmd=cloud_user@<STORAGE_SERVER_PRIVATE_IP>:/home/cloud_user/external`: This option specifies the SSH command to connect to the storage server, where "cloud_user" is the username, and "<STORAGE_SERVER_PRIVATE_IP>" is the private IP address of the storage server. It also specifies the directory on the server to be mounted as the volume, which is "/home/cloud_user/external" in this case.

- `volume-opt=password=<PASSWORD>`: This option provides the password required to establish an SSH connection to the storage server. "<PASSWORD>" should be replaced with the actual password.

- `busybox cat /app/message.txt`: This command specifies the container image to be used for the service, in this case, "busybox". It also executes the command "cat /app/message.txt" inside the container, which reads and outputs the contents of the file "message.txt" located at the mount point "/app".

Overall, this command creates a Docker service named "storage-service" with three replicas. It mounts the "cluster-volume" using the "vieux/sshfs" volume driver, establishing an SSH connection to a storage server with the provided credentials. The contents of the "message.txt" file in the mounted volume are then displayed.

3. To verify if the service is correctly reading the test data from the external storage server, check the service logs:

```bash
docker service logs storage-service
```

## Automatic Volume Creation in Cluster

We have utilized the `docker service create` command in a unique way. Instead of referencing an existing volume with a source, we opted to create a new volume name and include all the volume settings directly within the `docker service create` command.

The advantage of this approach is that the volume is automatically created on every node in the cluster when individual tasks of the service are scheduled on a specific node. This means that even if we add a new node to the cluster in the future, the volume mount will be automatically created if one of the service replicas runs on that new node.

This automatic volume creation feature is incredibly useful when working with external volume mounts in the context of a cluster. By specifying all the volume settings within the `docker service create` command, rather than manually creating the volume on a node, the volume will be seamlessly spun up on all the nodes in the cluster as needed. This saves time and effort, ensuring consistent volume availability across the entire cluster.

## Relevant Documentation

- [Docker Volumes - Share data between machines](https://docs.docker.com/storage/volumes/#share-data-among-machines)

## Conclusion

Congratulations! You now understand how to create and manage shared volumes within a Docker Swarm cluster. While there are numerous ways to use volumes within the context of a Swarm cluster, this guide offers you a basic understanding and a practical approach.