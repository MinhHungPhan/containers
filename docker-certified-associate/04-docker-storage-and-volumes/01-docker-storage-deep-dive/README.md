# Docker Storage Deep Dive

This guide provides a detailed explanation of some key concepts related to Docker storage, such as storage drivers, storage models, and how to locate underlying data for containers and images on the host file system.

## Table of Contents

- [Introduction](#introduction)
- [Understanding Docker Storage Drivers](#understanding-docker-storage-drivers)
- [Understanding Storage Models](#understanding-storage-models)
- [Locating Container and Image Data](#locating-container-and-image-data)
- [Relevant Documentation](#relevant-documentation)
- [Conclusion](#conclusion)

## Introduction

Storage is a critical aspect of nearly every system, and containerized environments are no exception. In Docker, understanding the storage drivers and models is key to efficiently managing your containers. This guide will delve into the specifics of Docker storage, enhancing your grasp of these important concepts.

## Understanding Docker Storage Drivers

Storage drivers, also known as graph drivers, play a crucial role in Docker. They handle the details of data storage for your containers. The choice of storage driver largely depends on your operating system and other local configuration factors.

Three significant storage drivers you should be familiar with include:

1. **overlay2**: This driver is the default for Ubuntu, CentOS, and Red Hat servers later than version 7.
2. **aufs**: For older versions of Ubuntu (14.04 and earlier), aufs is the default storage driver.
3. **devicemapper**: This driver is the default for older CentOS servers.

Being aware of these drivers and their associated operating systems can greatly facilitate your Docker usage.

## Understanding Storage Models

Storage models describe how data is stored. In the context of Docker, there are three important storage models:

1. **Filesystem storage**: Your data is stored within files on a regular file system. Overlay2 and aufs both use this model. It is memory-efficient but less efficient for data-writing operations. 
2. **Block storage**: This model requires a separate device set up for block storage. Data is stored in specific blocks on a specially configured device. Devicemapper uses this model, which is more efficient for write-heavy workloads.
3. **Object storage**: In this model, data is stored in named objects with metadata, typically via a RESTful API communicating with an external object store. While flexible and scalable, it requires your application to be designed for object-based storage.

Being familiar with these terms and concepts will be beneficial in various Docker-related scenarios.

## Locating Container and Image Data

Each Docker container utilizes a layered file system. An image consists of multiple layers, and a container adds an additional writable layer on top, containing only the differences from the previous layer.

```plaintext
                                   ┌─────────────────────────────────────────┐                 
                                   │                                         │◀─┐              
                                   │        Writable Container Layer         │  │              
                                   │                                         │  │              
                                   └─────────────────────────────────────────┘  │              
                                                                                │              
                                                                                │              
                                                                                │              
                                   ┌─────────────────────────────────────────┐  │              
                                ┌─▶│                                         │  │              
                                │  │             Web Application             │  │              
                                │  │                                         │  ├─ Container  
                                │  └─────────────────────────────────────────┘  │              
                                │  ┌─────────────────────────────────────────┐  │              
                                │  │                                         │  │              
                         Image ─┤  │                 Python                  │  │              
                                │  │                                         │  │              
                                │  └─────────────────────────────────────────┘  │              
                                │  ┌─────────────────────────────────────────┐  │              
                                │  │                                         │  │              
                                │  │          Base Ubuntu OS Image           │  │              
                                └─▶│                                         │◀─┘              
                                   └─────────────────────────────────────────┘                         

                                                © Minh Hung Phan
```

Docker provides an easy way to inspect your container and image data through the `docker inspect` command. Let's explore an example with an Nginx container:

1. Run a basic container:

```bash
docker run --name storage_nginx nginx
```
2. Use `docker inspect` to find the location of the container's data on the host:

```bash
docker container inspect storage_nginx
ls /var/lib/docker/overlay2/<STORAGE_HASH>/
```

3. Use `docker inspect` to find the location of an image's data:

```bash
docker image inspect nginx
```

These steps will allow you to explore the data of your containers and images, and understand how they are stored on your system.

## Relevant Documentation

- [Select a storage driver - Docker Documentation](https://docs.docker.com/storage/storagedriver/select-storage-driver/)
- [Block, Object, and File Systems for Containers - SUSE Rancher Blog](https://www.suse.com/c/rancher_blog/block-storage-object-storage-and-file-systems-what-they-mean-for-containers/)

## Conclusion

Through this guide, we've delved into Docker's storage drivers, models, and how to locate data related to containers and images. This knowledge is crucial for managing and optimizing your Docker environments. Remember, there's always more to learn.
