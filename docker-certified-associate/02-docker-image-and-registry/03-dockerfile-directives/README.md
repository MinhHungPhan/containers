# Dockerfile Advanced Directives

## Table of Contents

- [Introduction](#introduction)
- [Directives Introduction](#directives-introduction)
- [Explaining Directives](#explaining-directives)
- [Dockerfile Editing](#dockerfile-editing)
- [Dockerfile Customization](#dockerfile-customization)
- [Build and Run Custom Docker Image](#build-and-run-custom-docker-image)
- [Clean Up](#clean-up)
- [Relevant Documentation](#relevant-documentation)
- [Conclusion](#conclusion)

## Introduction

This tutorial dives deeper into Dockerfile directives that can help you to create more sophisticated and customized Docker images. We will not be covering every possible directive available in Docker, so for comprehensive information, please refer to the Docker Documentation.

The project from our previous tutorial will be used as the base. In that project, we have a Dockerfile and an index.html file with a simple "Hello, World!" message.

## Directives Introduction

Below are the directives we're going to explore:

1. `EXPOSE`
2. `WORKDIR`
3. `COPY`
4. `ADD`
5. `STOPSIGNAL`
6. `HEALTHCHECK`

## Explaining Directives

- `EXPOSE`: This directive is used to document the ports that your image should listen on. Although it does not actually publish the port, it is useful for Docker commands and the Docker daemon to know which ports are intended to be published when running the container.

- `WORKDIR`: This directive sets the current working directory inside the Docker image. Any RUN, CMD, ENTRYPOINT, COPY, or ADD instructions that follow the WORKDIR instruction will be executed in the specified working directory.

- `COPY` and `ADD`: Both of these directives allow files from your host to be added to your Docker image. `ADD` has additional features, such as the ability to download files from a URL and unpack compressed files.

- `STOPSIGNAL`: This directive allows customization of the termination signal that will be sent to the container process when it needs to be stopped.

- `HEALTHCHECK`: This directive allows a command to be specified that will determine if the container is running in a healthy state.

## Dockerfile Editing

Let's start by navigating to the project directory and opening the Dockerfile.

```bash
cd ~/custom-nginx
vi Dockerfile
```

## Dockerfile Customization

We will add these directives into our Dockerfile to customize our Nginx image further. The Dockerfile now looks like:

```bash
# Simple nginx image
FROM ubuntu:bionic
ENV NGINX_VERSION 1.14.0-0ubuntu1.7
RUN apt-get update && apt-get install -y curl
RUN apt-get update && apt-get install -y nginx=$NGINX_VERSION
WORKDIR /var/www/html/
ADD index.html ./
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
STOPSIGNAL SIGTERM
HEALTHCHECK CMD curl localhost:80
```

## Build and Run Custom Docker Image

After adding the directives, we can now build and run our Docker image:

```bash
docker build -t custom-nginx .
docker run -d -p 8080:80 custom-nginx
```

Test if everything is working by accessing the Nginx server:

```bash
curl localhost:8080
```

The output should be "Hello, world!".

## Clean Up

Find the ID of the running container:

```bash
docker ps
```

Then remove the container:

```bash
docker container rm -f <container id>
```

## Relevant Documentation

For detailed information about Dockerfile directives, please refer to the [official Docker Documentation](https://docs.docker.com/engine/reference/builder/).

## Conclusion

We've now successfully customized our Dockerfile using various directives. For more information about other Dockerfile directives and more usage details, refer to the official Docker documentation. Enjoy dockerizing!
