# Creating Your Own Docker Image

This document serves as a guide to help you create your own Docker image, particularly for a simple web service that provides a static list of fresh fruits available in the supermarket. 

## Table of Contents

- [Introduction](#Introduction)
- [Additional Resources](#Additional-Resources)
- [Specifications](#Specifications)
- [Testing](#Testing)
- [Solution](#Solution)
- [Relevant Documentation](#relevant-documentation)
- [Conclusion](#Conclusion)

## Introduction

Docker Hub offers a range of useful, pre-made images for various applications. However, to leverage Docker in real-world scenarios, you'll often need to design and build your own Docker images. This might be to customize existing images or run your unique software.

## Additional Resources

Let's consider a scenario: Your supermarket firm has a simple nginx-based web service that shows a static list of fresh fruits available in their stores. They want to operate this service as a Docker container in their new swarm environment, and need you to build a Docker image for this service.

On the provided lab server, you will find a directory at `/home/cloud_user/fruit-list/`. The files necessary for image creation are in this directory. 

## Specifications

You will create a Dockerfile to define the image according to the provided specifications and then test the image by running a container in detached mode. You should also verify that you can access the fresh fruit data from the application.

Your image should adhere to the following specifications:

- Use nginx tag 1.15.8 as the base image.
- Include the static fresh fruit data so it's served by the nginx server. The data file is located on the server at `static/fruit.json` under the project directory. Add this file to the image at `/usr/share/nginx/html/fruit.json`.
- Include the nginx configuration file (`nginx.conf`), located on the server in the project directory, at `/etc/nginx/nginx.conf`.
- The image should expose port 80.
- The default command should be: `nginx -g daemon off;`.
- Build the image with the tag `fruit-list:1.0.0`.

## Testing

Once the image is built, test it by running it as a container using the following command:

```bash
docker run --name fruit-list -d -p 8080:80 fruit-list:1.0.0
```

Confirm that the container serves the required data by making a request to it on port 8080. If everything is set up correctly, you should receive a JSON list of fruits:

```bash
curl localhost:8080
```

## Solution

Start by logging into the lab server with the credentials provided on the hands-on lab page:

```bash
ssh cloud_user@PUBLIC_IP_ADDRESS
```

Change to the project directory and create a Dockerfile:

```bash
cd ~/fruit-list
vi Dockerfile
```

Construct a Dockerfile that meets the provided specifications:

```Dockerfile
FROM nginx:1.15.8

ADD static/fruit.json /usr/share/nginx/html/fruit.json
ADD nginx.conf /etc/nginx/nginx.conf

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
```

Build the image:

```bash
docker build -t fruit-list:1.0.0 .
```

List the images:

```bash
docker images
```

Expected ouput:

```plaintext
cloud_user@ip-10-0-1-101:~/fruit-list$ docker images
REPOSITORY          TAG                 IMAGE ID            CREATED             SIZE
fruit-list          1.0.0               1ad50cd3c6d5        5 seconds ago       109MB
nginx               1.15.8              f09fe80eb0e7        4 years ago         109MB
```

Run a container in detached mode using the newly-created image:

```bash
docker run --name fruit-list -d -p 8080:80 fruit-list:1.0.0
```

Make a request to the container and verify that you receive some JSON data containing a list of fruits:

```bash
curl localhost:8080
```

## Relevant Documentation

- [Docker Image](https://docs.docker.com/engine/reference/commandline/image/)

## Conclusion

Congratulations! You have successfully created your own Docker image and tested it in a real-world scenario. This hands-on lab experience should equip you with the confidence to design and build Docker images according to specific requirements.