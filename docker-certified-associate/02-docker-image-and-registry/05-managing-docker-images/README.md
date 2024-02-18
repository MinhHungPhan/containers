# Docker Image Management

In this guide, we are going to discuss some of the common Docker commands to manage images located on your machine. You'll learn how to download, inspect, and remove Docker images effectively from your system.

## Table of Contents

- [Introduction](#introduction)
- [Tutorial Reference](#tutorial-reference)
- [Relevant Documentation](#relevant-documentation)
- [Conclusion](#conclusion)

## Introduction

In previous tutorials, we've learned how to create Docker images. In this guide, however, our focus will be on managing these images that are already stored on our system.

## Tutorial Reference

Below are the various Docker commands we'll be exploring:

1. Download an image:

```shell
docker image pull nginx:1.14.0
```

2. List images on the system:

```shell
docker image ls
docker image ls -a
```

3. Inspect image metadata:

```shell
docker image inspect nginx:1.14.0
docker image inspect nginx:1.14.0 --format "{{.Architecture}}"
docker image inspect nginx:1.14.0 --format "{{.Architecture}} {{.Os}}"
```

4. Delete an image:

```shell
docker image rm nginx:1.14.0
```

5. Force deletion of an image that is in use by a container:

```shell
docker run -d --name nginx nginx:1.14.0
docker image rm -f nginx:1.14.0
```

6. Locate a dangling image and clean it up:

```shell
docker image ls -a
docker container ls
docker container rm -f nginx
docker image ls -a
docker image prune
```

## Relevant Documentation

- [docker image](https://docs.docker.com/engine/reference/commandline/image/)
- [Manage images](https://docs.mirantis.com/msr/2.9/ops/manage-images.html)

## Conclusion

We have learned a range of commands that help manage Docker images, which includes downloading, inspecting, and removing images from the system. Regularly managing these images can help maintain the smooth operation of your Docker system and also prevent accumulation of unused or 'dangling' images. Always be sure to check the official Docker documentation for any further details or updates. 
