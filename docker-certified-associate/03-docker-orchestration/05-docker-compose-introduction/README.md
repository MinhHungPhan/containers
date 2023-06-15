# Docker Compose Introduction

Docker Compose is a powerful tool that allows us to manage and run multi-container applications using Docker. These aren't just multiple containers running the same image, but multiple containers running different images, all interacting together to form a larger application.

## Table of Contents

- [Introduction](#introduction)
- [Multi-Container Applications](#multi-container-applications)
- [Installation of Docker Compose](#installation-of-docker-compose)
- [Creating a Docker Compose Project](#creating-a-docker-compose-project)
- [Running and Managing the Application](#running-and-managing-the-application)
- [Relevant Documentation](#relevant-documentation)
- [Conclusion](#conclusion)

## Introduction

Docker Compose provides a mechanism to define and manage multi-container applications using a declarative format. It is an essential tool to handle complex applications composed of multiple interdependent containers.

```plaintext
                                      docker-compose                                   
                        +-----------------------------------------+                    
                        |                                         |                    
                        |    +-----------+       +-----------+    |                    
                        |    | Port:8080 |       | Password  |    |                    
                        |    +-----------+       +-----------+    |          +--------+
                        |                                         |          |        |
                        |    +-----------+       +-----------+    |          |        |
                        |    |  Web App  |       |  Database |    +--------->|YML file|
                        |    |           |       |           |    |          |        |
                        |    |           |       |           |    |          |        |
                        |    |           |       |           |    |          +--------+
                        |    |   nginx   |       |   mysql   |    |                    
                        |    +-----------+       +-----------+    |                    
                        |                                         |                    
                        +-----------------------------------------+                    

                                    © Minh Hung Phan
```

## Multi-Container Applications

Multi-container applications are more complex than running multiple replicas of the same image. They involve multiple containers, each running a different image, cooperating to form a larger application. Docker Compose enables the definition and management of such applications as a single unit. However, it is worth noting that the Docker Certified Associate primarily covers Docker Compose in relation to stacks in Docker Swarm.

## Installation of Docker Compose

Installation of Docker Compose involves downloading the Docker Compose binary to a server that already has Docker installed. We can then make the binary executable and confirm that the installation worked by checking the version of Docker Compose.

```bash
sudo curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
docker-compose --version
```

## Creating a Docker Compose Project

After Docker Compose has been installed, we can create a Docker Compose project by defining our application in a `docker-compose.yml` file. This file is at the core of Docker Compose, as it declaratively outlines the multi-container application that we wish to run.

```yml
version: '3'
services:
  web:
    image: nginx
    ports:
      - '8080:80'
  database:
    image: redis:alpine
```

In this example, we have a simple two-container application, with one container running an Nginx server and another running Redis as a backend.

## Running and Managing the Application

Once we have defined our application in a `docker-compose.yml` file, we can easily create and run it using Docker Compose with the command:

```bash
docker-compose up -d 
```

We can see which containers are running as part of our application with the command:

```bash
docker-compose ps
```

When it's time to terminate the application and clear out the containers, the following command will do the job:

```bash
docker-compose down.
```

## Relevant Documentation

- [Docker Compose Documentation](https://docs.docker.com/compose/)
- [Docker Compose GitHub](https://github.com/docker/compose)

## Conclusion

Docker Compose provides a simplified way to define and manage multi-container applications. It makes handling complex applications more straightforward by allowing us to start and stop everything defined within a YAML file as a unit. Docker Compose is a critical tool in container orchestration, and understanding its basics will help when dealing with multi-container applications.
