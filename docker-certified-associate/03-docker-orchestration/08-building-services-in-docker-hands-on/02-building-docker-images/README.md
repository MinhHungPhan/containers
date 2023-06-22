
# Building Docker Images

This repository contains a Dockerfile that uses multi-stage builds to create two different Docker images based on JSON responses.

## Table of Contents

- [Prerequisites](#prerequisites)
- [Directory Structure](#directory-structure)
- [Build Docker Images](#build-docker-images)
- [Verify the Docker Images](#verify-the-docker-images)
- [Run the Docker Containers](#run-the-docker-containers)
- [Conclusion](#conclusion)

## Prerequisites

Before building the Docker images, ensure that you have the following prerequisites in place:

- **Docker**: Make sure you have Docker installed on your system. You can download Docker from the official website: https://www.docker.com/.

- **Docker Swarm**: Set up Docker Swarm on a cluster of three nodes. Docker Swarm allows you to create and manage a swarm of Docker nodes, enabling distributed and scalable container deployments. Refer to the Docker documentation for instructions on setting up Docker Swarm: https://docs.docker.com/engine/swarm/.

## Directory Structure

```plaintext
.
├── fruit-list
│   ├── static
│   │   └── fruit.json
│   └── nginx.conf
├── vegetable-list
│   ├── static
│   │   └── vegetable.json
│   └── nginx.conf
└── Dockerfile
```

- **fruit-list**:
  - **static**:
    - `fruit.json`: A JSON file containing the list of fruits.

  - `nginx.conf`: The Nginx configuration file specific to the fruit-list application.

- **vegetable-list**:
  - **static**:
    - `vegetable.json`: A JSON file containing the list of vegetables.

  - `nginx.conf`: The Nginx configuration file specific to the vegetable-list application.

- **Dockerfile**: A multi-stage Dockerfile used to build two separate Docker images, one for handling the fruits data and another for the vegetables data.

## Build Docker Images

To build the Docker images, follow these steps:

1. Navigate to the directory containing the Dockerfile. You should see the following output by executing the `ls` command:

```plaintext
Dockerfile      fruit-list      vegetable-list
```

2. Run the following command to build the fruit image:

```bash
docker build --target fruit -t fruit-list:1.0.0 .
```
    
3. Run the following command to build the vegetable image:

```bash
docker build --target vegetable -t vegetable-list:1.0.0 .
```

These commands build two Docker images named `fruit-list:1.0.0` and `vegetable-list:1.0.0`.

## Verify the Docker Images

After the build process completes successfully, you can verify the images have been created by running the following command:

```bash
docker images
```
The `fruit-list:1.0.0` and `vegetable-list:1.0.0` should be listed among the Docker images on your local machine.

```plaintext
REPOSITORY       TAG       IMAGE ID       CREATED          SIZE
vegetable-list   1.0.0     fe71a79f5e09   21 seconds ago   109MB
fruit-list       1.0.0     72da098ae20f   43 seconds ago   109MB
```

## Run the Docker Containers

Now you can run a Docker container from these images. Each container will start and print the contents of the corresponding JSON file when it starts. To do this, run the following commands:

For the fruits container:

```bash
docker run --name fruit-list -d -p 8080:80 fruit-list:1.0.0
```

This will make the `fruit.json` file accessible at `http://localhost:8080/fruit.json`.

Make a request to the container and verify that you receive some JSON data containing a list of fruits:

```bash
curl localhost:8080
```

For the vegetables container:

```bash
docker run --name vegetable-list -d -p 8081:80 vegetable-list:1.0.0
```

This will make the `vegetable.json` file accessible at `http://localhost:8081/vegetable.json`.

Make a request to the container and verify that you receive some JSON data containing a list of vegetables:

```bash
curl localhost:8081
```

## Relevant Documentation

- [Images and layers](https://docs.docker.com/storage/storagedriver/#images-and-layers)
- [Dockerfile Best Practices](https://docs.docker.com/develop/develop-images/dockerfile_best-practices/)
- [Multi-stage Build](https://docs.docker.com/develop/develop-images/multistage-build/)

## Conclusion

Congratulations! You have completed this hands-on lab.