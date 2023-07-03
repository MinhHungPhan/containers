# Docker Image Cleanup

Welcome to this guide on Docker image cleanup. This guide aims to walk you through Docker image cleanup, an important task if you're managing Docker systems. Over time, as you use Docker, your system might accumulate old image data that's no longer needed, taking up precious storage. This guide will explain how to identify and clean up this data to maintain efficient storage management on your Docker host.

## Table of Contents

- [Introduction](#introduction)
- [Docker Storage Examination](#docker-storage-examination)
- [Cleaning Up Unused Images](#cleaning-up-unused-images)
- [Relevant Documentation](#relevant-documentation)
- [Conclusion](#conclusion)
- [References](#references)

## Introduction

Managing Docker systems involves keeping track of and managing the storage available on those systems, and part of that management includes cleaning up data that's no longer needed. Docker images can be a major source of this unused data. Let's delve into how to clean up Docker image data that's no longer needed on a Docker host.

## Docker Storage Examination

The first step in managing your Docker system's storage is examining what's taking up space. The `docker system df` command is perfect for this. It shows how much space Docker is using on a system and what that storage space is being used for. 

Here's an example of this command in action:

```bash
docker system df
```

This will output information regarding the amount of space being used for images, containers, local volumes, and build cache.

To get more detailed information, use the verbose flag `-v`:

```bash
docker system df -v
```

This command will provide a more detailed overview, including individual images, containers, and volumes. These commands are extremely useful for identifying data that's no longer needed and could be removed to free up storage.

## Cleaning Up Unused Images

Docker provides the `docker image prune` command for cleaning up image data. This command scans for image data not referenced by any tag or container and automatically deletes that image data. 

Here's how you use the `docker image prune` command:

```bash
docker image prune
```

You can also use `docker image prune` with the `-a` flag. Regular `docker image prune` looks for images with no tags and no containers. But when you use `-a`, the only criterion is that the image has no container. Even if tags are referencing the image, if there are no containers using it, it will still be removed.

Here's an example of how to use `docker image prune -a`:

1. Pulling an unused image for demonstration:

```bash
docker pull nginx:1.14.0
```

2. Deletes the nginx image as it is not being used in a container:

```bash
docker image prune -a 
```

The `docker image prune -a` command is especially useful on a production Docker server, as there's usually not much reason to keep an image on the server if it's not being used in a container.

## Relevant Documentation

- [Docker System Commands](https://docs.docker.com/engine/reference/commandline/system/)
- [Docker Prune Command](https://docs.docker.com/engine/reference/commandline/image_prune/)
- [Docker Storage Overview](https://docs.docker.com/storage/)

## Conclusion

Managing your Docker system's storage involves understanding how to use commands like `docker system df` to examine your storage situation and `docker image prune` to delete unused images. By regularly using these commands, you can maintain efficient storage management on your Docker host. 