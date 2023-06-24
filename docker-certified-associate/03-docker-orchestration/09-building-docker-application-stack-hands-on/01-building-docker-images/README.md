
# Building Docker Images

## Table of Contents

- [Introduction](#introduction)
- [Build Docker Images](#build-docker-images)
- [Verify the Docker Images](#verify-the-docker-images)
- [Run the Docker Containers](#run-the-docker-containers)
- [Conclusion](#conclusion)

## Introduction

This repository contains a Dockerfile for a simple NGINX-based containerized application that serves a static JSON file. The Dockerfile sets up an NGINX server, copies a static file named `produce.json` into the NGINX HTML directory, and includes an NGINX configuration file named `nginx.conf`.

When the Docker image is built and a container is created from it, the NGINX server starts and listens on port 80. The `produce.json` file can be accessed by making an HTTP request to the container's IP address or hostname.

## Build Docker Images

To build the Docker images, follow these steps:

1. Change to the project directory and create a Dockerfile:

```bash
cd ~/produce-list
vi Dockerfile
```

2. Construct a Dockerfile that meets the provided specifications:

```Dockerfile
# Base Image
FROM nginx:1.15.8

# Copy static file to nginx html directory
COPY static/produce.json /usr/share/nginx/html/produce.json

# Copy nginx configuration
COPY nginx.conf /etc/nginx/nginx.conf

# Expose port 80
EXPOSE 80

# Start Nginx when the container has provisioned.
CMD ["nginx", "-g", "daemon off;"]
```

3. Run the following command to build the `all-products` image:

```bash
docker build -t all-products:1.0.0 .
```

## Verify the Docker Images

After the build process completes successfully, you can verify the images have been created by running the following command:

```bash
docker images
```

Expected ouput:

```plaintext
REPOSITORY     TAG       IMAGE ID       CREATED          SIZE
all-products   1.0.0     0c5f216749a6   11 seconds ago   109MB
```

## Run the Docker Containers

Now you can run a Docker container from these images. Each container will start and print the contents of the corresponding JSON file when it starts. To do this, run the following commands:

1. Run a container in detached mode using the newly-created image:

```bash
docker run --name produce-list -d -p 8080:80 all-products:1.0.0
```

2. Make a request to the container and verify that you receive some JSON data containing a list of produce:

```bash
curl localhost:8080
```

## Relevant Documentation

- [Images and layers](https://docs.docker.com/storage/storagedriver/#images-and-layers)
- [Dockerfile Best Practices](https://docs.docker.com/develop/develop-images/dockerfile_best-practices/)
- [nginx documentation](https://nginx.org/en/docs/)
- [Docker Documentation](https://docs.docker.com/)

## Conclusion

Congratulations! You have completed this hands-on lab.