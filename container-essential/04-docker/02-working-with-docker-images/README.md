# Working with Docker Images

## Table of Contents

- [Introduction](#introduction)
- [Concepts](#concepts)
- [Pulling an Alpine Image](#pulling-an-alpine-image)
- [Pulling an httpd Image](#pulling-an-httpd-image)
- [Pulling an nginx Image](#pulling-an-nginx-image)
- [Relevant Documentation](#relevant-documentation)
- [Conclusion](#conclusion)

## Introduction

Before we dive in, let's address a concept that many individuals may not be familiar with: Docker images and their utilization of COW (Copy-on-Write) technology. Take a moment to grasp this concept before we proceed.

## Concepts

Let's begin with the concept of a base image. This image serves as the foundation and contains the necessary binaries, libraries, and files specific to your requirements. For example, you might use an Apache image to set up a web server. Initially, all processes share this base image.

However, when a process needs to modify a file, such as a configuration file, a new layer is created. This layer acts as a copy of the original file, allowing the process to make changes independently. This means we have our base layer and a new layer, where the modifying process can access and make changes while other processes continue using the base copy.

Time to put your Docker image skills to the test! In this lab, you will use your newfound knowledge of Docker images to pull, build, and launch containers.

## Pulling an Alpine Image

1. Pull the latest `alpine` image from Docker Hub:

```bash
docker image pull alpine:latest
```

2. Confirm it is there with:

```bash
docker images
```

## Pulling an httpd Image

1. Pull the latest `httpd` image:

```bash
docker pull httpd:latest
```

> Note: If you don't put the version, the latest version is assumed.

## Pulling an nginx Image

1. Pull `nginx` version 1.15:

```bash
docker pull nginx:1.15
```

2. Confirm that it is there:

```bash
docker images
```

## Investigating Image History

Now that we have our images, let's examine their history to gain insights into the layers and changes that occurred.

For example, running docker history on the HTTPD image will display the various layers and their details. Similarly, we can explore the NGINX image history. However, the output may be more user-friendly if we access the Docker Hub or GitHub and examine the Dockerfile directly.

By visiting the Docker Hub and searching for the HTTPD image, we can access its Dockerfile. The Dockerfile outlines the steps and commands used to build the image. This can provide a clearer understanding of the image's composition and the changes introduced at each step.

1. Look at the history for the `httpd` image:

```bash
docker history httpd
```

2. Note the following command gives an error because the latest version is assumed:

```bash
docker history nginx
```

3. When you specify the right version, the command succeeds:

```bash
docker history nginx:1.15
```

## Relevant Documentation

- [Docker Image](https://docs.docker.com/engine/reference/commandline/image/)
- [Images and layers](https://docs.docker.com/storage/storagedriver/#images-and-layers)
- [Overview of best practices for writing Dockerfiles](https://docs.docker.com/develop/develop-images/dockerfile_best-practices/)

## Conclusion

Congratulations — you've completed this hands-on lab! By now, you should have a better grasp of Docker images and how they function. Feel free to explore further and continue your Docker journey. If you have any questions or require additional guidance, don't hesitate to reach out. Happy Dockerizing! 🚀
