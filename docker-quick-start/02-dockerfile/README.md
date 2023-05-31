# Dockerfile Basics

## Table of Contents
- [Introduction](#introduction)
- [Writing a Dockerfile](#writing-a-dockerfile)
- [Building Docker Images](#building-docker-images)
- [Understanding Image Layers](#understanding-image-layers)
- [Docker Installation](#docker-installation)
- [Dockerfile Creation](#dockerfile-creation)
- [Conclusion](#conclusion)

## Introduction

Welcome to the world of Dockerfiles! In this guide, we'll dive into the Dockerfile, a powerful tool for defining Docker images. We'll cover the basics of writing a Dockerfile, building images, and understanding image layers. By the end, you'll be equipped to create your own Docker images and leverage the full potential of Docker.

## Writing a Dockerfile

A Dockerfile is a text file that contains a set of instructions for building a Docker image. It specifies the base image, the dependencies to install, configuration changes, and more. To get started, create a new directory and navigate into it. Then, create a file named `Dockerfile` (note: the filename is case-sensitive).

In the Dockerfile, you'll typically start with a `FROM` instruction to specify the base image. For example, `FROM ubuntu:16.04` sets Ubuntu 16.04 as the base image. You can then use various instructions like `RUN`, `COPY`, `ENV`, and `EXPOSE` to define the steps required to build the image.

## Building Docker Images

To build a Docker image from a Dockerfile, use the `docker build` command. Navigate to the directory containing the Dockerfile and run `docker build .`. This command reads the instructions from the Dockerfile and builds the image based on those instructions. You can also specify a tag for the image using the `-t` option.

During the build process, Docker executes each instruction in the Dockerfile and creates intermediate images. These intermediate images are cached and reused for subsequent builds, making the process more efficient.

## Understanding Image Layers

Docker images are composed of multiple layers. Each instruction in the Dockerfile creates a new layer in the image. Layers are lightweight and reusable, enabling efficient storage and distribution of images.

When building an image, Docker only rebuilds the layers that have changed, leveraging the cache for unchanged layers. This saves time and resources during the build process.

## Docker Installation

To get started with Docker, follow the steps below:

1. Install the required packages:
```bash
sudo yum install -y yum-utils device-mapper-persistent-data lvm2
```

2. Add Docker repository to yum configuration:
```bash
sudo yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
```

3. Install Docker:
```bash
sudo yum install -y docker-ce
```

4. Enable and start Docker:
```bash
sudo systemctl enable docker
sudo systemctl start docker
```

## Dockerfile Creation

To create a Dockerfile with Python installation, follow the steps below:

1. Create and navigate to the `/onboarding` directory:
```bash
sudo mkdir /onboarding
cd /onboarding
```

2. Create the Dockerfile with Python installation:
```bash
sudo bash -c 'cat <<EOF > Dockerfile
FROM ubuntu:16.04
LABEL maintainer="@minhhung.phan@kientree.com"
RUN apt-get update && apt-get install -y python3
EOF'
```

3. Build the Docker image from the Dockerfile:
```bash
sudo docker build .
```

## Conclusion

Congratulations on learning the basics of Dockerfiles! You now have the knowledge to write your own Dockerfile and build custom Docker images. By understanding image layers, you can optimize your image builds and leverage the benefits of Docker's layered architecture.

Now, it's time to experiment and explore the possibilities with Dockerfiles. Feel free to dive deeper into Dockerfile instructions, explore advanced features, and create customized images for your applications.

Happy Dockerizing!
