# Setting Up Shared Storage Volumes in Docker Swarm Cluster

## Table of Contents
 
- [Introduction](#introduction)
- [Prerequisites](#prerequisites)
- [Setting Up Shared Storage Volumes in Docker Swarm](#setting-up-shared-storage-volumes-in-docker-swarm)
- [Architecture](#architecture)
   - [Logical Volume](#logical-volume)
   - [Network Mount](#network-mount)
   - [Bind Mount or Volume?](#bind-mount-or-volume)
- [Solution](#solution)
   - [Log in to the Storage Server](#step-1-log-in-to-the-storage-server)
   - [Set up the External Storage Location](#step-2-set-up-the-external-storage-location)
   - [Install the `vieux/sshfs` Plugin](#step-3-install-the-vieuxsshfs-plugin)
   - [Create the Nginx Service That Uses the Shared Volume](#step-4-create-the-nginx-service-that-uses-the-shared-volume)
- [Relevant Documentation](#relevant-documentation)
- [Conclusion](#conclusion)

## Introduction

Docker Swarm is a powerful tool for managing clusters of Docker nodes. Coupled with the concept of storage volumes, it can provide a flexible and reliable environment for your applications. In this guide, we will delve into the process of creating and utilizing shared storage volumes across a Docker Swarm cluster. To make this concept clearer, we will use an example scenario involving a service running on Nginx.

## Prerequisites

In this tutorial, we'll work under the scenario where a team aims to run an Nginx service in a Docker Swarm cluster. They plan to use multiple replicas with a custom Nginx configuration file shared across them. This file will be housed externally in a central location to allow changes without recreating the containers.

Our task is to set up a shared storage volume on an external storage server. This volume should be accessible to all containers across the cluster, regardless of their node location. It will contain the Nginx configuration file and be mounted onto each service's replica containers.

## Setting Up Shared Storage Volumes in Docker Swarm

Here's an overview of the required steps to configure the swarm:

1. Set up a shared storage directory at `/etc/docker/storage` on the external storage server. Ensure that `cloud_user` has read and write access to this directory.

2. Place the nginx config file at `/etc/docker/storage/nginx.conf`. You'll find a copy of this file on the external storage server at `/home/cloud_user/nginx.conf`.

3. Install the `vieux/sshfs` docker plugin on the swarm cluster.

4. Create a service named `nginx-web` using the `nginx:latest` image with 3 replicas. Mount the shared volume onto the service's containers at `/etc/nginx/`. Publish port 9773 on the service containers to port 8080 on the swarm nodes.

5. Create a Docker volume named `nginx-config-vol` using the `vieux/sshfs` driver, storing data in `/etc/docker/storage` on the external storage server. Use the `cloud_user` credentials to accomplish this. Note that you should create the volume as part of the `docker service create` command so that the volume will be automatically configured on all swarm nodes executing the service's tasks.

## Architecture

Architecture Diagram:

```plaintext
┌──────────────────────────────────────────────────────────────────────────────────────────────────────────────────┐
│Docker Swarm Cluster                                                                                              │
│                                                                                                                  │
│ ┌─────────────────────────────────────────────────────┐  ┌─────────────────────────────────────────────────────┐ │
│ │Swarm Manager Node                                   │  │Swarm Worker Node                                    │ │
│ │                                                     │  │                                                     │ │
│ │ ┌────────────────────┐       ┌────────────────────┐ │  │ ┌────────────────────┐       ┌────────────────────┐ │ │
│ │ │   Logical Volume   │       │  Nginx Container   │ │  │ │  Nginx Container   │       │   Logical Volume   │ │ │
│ │ ├────────────────────┤       ├────────────────────┤ │  │ ├────────────────────┤       ├────────────────────┤ │ │
│ │ │ ┌ ─ ─ ─ ─ ─ ─ ─ ─  │       │ ┌────────────────┐ │ │  │ │ ┌────────────────┐ │       │ ┌ ─ ─ ─ ─ ─ ─ ─ ─  │ │ │
│ │ │                  │ │       │ │                │ │ │  │ │ │                │ │       │                  │ │ │ │
│ │ │ │nginx-config-vol ◀┼───────┼─┤  /etc/nginx/   │ │ │  │ │ │  /etc/nginx/   │─┼───────┼▶│nginx-config-vol  │ │ │
│ │ │                  │ │       │ │                │ │ │  │ │ │                │ │       │                  │ │ │ │
│ │ │ └ ─ ─ ─ ┬ ─ ─ ─ ─  │       │ └────────────────┘ │ │  │ │ └────────────────┘ │       │ └ ─ ─ ─ ─ ┬ ─ ─ ─  │ │ │
│ │ └─────────┼──────────┘       └────────────────────┘ │  │ └────────────────────┘       └───────────┼────────┘ │ │
│ │           │                                         │  │                                          │          │ │
│ └───────────┼─────────────────────────────────────────┘  └──────────────────────────────────────────┼──────────┘ │
│             │                                                                                       │            │
│             │                   ┌──────────────────────────────────────────────┐                    │            │
│             │                   │Storage Driver Node                           │                    │            │
│             │                   │                                              │                    │            │
│             │                   │        ┌────────────────────────────┐        │                    │            │
│             │                   │        │         FILESYSTEM         │        │                    │            │
│             │                   │        ├────────────────────────────┤        │                    │            │
│             │                   │        │  ┌──────────────────────┐  │        │                    │            │
│             │        volume     │        │  │                      │  │        │       volume       │            │
│             └───────────────────┼────────┼─▶│ /etc/docker/storage/ │◀─┼────────┼────────────────────┘            │
│                                 │        │  │                      │  │        │                                 │
│                                 │        │  └──────────────────────┘  │        │                                 │
│                                 │        │                            │        │                                 │
│                                 │        └────────────────────────────┘        │                                 │
│                                 │                                              │                                 │
│                                 └──────────────────────────────────────────────┘                                 │
│                                                                                                                  │
│                                                                                                                  │
└──────────────────────────────────────────────────────────────────────────────────────────────────────────────────┘

                                                © Minh Hung Phan
```

### Logical Volume

The `nginx-config-vol` volume isn't created in the traditional sense on the Swarm Manager Node or the Swarm Worker Node. It's not a typical Docker volume that stores data on the Docker host's filesystem. Instead, it's a reference or a logical pointer to a remote filesystem, which is present on the Storage Driver Node. 

When you're using the `vieux/sshfs` plugin, Docker doesn't create a local volume on the Docker host. Rather, it sets up a network mount point. This is effectively a tunnel from the Docker host (Swarm Manager Node or Swarm Worker Node) to the Storage Driver Node. The actual files for the `nginx-config-vol` volume are stored on the `/etc/docker/storage` directory of the Storage Driver Node. The `nginx-config-vol` volume exists as a sort of "virtual volume" or a mount point on the Swarm nodes, allowing the Nginx containers to interact with the remote filesystem as though it was local. 

In other words, `nginx-config-vol` volume is a logical concept in the Swarm nodes that connects the Nginx containers with the `/etc/docker/storage` directory on the Storage Driver Node, where the actual data is stored and retrieved. 

The creation of the `nginx-config-vol` volume happens when you run the `docker service create` command, but it's not a physical entity stored on the Swarm nodes; it's more of an abstraction representing the connection to the remote filesystem.

### Network Mount

The connection between `/etc/nginx` in the Nginx container and the `nginx-config-vol` is established when the Docker service is created using the `docker service create` command, specifically through the `--mount` parameter. 

When Docker starts the Nginx service, it uses the options specified in the `--mount` parameter to set up a network mount for each instance (replica) of the Nginx service. This network mount links the `/etc/nginx` directory in the Nginx container to the `nginx-config-vol` volume, which is an abstraction for the remote filesystem located at `/etc/docker/storage` on the Storage Driver Node. 

The network mount behaves similarly to a traditional filesystem mount. It allows the Nginx container to read from and write to the remote filesystem as if it were a local directory. This is achieved through the `vieux/sshfs` plugin, which enables SSH File Transfer Protocol (SFTP) based mounts in Docker. 

Every time the Nginx container accesses the `/etc/nginx` directory, it's actually interacting with the `nginx-config-vol` volume, which in turn interacts with the remote filesystem. In this way, the Nginx container can seamlessly access and manipulate data that's physically located on another node.

This connection remains in place for the lifetime of the Docker service. If the service is removed, the connection would be severed, but the actual data on the Storage Driver Node would remain intact, unless manually deleted.

### Bind Mount or Volume?

In the traditional sense of Docker volumes and bind mounts, this case is somewhat different because it involves a remote filesystem rather than a local one. That being said, from Docker's perspective, it's still treated as a "Volume", albeit a special kind of volume facilitated by the `vieux/sshfs` plugin.

Let's break it down:

- Bind mounts have a very specific source directory on the host system. They link this source directory to the target directory in the Docker container.

- Volumes, on the other hand, are managed by Docker. The location of the volume on the host is determined by Docker and may not be as easily referenced as with bind mounts. Volumes can also be used by multiple containers simultaneously.

In this case, we're creating a "Volume" (`nginx-config-vol`) that links a specific location in the container (`/etc/nginx`) to a remote directory (`/etc/docker/storage` on the Storage Driver Node). While it's not a bind mount (because the source directory isn't on the local host system), and it's not a typical Docker volume (because the data isn't stored locally), it still falls under the umbrella term of "Docker Volume", due to its nature and usage.

In other words, it is still a type of volume, but a specialized one that uses a remote filesystem. This can also be referred to as a "network mount" or a "remote volume", facilitated by the Docker volume driver `vieux/sshfs` to connect to the remote filesystem over SSH.

## Solution

### Step 1: Log in to the Storage Server

Use the provided credentials to log in to the Storage Server:

```bash
ssh cloud_user@PUBLIC_IP_ADDRESS
```

### Step 2: Set up the External Storage Location

1. On the storage server, create the storage directory and grant access to `cloud_user`:

```bash
sudo mkdir -p /etc/docker/storage
sudo chown cloud_user:cloud_user /etc/docker/storage
```

2. To set up Nginx, create an `nginx.conf` file with the following contents:

```js
events {}

http {
  server {
    listen 9773;

    location / {
      root /usr/share/nginx/html;
    }
  }
}
```

This configuration defines a basic HTTP server block within Nginx. The server listens on port 9773 and serves content from the `/usr/share/nginx/html` directory. You can modify the `listen` directive to use a different port if desired. Ensure that the specified directory exists and contains the content you want to serve.

3. Now, copy the nginx configuration file into the storage directory:

```bash
cp /home/cloud_user/nginx.conf /etc/docker/storage/
```

### Step 3: Install the `vieux/sshfs` Plugin

Install the `vieux/sshfs` plugin on the swarm manager and worker node:

```bash
docker plugin install --grant-all-permissions vieux/sshfs
```

### Step 4: Create the Nginx Service That Uses the Shared Volume

1. Create the `nginx-web` service on the swarm manager:

```bash
docker service create -d \
   --replicas=3 \
   --name nginx-web \
   -p 8080:9773 \
   --mount volume-driver=vieux/sshfs,source=nginx-config-vol,target=/etc/nginx/,volume-opt=sshcmd=cloud_user@"<storage_server_ip_address>":/etc/docker/storage,volume-opt=password="<cloud_user_password>" nginx:latest
```
**Note**:
- Replace `<cloud_user_password>` with the actual password for `cloud_user`.
- Replace `<storage_server_ip_address>`with the actual storage server's ip address._

This command is used to create a new service in a Docker swarm. It's a bit complex, so let's break it down piece by piece:

* `docker service create`: This is the command used to create a new service in a Docker swarm. A service is a description of a task to be performed by the swarm, such as running a specific image on a certain number of nodes.

* `-d`: This flag stands for "detach". It runs the command in the background.

* `--replicas=3`: This flag specifies that Docker should maintain three instances (or "replicas") of this service across the swarm. If one of the instances fails or is deleted, Docker will automatically create a new one to replace it.

* `--name nginx-web`: This is the name that will be assigned to the service. It can be anything you like, but in this case it's being named "nginx-web".

* `-p 8080:9773`: This flag is mapping port 9773 inside the Docker service to port 8080 on the host machine. This means that if you were to visit `localhost:8080` on the host machine, it would redirect to port 9773 inside the Docker service.

* `--mount volume-driver=vieux/sshfs,source=nginx-config-vol,target=/etc/nginx/,volume-opt=sshcmd=cloud_user@"<storage_server_ip_address>":/etc/docker/storage,volume-opt=password="<cloud_user_password>"` : This flag is used to create a mount point in the service. It's a bit complicated, so let's break it down:
    - `volume-driver=vieux/sshfs`: This is specifying the driver to be used for the mount point. In this case, it's the sshfs driver, which allows for mounting of remote directories over SSH.
    - `source=nginx-config-vol`: This is the name of the volume on the host machine.
    - `target=/etc/nginx/`: This is the path where the volume will be mounted inside the Docker service.
    - `volume-opt=sshcmd=cloud_user@"<storage_server_ip_address>":/etc/docker/storage`: This is specifying the SSH command to be used by the sshfs driver. It's saying to connect as `cloud_user` to the storage server at `<storage_server_ip_address>`, and then to mount the `/etc/docker/storage` directory on the storage server.
    - `volume-opt=password="<cloud_user_password>"`: This is specifying the password to be used when connecting over SSH.

* `nginx:latest`: This is the image that the service will run. It's using the latest version of the nginx image from Docker Hub.

**Important**:

- This command is actually creating a single mount point inside the Docker container, which is `/etc/nginx/` as specified by `target=/etc/nginx/`. This path in the container is where the `nginx-config-vol` volume will be mounted.

- In other words, this command is telling Docker to create a new volume named `nginx-config-vol` (specified by `source=nginx-config-vol`), mount that volume at the location `/etc/nginx/` within the Docker container, and handle that volume with the `vieux/sshfs` driver.

- The `volume-opt=sshcmd` option provides the details of how to connect to a remote filesystem via SSH. The `sshcmd=cloud_user@"<storage_server_ip_address>":/etc/docker/storage` indicates that Docker will use the specified `cloud_user` to connect to the `<storage_server_ip_address>` server, and specifically to the `/etc/docker/storage` directory on that server.

- The `volume-opt=password="<cloud_user_password>"` is simply providing the password required to connect to the remote server as the `cloud_user`.

- So to clarify, there's only one mount point (`/etc/nginx/` inside the Docker container), but the volume being mounted there is connected to a remote filesystem on a different server (`<storage_server_ip_address>`). The details of how to connect to and interact with that remote filesystem are specified through the `volume-opt=sshcmd` and `volume-opt=password` options.

In summary, this command is creating a new Docker service named "nginx-web", running the latest version of the nginx image. It's set to always maintain three instances of the service, and it's mapping port 8080 on the host to port 9773 inside the service. It's also creating a mount point in the service at `/etc/nginx/`, which is using the sshfs driver to mount a remote directory over SSH. To clarify, the `sshfs` volume driver allows you to mount a remote directory on the storage server to a local directory on the Docker host. In this case, it's mounting the remote directory `/etc/docker/storage` on the storage server to the container's `/etc/nginx/` directory.

2. To view the status of the `nginx-web` Docker service, use the following command:

```bash
docker service ps  nginx-web
```

Output:

```plaintext
ID                  NAME                IMAGE               NODE                DESIRED STATE       CURRENT STATE            ERROR               PORTS
j7yjq49uomro        nginx-web.1         nginx:latest        ip-10-0-1-102       Running             Running 10 seconds ago
ihmrik6pl41q        nginx-web.2         nginx:latest        ip-10-0-1-102       Running             Running 9 seconds ago
54kgqjbfulmh        nginx-web.3         nginx:latest        ip-10-0-1-101       Running             Running 10 seconds ago
```

3. To verify that the service is working correctly:

```bash
curl localhost:8080
```

If you've followed the steps correctly, you should see the HTML from the nginx Welcome page.

## Relevant Documentation

- [Docker Swarm documentation](https://docs.docker.com/engine/swarm/)
- [Docker volumes documentation](https://docs.docker.com/storage/volumes/)
- [vieux/sshfs Docker plugin GitHub page](https://github.com/vieux/docker-volume-sshfs)

## Conclusion

Great job! You have successfully learned how to create and manage shared storage volumes across a Docker Swarm cluster. This knowledge will aid you in maintaining robust, flexible, and efficient applications with shared configurations.