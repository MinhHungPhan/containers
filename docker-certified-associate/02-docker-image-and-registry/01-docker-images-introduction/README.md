# Introduction to Docker Images

**Table of Contents**
- [What are Docker Images?](#what-are-docker-images)
- [The Layered File System](#the-layered-file-system)
- [Examining Image Layers](#examining-image-layers)
- [Relevant Documentation](#relevant-documentation)
- [Conclusion](#conclusion)

Welcome to the tutorial on **Introduction to Docker Images**! In this section, we will explore Docker images and gain a better understanding of their purpose and structure.

## What are Docker Images?

A Docker image is a file that contains all the necessary code and components to run software within a container. It serves as a self-contained package that encapsulates everything required for an application or service to function consistently across different environments.

When we reference an image, we are specifying which image to use when running a container. Docker images are often stored in repositories, such as Docker Hub, which allows easy distribution and sharing of images.

## The Layered File System

Docker images are built using a layered file system. This means that an image is composed of multiple layers, each containing the differences from the previous layer. Let's take a simplified example to understand this concept.

Imagine we have an image consisting of three layers:
1. Base layer: Ubuntu OS
2. Second layer: Python installation
3. Third layer: Web application code specific to the container

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

Instead of duplicating the entire image for each layer, Docker only includes the differences or changes made in each layer. For example, the second layer will contain only the files and changes related to Python installation.

This layered approach has several advantages. Firstly, it allows the sharing of layers between containers and images. For instance, multiple containers running the same image can share the common layers, reducing storage requirements. Similarly, different images can share common layers, leading to a smaller overall storage footprint.

Additionally, the layered file system enables faster image transfer and build times. When pulling an image, Docker only needs to download the layers that are not already present locally. Similarly, when building images, only the changed layers and those above them need to be rebuilt. This optimization significantly speeds up the development and deployment process.

## Examining Image Layers

To examine the layers present in an image, you can use the `docker image history` command. For example, to view the layers in the `nginx` image, execute the following command:

```bash
docker image history nginx
```


This command provides a list of the layers within the image. Some layers might be listed as 0 bytes, known as "no operation" layers, as they don't introduce any new data or differences.

## Relevant Documentation

For further information, you can refer to the [official Docker documentation](https://docs.docker.com/v17.09/engine/userguide/storagedriver/imagesandcontainers/).

## Conclusion

In this tutorial, we covered the fundamentals of Docker images. We discussed how Docker images are self-contained packages containing all the necessary components to run software in containers. We also explored the concept of layered file systems, which offer various advantages like shared layers, reduced storage footprint, faster image transfers, and quicker build times.

