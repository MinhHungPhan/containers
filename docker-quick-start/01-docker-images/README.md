# Docker Image Basics

## Table of Contents

- [Introduction](#introduction)
- [Understanding Docker Image Layers](#understanding-docker-image-layers)
- [Creating Docker Images](#creating-docker-images)
- [Docker Base Images](#docker-base-images)
- [Install Docker Engine on CentOS](#install-docker-engine-on-centos)
- [Pull Ubuntu docker image](#pull-ubuntu-docker-image)
- [Relevant Documentation](#relevant-documentation)
- [Conclusion](#conclusion)

## Introduction

When working with Docker, it's essential to grasp the concept of Docker images. Docker images serve as the building blocks for containers, allowing you to package and distribute applications with their dependencies in a portable manner. In this guide, we'll explore the process of creating Docker images and discuss the significance of Docker base images.

## Understanding Docker Image Layers

Docker images are composed of multiple layers, and each change to the image results in a new layer. Let's take a closer look at the layers created by the official Ubuntu image. We can inspect the Dockerfile used to create the Ubuntu 16.04 image, which provides insights into the layer structure.

```plaintext
                                        +------------------------+
                                        |      Docker Image      |
                                        +------------------------+
                                        |                        |
                                        |   +----------------+   |
                                        |   |  Third Layer   |   |
                                        |   +----------------+   |
                                        |   | - Web App Code |   |
                                        |   +----------------+   |
                                        |                        |
                                        |   +----------------+   |
                                        |   | Second Layer   |   |
                                        |   +----------------+   |
                                        |   | - Python       |   |
                                        |   +----------------+   |
                                        |                        |
                                        |   +----------------+   |
                                        |   |  Base Layer    |   |
                                        |   +----------------+   |
                                        |   | - Ubuntu OS    |   |
                                        |   +----------------+   |
                                        |                        |
                                        +------------------------+

                                            © Minh Hung Phan                                   
```

**Example**:

```plaintext
┌────────────────────────────────────────┐      ┌────────────────────────────────────────┐
│                                        │      │                                        │
│            Onboarding image            │      │               Application              │
│                                        │      │                                        │
│                                        │      │                                        │
│     ┌────────────────────────────┐     │      │                                        │
│     │                            │     │      │                                        │
│     │  apt-get install python3   │     │      │                                        │
│     │                            │     │      │                                        │
│     ├────────────────────────────┤     │      │     ┌────────────────────────────┐     │
│     │                            │     │      │     │                            │     │
│     │       apt-get update       │     │      │     │      cp helloworld.py      │     │
│     │                            │     │      │     │                            │     │
│     ├────────────────────────────┤     │      │     ├────────────────────────────┤     │
│     │                            │     │      │     │                            │     │
│     │  Base image: Ubuntu 16:04  │     │      │     │    kientree:getstarted     │     │
│     │                            │     │      │     │                            │     │
└─────┴────────────────────────────┴─────┘      └─────┴────────────────────────────┴─────┘
                                                                                          
          kientree:getstarted                              kientree:helloworld             
                                                                                          
                                                                                          
                                     © Minh Hung Phan                                     
                                   
```

To interact with Docker images, we use commands like `docker images` to see the images on our system. The output displays the repository, tag, and image ID. Tags are like labels we can assign to images for versioning, categorization, or other purposes. The image ID uniquely identifies the image and consists of a SHA256 hash of the image layers.

## Creating Docker Images

To create a Docker image, you typically start with a base image that provides the foundation for your application. The base image contains the operating system and dependencies required to run your application. You can either use an existing base image from the Docker Hub or create your own custom base image.

Once you have a base image, you can define the necessary configurations and install additional software, libraries, and dependencies for your application. This process is typically done using a Dockerfile, which is a text file that contains a set of instructions for building the image. These instructions can include things like copying files, running commands, setting environment variables, and exposing ports.

After creating the Dockerfile, you can use the `docker build` command to build the Docker image. This command reads the instructions from the Dockerfile and generates a new image based on those instructions. The resulting image can be tagged with a version number or any other meaningful label.

## Docker Base Images

A Docker base image serves as the starting point for creating a new image. It provides the foundation of the operating system and often includes pre-installed software and libraries. Base images are typically designed to be lightweight and minimal, focusing only on the essentials needed to run common applications.

Docker Hub provides a wide range of official and community-maintained base images for different operating systems and programming languages. These base images are versioned, allowing you to choose a specific version that matches your requirements. It's important to select a base image that aligns with your application's needs to ensure compatibility and security.

## Install Docker Engine on CentOS

To get started with Docker, follow the steps below:

1. Install the required packages:

```bash
sudo su -
yum install -y yum-utils device-mapper-persistent-data lvm2
```

2. Add Docker repository to yum configuration:

```bash
yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
```

3. Install Docker:

```bash
yum install -y docker-ce
```

4. Enable and start Docker:

```bash
systemctl enable docker
systemctl start docker
```

Now you have Docker installed and ready to use!

## Pull Ubuntu docker image

1. Pull the Ubuntu 16.04 Docker image:

```bash
docker pull ubuntu:16.04
```

2. List docker images:

```bash
docker images
```

3. For a more comprehensive list, including full image IDs, use the `--no-trunc` flag:

```bash
docker images --no-trunc
```

## Relevant Documentation

- [Docker images](https://docs.docker.com/engine/reference/commandline/images/)
- [Install Docker Engine on CentOS](https://docs.docker.com/engine/install/centos/)

## Conclusion

Understanding Docker images is fundamental to effectively working with Docker containers. In this guide, we've covered the basics of creating Docker images using a base image and a Dockerfile. We've also discussed the importance of Docker base images as the foundation for building application-specific images. Happy Dockerizing!  🚀