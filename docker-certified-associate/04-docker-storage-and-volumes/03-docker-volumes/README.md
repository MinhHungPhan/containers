# Docker Volumes

Welcome to this tutorial on Docker Volumes. Docker containers are inherently ephemeral. They can be deleted or removed, and with their deletion, their internal data will be lost. However, there may be scenarios where persistent data is required. In such cases, Docker volumes come to the rescue. 

We will explore Docker volumes and their types, specifically focusing on two different types of mounts: bind mounts and volumes (yes, the term 'volume' is used in a general sense as well as a specific sense, which can be confusing!). We will also demonstrate how to create these mounts, share volumes across multiple containers, and provide commands for volume management.

## Table of Contents

- [Introduction](#introduction)
- [Bind Mounts](#bind-mounts)
- [Volumes](#volumes)
- [Creating Volumes and Bind Mounts](#creating-volumes-and-bind-mounts)
- [Sharing Volumes Between Containers](#sharing-volumes-between-containers)
- [Managing Volumes](#managing-volumes)
- [Relevant Documentation](#relevant-documentation)
- [Conclusion](#conclusion)

## Introduction

Docker containers are designed to be ephemeral, meaning their lifespan is transient. When a container is deleted or removed, its internal data is also lost. If persistent data is required, Docker provides a solution: Docker volumes. Docker volumes and bind mounts are two different types of mounts that can be used to attach external storage to containers.

```plaintext
┌────────────────────────────────────────────────────────────────────────────────┐
│Host                                                                            │
│                                                                                │
│                                                                                │
│                 ┌─────────────────────┐                                        │
│             ┌───│      Container      │────────────────┐                       │
│             │   └──────────┬──────────┘                │                       │
│             │              │                           │                       │
│             │              │                           │                       │
│          Volume        Bind Mount                 tmpfs Mount                  │
│             │              │                           │                       │
│             │              │                           │                       │
│             │              ▼                           ▼                       │
│             │   ┌─────────────────────┐     ┌────────────────────┐             │
│             │   │     Filesystem      │     │       Memory       │             │
│             │   │                     │     │                    │             │
│             │   │ ┌ ─ ─ ─ ─ ─ ─ ─ ─ ┐ │     │                    │             │
│             └───┼▶    Docker area     │     │                    │             │
│                 │ └ ─ ─ ─ ─ ─ ─ ─ ─ ┘ │     │                    │             │
│                 └─────────────────────┘     └────────────────────┘             │
│                                                                                │
└────────────────────────────────────────────────────────────────────────────────┘

                                © Minh Hung Phan
```


```plaintext
+----------------------------------+
|          Docker Storage          |
+----------------------------------+
|                                  |
|    +-------------------------+   |
|    |       Bind Mounts       |   |
|    +-------------------------+   |
|    | - Host Path             |   |
|    | - Container Path        |   |
|    +-------------------------+   |
|                                  |
|    +-------------------------+   |
|    |         Volumes         |   |
|    +-------------------------+   |
|    | - Host Storage          |   |
|    | - Docker Management     |   |
|    +-------------------------+   |
|                                  |
+----------------------------------+

         © Minh Hung Phan
```

```plaintext
┌───────────────────────────┐
│      Docker Storage       │
└───────────────────────────┘
Description: Represents the storage functionality in Docker.

          │
┌─────────────────────┐
│    Bind Mounts      │
└─────────────────────┘
Description: Option to bind a specific path on the host machine to a path in the container.
Components:
- Host Path: Specifies the specific path on the host machine to be bound.
- Container Path: Represents the corresponding path in the container where the host path is mounted.

          │
┌─────────────────────┐
│      Volumes        │
└─────────────────────┘
Description: Option to store data on the host file system, managed by Docker.
Components:
- Host Storage: Indicates the location on the host file system where the volume data is stored.
- Docker Management: Denotes Docker's management of the volume, including lifecycle and access for containers.

© Minh Hung Phan
```

## Bind Mounts

A bind mount mounts a specific path on the host machine to a container. This means bind mounts are less portable as they are more dependent on the directory structure and file system of the host machine. If you have some configuration files or data on your host machine that you need to make available to the container, then a bind mount is the solution.

## Volumes

Volumes, while also storing data on the host machine's file system, are entirely managed by Docker. This means that Docker will create a location on the host machine and manage it. Volumes are more portable than bind mounts as they don't depend on the host machine's specific file system or configuration. A single volume can be shared between multiple containers, allowing them to share data.

## Creating Volumes and Bind Mounts

Volumes and bind mounts can be created using either `--mount` or `-v` syntax. The `--mount` syntax is a bit more verbose but clearer to understand. The `-v` syntax is shorter but harder to understand at a glance.

Create a directory on the host with some test data.

```shell
cd ~/
mkdir message
echo Hello, World! > message/message.txt
```

### Create Volumes and Bind Mounts using --mount syntax

Create a bind mount using `--mount` syntax:

```shell
docker run --mount type=bind,source=/home/cloud_user/message,destination=/root,readonly busybox cat /root/message.txt
```

**Note**: Replace `cloud_user` with `<your-username>`

```plaintext
┌───────────────────────────────────────────────────────────┐
│Host                                                       │
│                                                           │
│                                                           │
│   ┌─────────────────┐             ┌─────────────────┐     │
│   │   FILESYSTEM    │             │    CONTAINER    │     │
│   ├─────────────────┤             ├─────────────────┤     │
│   │                 │             │                 │     │
│   │                 │             │                 │     │
│   │/home            │             │                 │     │
│   │└── /cloud_user  │             │  .              │     │
│   │    └── /message │             │  └── root       │     │
│   │           ▲     │             │        │        │     │
│   │           └─────┼─────────────┼────────┘        │     │
│   │                 │  Bind Mount │                 │     │
│   └─────────────────┘             └─────────────────┘     │
│                                                           │
│                                                           │
└───────────────────────────────────────────────────────────┘

                    © Minh Hung Phan

```

Imagine you have a box called Docker, and inside that box, you can run different containers, which are like separate virtual machines with their own environments.

Now, the above command is telling Docker to do the following:

1. "Hey Docker, please run a new container for me using the BusyBox image."
   - BusyBox is a lightweight operating system used for minimalistic container environments.

2. "Also, I want to connect a folder from my computer to this container."
   - It's like attaching a folder from your computer to the container, so they can share files.

3. "The folder on my computer is located at /home/cloud_user/message."
   - Replace `/home/cloud_user/message` with the actual path to the folder on your computer.

4. "Inside the container, I want this folder to appear as /root, and it should be read-only."
   - The container will see the attached folder as if it's located at /root, and it cannot modify the files in the folder.

5. "Lastly, I want you to show me the contents of a file called message.txt."
   - The container will display the text inside the file named message.txt, which should be located at /root/message.txt.

So, in summary, this command tells Docker to run a container using the BusyBox image. It connects a folder from your computer to the container, shows it as /root inside the container, and allows only reading the files in that folder. Then, it displays the contents of the file message.txt located inside the container at /root/message.txt.

Create a volume using `--mount` syntax:

```shell
docker run --mount type=volume,source=my-volume,destination=/root busybox sh -c 'echo hello > /root/message.txt && cat /root/message.txt'
```
**Note**: Replace `cloud_user` with `<your-username>`

```plaintext
┌───────────────────────────────────────────────────────────┐
│Host                                                       │
│                                                           │
│                                                           │
│  ┌─────────────────┐             ┌─────────────────┐      │
│  │   FILESYSTEM    │             │    CONTAINER    │      │
│  ├─────────────────┤             ├─────────────────┤      │
│  │                 │             │                 │      │
│  │                 │             │                 │      │
│  │                 │             │                 │      │
│  │    my-volume    │             │  .              │      │
│  │        ▲        │             │  └── root       │      │
│  │        │        │             │        │        │      │
│  │        └────────┼─────────────┼────────┘        │      │
│  │                 │   Volumne   │                 │      │
│  └─────────────────┘             └─────────────────┘      │
│                                                           │
│                                                           │
└───────────────────────────────────────────────────────────┘

                    © Minh Hung Phan
```

Imagine you have a box called Docker, and inside that box, you can run different containers, which are like separate virtual machines with their own environments.

Now, the above command is telling Docker to do the following:

1. "Hey Docker, please run a new container for me using the BusyBox image."
   - BusyBox is a lightweight operating system used for minimalistic container environments.

2. "I want to create a special storage space just for this container."
   - This storage space is called a volume. It's like a folder that can be shared between the host machine and the container.

3. "I'll name this volume 'my-volume' and make it available inside the container as /root."
   - The volume will be named 'my-volume' and it will appear as /root inside the container.

4. "Now, inside the container, please run the following commands:"
   - The following commands will be executed inside the container.

5. "First, write the word 'hello' into a file called message.txt located at /root."
   - It creates a file named message.txt at /root inside the container and writes the word 'hello' into it.

6. "Then, show me the contents of that message.txt file."
   - It displays the contents of the message.txt file, which should be 'hello'.

So, in summary, this command tells Docker to run a container using the BusyBox image. It creates a special storage space called a volume ('my-volume'), which is accessible as /root inside the container. Inside the container, it writes the word 'hello' into a file called message.txt and then displays the contents of that file.

### Create Volumes and Bind Mounts using --v syntax

It's important to note that we can also use the `-v` syntax to create both bind mounts and volumes, as shown below:

```shell
docker run -v /home/cloud_user/message:/root:ro busybox cat /root/message.txt
docker run -v my-volume:/root busybox cat /root/message.txt
```

**Note**: Replace `cloud_user` with `<your-username>`

## Sharing Volumes Between Containers

**Step 1: Creating a Shared Volume**

To create a shared volume, we can use the `--mount` syntax with the `docker run` command. Here's an example:

```shell
docker run --mount type=volume,source=shared-volume,destination=/root busybox sh -c 'echo This is shared data! > /root/message.txt'
```

In this command, we're creating a volume named `shared-volume` and mounting it to the `/root` directory inside the container. We then echo the text "This is shared data!" to the file `/root/message.txt` within the container.

**Step 2: Accessing the Shared Volume**

To access the data stored in the shared volume, we can run another container and mount the same volume. Here's an example:

```shell
docker run --mount type=volume,source=shared-volume,destination=/anotherplace busybox cat /anotherplace/message.txt
```

In this command, we create a new container and mount the `shared-volume` to the `/anotherplace` directory. We then use the `cat` command to read and print the contents of the file `/anotherplace/message.txt` within the container. As a result, we should see the message "This is shared data!" displayed in the output.

### Multiple Destinations for Shared Volumes

It's important to note that we can use the same volume and mount it to different destinations on different containers. This flexibility allows us to cater to the specific needs of each container's internal software. In the examples above, we used `/root` as the destination in the first container and `/anotherplace` in the second container.

### Usage with Services

When creating services in Docker, you can also utilize the `--mount` syntax for volume management. However, it's worth mentioning that the `-v` syntax is not applicable in this context. This is a syntax limitation specific to services. Therefore, when working with services, always use the `--mount` syntax.

By leveraging shared volumes, we can facilitate communication and data sharing between different containers. This capability empowers us to design systems where multiple pieces of software interact with the same data in various ways, depending on their specific requirements.

Please refer to the official Docker documentation for more information on volumes and container management.

## Managing Volumes

Docker also provides several commands to help manage volumes:

- **Listing Volumes:** The `docker volume ls` command lists all the volumes present on the host.

```shell
docker volume ls
```

- **Inspecting a Volume:** You can inspect a volume to get more information about it using `docker volume inspect <volume-name>`.

```shell
docker volume inspect shared-data
```

- **Removing a Volume:** To remove a volume, use the `docker volume rm <volume-name>` command.

```shell
docker volume rm shared-data
```

**Note**: Docker prevents the removal of a volume that is in use by a container.

- **Removing All Unused Volumes:** The `docker volume prune` command will remove all unused volumes. This can be helpful for housekeeping purposes.
```shell
docker volume prune
```

## Relevant Documentation

- [Docker Documentation - Docker Storage](https://docs.docker.com/storage/)
- [Docker Documentation - Volumes](https://docs.docker.com/storage/volumes/)
- [Docker Documentation - Bind mounts](https://docs.docker.com/storage/bind-mounts/)

## Conclusion

In conclusion, Docker volumes and bind mounts are crucial for data persistence and sharing data between containers. Bind mounts are dependent on the host machine's directory structure, making them less portable but suitable for specific use-cases where local files need to be made available to containers. On the other hand, volumes are entirely managed by Docker and offer a more portable solution for data persistence across multiple containers.

Remember, Docker volumes and bind mounts should be used thoughtfully to suit the requirements of your specific use case. Keep practicing to become comfortable with these features!