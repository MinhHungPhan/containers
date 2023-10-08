# Docker Container Management

## Table of Contents

- [Introduction](#introduction)
- [Getting Started](#getting-started)
- [Running Containers](#running-containers)
- [Managing Containers](#managing-containers)
- [Additional Container Options](#additional-container-options)
- [Container Restart Policies](#container-restart-policies)
- [Relevant Documentation](#relevant-documentation)
- [Conclusion](#conclusion)

## Introduction

This README provides a comprehensive guide to executing and managing Docker containers using the `docker run` command. The `docker run` command is essential for running containers and offers various options and flags to customize container execution.

## Getting Started

To execute containers with Docker, follow the steps below:

1. Install Docker Community Edition on your Ubuntu server.

2. Familiarize yourself with the basic structure of the `docker run` command:

```bash
docker run [OPTIONS] IMAGE [COMMAND] [ARG...]
```

The required components include `docker`, `run`, and a reference to an image.

## Running Containers

The docker run command is used to run containers. Let's explore some examples:

1. Run a simple container using the `hello-world` image:

```bash
docker run hello-world
```

2. Run a container using a specific image tag, such as `nginx:1.15.11`:

```bash
docker run nginx:1.15.11
```

3. Run a container with a command and arguments, for instance, using the `busybox` image to echo "hello world":

```bash
docker run busybox echo hello world!
```

## Managing Containers

Once containers are running, you may need to manage them. Here are some useful commands:

1. List currently running containers:

```bash
docker ps
```

2. List all containers, including both running and stopped:

```bash
docker ps -a
```

3. Stop a running container:

```bash
docker container stop [CONTAINER_ID/NAME]
```

4. Start a stopped container:

```bash
docker container start [CONTAINER_ID/NAME]
```

5. Delete a container (make sure it is stopped first):

```bash
docker container rm [CONTAINER_ID/NAME]
```

## Additional Container Options

To customize container execution, you can use various flags with the `docker run` command. Here are some examples:

1. Run a container in detached mode (in the background):

```bash
docker run -d nginx
```

2. Assign a specific name to a container:

```bash
docker run --name my-nginx nginx
```

3. Set a restart policy for the container:

```bash
docker run --restart unless-stopped nginx
```

4. Publish container ports to access services:

```bash
docker run -p 8080:80 nginx
```

5. Set memory limits for the container:

```bash
docker run --memory 500M --memory-reservation 256M nginx
```

## Container Restart Policies

Restart policies define when a container should be automatically restarted. There are four possible values:

- `no` (default): The container is not automatically restarted.
- `on-failure`: The container restarts if it crashes or exits with a non-zero exit code.
- `always`: The container always restarts, even if it exits gracefully or with a zero exit code. It also restarts on daemon startup.
- `unless-stopped`: The container restarts unless it has been explicitly stopped by the user.

To set a restart policy, use the `--restart` flag followed by the desired policy. Choose the appropriate policy based on your container's behavior and requirements.

## Relevant Documentation

For more information on available options and flags, refer to [official Docker documentation](https://docs.docker.com/engine/reference/run/).

## Conclusion

Executing and managing Docker containers using the `docker run` command is a fundamental skill in working with Docker. This guide has provided an overview of the command's usage and demonstrated various options and commands for running and managing containers. Refer to the documentation for more details and explore further possibilities with Docker.

Thank you for reading!