# Dockerfile Components

## Table of Contents
- [Introduction](#introduction)
- [Setting up the Project Directory](#setting-up-the-project-directory)
- [Creating the Index File](#creating-the-index-file)
- [Creating the Dockerfile](#creating-the-dockerfile)
- [Building and Testing the Image](#building-and-testing-the-image)
- [Relevant Documentation](#relevant-documentation)
- [Conclusion](#conclusion)

## Introduction

In this tutorial, we will focus on building a custom Docker image using a Dockerfile. A Dockerfile is a text file that contains a set of instructions, called directives, for building a Docker image. These directives define the base image, environment variables, dependencies, and other configuration settings required for the image.

```plaintext
                                        +-----------------------+
                                        |      Dockerfile       |
                                        +-----------------------+
                                        |                       |
                                        |  +-----------------+  |
                                        |  |   Instructions  |  |
                                        |  +-----------------+  |
                                        |  | - FROM          |  |
                                        |  | - RUN           |  |
                                        |  | - COPY          |  |
                                        |  | - ENV           |  |
                                        |  | - CMD           |  |
                                        |  +-----------------+  |
                                        |                       |
                                        |  +-----------------+  |
                                        |  |    Directives   |  |
                                        |  +-----------------+  |
                                        |  | - ARG           |  |
                                        |  | - WORKDIR       |  |
                                        |  | - EXPOSE        |  |
                                        |  | - VOLUME        |  |
                                        |  +-----------------+  |
                                        |                       |
                                        |  +-----------------+  |
                                        |  |   Comments      |  |
                                        |  +-----------------+  |
                                        |                       |
                                        +-----------------------+

                                            © Minh Hung Phan
```

```plaintext
┌─────────────────────────┐
│       Dockerfile        │
└─────────────────────────┘
          │
   ┌──────┴────────┐
   │  Instructions │
   └───────────────┘
   Description: Represents the core instructions used in a Dockerfile to define the image.
   Components:
   - FROM: Specifies the base image to build upon.
   - RUN: Executes a command during the image build process.
   - COPY: Copies files and directories from the build context into the image.
   - ENV: Sets environment variables for the image.
   - CMD: Specifies the default command to be executed when a container is created from the image.

          │
   ┌──────┴────────┐
   │   Directives  │
   └───────────────┘
   Description: Represents additional directives used in a Dockerfile for configuring the build process.
   Components:
   - ARG: Defines variables that users can pass at build-time to the builder with the 'docker build' command.
   - WORKDIR: Sets the working directory for subsequent instructions in the Dockerfile.
   - EXPOSE: Exposes a specific port at runtime.
   - VOLUME: Creates a mount point for storing persistent data.

          │
   ┌───────────────┐
   │   Comments    │
   └───────────────┘
   Description: Represents comments within the Dockerfile for providing explanations or documentation.

© Minh Hung Phan
```

By utilizing Dockerfiles, developers can automate and standardize the process of building images, ensuring consistency across different environments and deployments. Dockerfiles also enable version control, allowing developers to track and manage changes to their image configurations over time.

Throughout this tutorial, we will explore the components of a Dockerfile and learn how to construct and build our own custom Docker image. We will specifically focus on creating a customized Nginx image, a popular web server and reverse proxy.

Now, let's dive into the details and start building our custom Nginx image!

## Setting up the Project Directory

Let's start by setting up a project directory. Open your terminal and follow these steps:

1. Create a new directory called `custom-nginx`: 

```bash
mkdir custom-nginx
```

2. Navigate to the project directory: 

```bash
cd custom-nginx
```

## Creating the Index File

Next, we'll create an `index.html` file that will serve as the main index file for our Nginx server. Open the file in a text editor and add the following content:

```html
Hello, World!
```

Save the file and close the text editor.

## Creating the Dockerfile

Now, let's create the Dockerfile. The Dockerfile is a text file that contains instructions for building a Docker image. In your project directory, create a new file called `Dockerfile` using a text editor. Paste the following content into the file:

```dockerfile
# Simple Nginx image
FROM ubuntu:bionic

ENV NGINX_VERSION 1.14.0-0ubuntu1.7

RUN apt-get update && apt-get install -y curl
RUN apt-get update && apt-get install -y nginx=$NGINX_VERSION

CMD ["nginx", "-g", "daemon off;"]
```

This Dockerfile consists of several directives:

- `FROM` specifies the base image for our custom image, in this case, `ubuntu:bionic`.
- `ENV` sets an environment variable, `NGINX_VERSION`, which we can reference throughout the Dockerfile.
- `RUN` executes commands within the image. Here, we update the package lists and install `curl` and `nginx` using the specified `NGINX_VERSION`.
- `CMD` provides the default command to run when a container is started based on this image. In our case, it starts the Nginx server.

Save the Dockerfile and close the text editor.

## Building and Testing the Image

With the Dockerfile in place, we can now build the Docker image and test it. Open your terminal and run the following commands:

```bash
docker build -t custom-nginx .
docker run --name custom-nginx -d -p 8080:80 custom-nginx
```

The first command (`docker build`) builds the Docker image based on the Dockerfile in the current directory. The `-t` flag tags the image with the name `custom-nginx`.

The second command (`docker run`) runs a container based on the `custom-nginx` image. It assigns the container the name `custom-nginx`, runs it in detached mode (`-d`), and maps port `8080` on the host to port `80` on the container.

Finally, you can test if the Nginx server is running correctly by executing the following command:

```bash
curl localhost:8080
```

If everything is set up correctly, you should see the Nginx welcome page displayed in your terminal.

## Relevant Documentation

Please note that this tutorial only scratches the surface of Docker's capabilities. To learn more about Dockerfile directives and advanced usage, refer to the [official Docker documentation](https://docs.docker.com/engine/reference/builder/).

## Conclusion

Congratulations! You have successfully built a custom Nginx Docker image using a Dockerfile and tested it by running it as a container. In this tutorial, we covered the basic directives of a Dockerfile and demonstrated how to use them to create a simple Docker image.