# Pushing Docker Images to Docker Hub

## Table of Contents

- [Introduction](#introduction)
- [Prerequisites](#prerequisites)
- [Log into Docker Hub](#log-into-docker-hub)
- [Push Docker Image](#push-docker-image)
- [Relevant Documentation](#relevant-documentation)
- [Conclusion](#conclusion)

## Introduction

This tutorial provides instructions for pushing images to Docker Hub. Docker Hub is a cloud-based registry service that allows you to store and distribute Docker images.

## Prerequisites

**Docker Hub Account**: Sign up for a Docker Hub account if you do not have one already: https://hub.docker.com/signup

## Log into Docker Hub

Open your terminal and log into your Docker Hub account with the following command:

```bash
docker login
```

You will be prompted for your Docker Hub username and password. Once you've entered these credentials, you will be logged in.

## Push Docker Image

1. **Tag Docker Image**

List our existing images on Swarm Manager using this command:

```bash
docker images
```

Expected output:

```plaintext
REPOSITORY     TAG       IMAGE ID       CREATED         SIZE
all-products   1.0.0     0c5f216749a6   9 minutes ago   109MB
```

Before you can push your image to Docker Hub, you need to tag it with your Docker Hub username. This ensures that you can push the image to your account. Replace `<username>` with your Docker Hub username and `<image-id>` with the image id or tag you've created:

```bash
docker tag <image-id> <username>/<tag>
```

Tag the `all-products` image:

```bash
docker tag 0c5f216749a6 kientree/all-products:1.0.0
```

2. **Push Docker Image to Docker Hub**

You're now ready to push your Docker image to Docker Hub. Use the `docker push` command:

```bash
docker push <username>/<tag>
```

To push the tagged images to Docker Hub, run the following commands:

```bash
docker push kientree/all-products:1.0.0
```

Wait for the process to complete. Once it's done, you will have successfully pushed your Docker image to Docker Hub!

3. **Verify on Docker Hub**

To confirm your images have been pushed successfully, log into Docker Hub, navigate to your repositories, and you should see the new images there.

## Relevant Documentation

- [Docker Hub Documentation](https://docs.docker.com/docker-hub/)
- [Docker CLI Documentation](https://docs.docker.com/engine/reference/commandline/cli/)
- [Docker Official Images](https://github.com/docker-library/official-images)
- [Docker Community](https://www.docker.com/community)

## Conclusion

Congratulations! You have completed this hands-on lab.