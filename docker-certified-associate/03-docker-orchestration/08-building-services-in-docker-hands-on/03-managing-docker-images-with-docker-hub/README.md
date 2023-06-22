# Docker Images Management with Docker Hub

## Table of Contents

- [Introduction](#introduction)
- [Prerequisites](#prerequisites)
- [Log into Docker Hub](#log-into-docker-hub)
- [Build Docker Image](#build-docker-image)
- [Push Docker Image](#push-docker-image)
- [Pull Docker Image](#pull-docker-image)
- [Relevant Documentation](#relevant-documentation)
- [Conclusion](#conclusion)

## Introduction

This tutorial provides instructions for managing Docker images, including building, pushing, and pulling images to and from Docker Hub. Docker Hub is a cloud-based registry service that allows you to store and distribute Docker images.

## Prerequisites

**Docker Hub Account**: Sign up for a Docker Hub account if you do not have one already: https://hub.docker.com/signup

## Log into Docker Hub

Open your terminal and log into your Docker Hub account with the following command:

```bash
docker login
```

You will be prompted for your Docker Hub username and password. Once you've entered these credentials, you will be logged in.

## Build Docker Image

Navigate to the directory containing your Dockerfile and run the `docker build` command. Replace `<tag>` with a suitable name for your image:

```bash
docker build -t <tag> .
```

## Push Docker Image

1. **Tag Docker Image**

List our existing images on Swarm Manager using this command:

```bash
docker images
```

Expected output:

```plaintext
REPOSITORY       TAG       IMAGE ID       CREATED          SIZE
vegetable-list   1.0.0     74348fd0acdd   33 minutes ago   109MB
fruit-list       1.0.0     9f8d0b4d543e   33 minutes ago   109MB
```

Before you can push your image to Docker Hub, you need to tag it with your Docker Hub username. This ensures that you can push the image to your account. Replace `<username>` with your Docker Hub username and `<image-id>` with the image id or tag you've created:

```bash
docker tag <image-id> <username>/<tag>
```

Tag the `fruit-list` image:

```bash
docker tag 9f8d0b4d543e kientree/fruit-service:1.0.0
```

Tag the `vegetable-list` image:

```bash
docker tag 74348fd0acdd kientree/vegetable-service:1.0.0
```

2. **Push Docker Image to Docker Hub**

You're now ready to push your Docker image to Docker Hub. Use the `docker push` command:

```bash
docker push <username>/<tag>
```

To push the tagged images to Docker Hub, run the following commands:

```bash
docker push kientree/fruit-service:1.0.0
docker push kientree/vegetable-service:1.0.0
```

Wait for the process to complete. Once it's done, you will have successfully pushed your Docker image to Docker Hub!

3. **Verify on Docker Hub**

To confirm your images have been pushed successfully, log into Docker Hub, navigate to your repositories, and you should see the new images there.

## Pull Docker Image

1. **Connect to the Docker worker nodes**

Ensure that you have SSH access to both Docker worker nodes. You will need to execute the following steps on each node individually.

2. **Connect to the Docker daemon**

Open a terminal or SSH session on the first Docker worker node and connect to the Docker daemon by running the following command:

```bash
docker login
```

This command prompts you to enter your Docker Hub credentials. If you are pulling from a private registry, you may need to provide additional authentication details.

3. **Pull the Docker Image from Docker Hub**

To pull the `kientree/fruit-service:1.0.0` image, use the following command:

```bash
docker pull kientree/fruit-service:1.0.0
```

To pull the `kientree/vegetable-service:1.0.0` image, use the following command:

```bash
docker pull kientree/vegetable-service:1.0.0
```

Once the images are successfully pulled, you can use them to create containers or run them as needed.

## Relevant Documentation

- [Docker Hub Documentation](https://docs.docker.com/docker-hub/)
- [Docker CLI Documentation](https://docs.docker.com/engine/reference/commandline/cli/)
- [Docker Official Images](https://github.com/docker-library/official-images)
- [Docker Community](https://www.docker.com/community)

## Conclusion

Congratulations! You have completed this hands-on lab.