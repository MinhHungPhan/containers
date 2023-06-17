# Docker Stacks Introduction

Welcome to this tutorial on Docker stacks. In this tutorial, we will explore Docker stacks and learn how they can be used to manage complex, multi-container applications in a Docker swarm cluster. We will cover the basics of creating and deploying stacks, managing stack services, scaling services, and more.

## Table of Contents

- [Introduction](#introduction)
- [Docker Compose vs Docker Stack](#docker-compose-vs-docker-stack)
- [Creating a Stack](#creating-a-stack)
- [Deploying and Managing Stacks](#deploying-and-managing-stacks)
- [Using Environment Variables](#using-environment-variables)
- [Publishing Ports](#publishing-ports)
- [Service Communication](#service-communication)
- [Scaling Services](#scaling-services)
- [Removing Stacks](#removing-stacks)
- [Relevant Documentation](#relevant-documentation)
- [Conclusion](#conclusion)

## Introduction

Docker Swarm's orchestration functionality really shines when using stacks. Stacks allow you to easily manage complex, multi-container applications and orchestrate them within your swarm cluster.

```plaintext
                                                          task          container                                   
                                                           |                |                                       
+----------------------------------------------------------+----------------+------------+                          
|Docker Swarm Cluster                                +-----+----------------+----------+ |                          
|                                                    | +---+---+  +---------+--------+ | |                          
|                                                    | |       |  |││││││││││││││││││| | |                          
|                                        +---------->| |nginx1 |  |│││nginx:latest│││| | |                          
|                                        |           | |       |  |││││││││││││││││││| | |                          
|           service                      |           | +-------+  +------------------+ | |                          
|              |                         |           +---------------------------------+ |                          
| +------------+--------------+          |                                               |                          
| |            |              |          |           +---------------------------------+ |                          
| |            |              |          |           | +-------+  +------------------+ | |                          
| |  +---------+-----------+  +----------+           | |       |  |││││││││││││││││││| | |                          
| |  |  3 nginx replicas   |  +--------------------->| |nginx2 |  |│││nginx:latest│││| | |                          
| |  +---------------------+  +----------+           | |       |  |││││││││││││││││││| | |                          
| |                           |          |           | +-------+  +------------------+ | |                          
| |       Swarm Manager       |          |           +---------------------------------+ |                          
| +---------------------------+          |                                               |                          
|                                        |           +---------------------------------+ |                          
|                                        |           | +-------+  +------------------+ | |       +-----------------+
|                                        |           | |       |  |││││││││││││││││││| | |       |version: '3'     |
|                                        +---------->| |nginx3 |  |│││nginx:latest│││| | |       |                 |
|                                                    | |       |  |││││││││││││││││││| | |       |services:        |
|                                                    | +-------+  +------------------+ | |       |  nginx:         |
|                                                    +---------------------------------+ |       |    image: nginx |
|                                                                                        |------>|    replicas: 3  |
|                                                    +---------------------------------+ |       |                 |
|                                                    | +-------+  +------------------+ | |       |  redis:         |
|                                                    | |       |  |││││││││││││││││││| | |       |    image: redis |
|                                        +---------->| |redis1 |  |│││redis:latest│││| | |       |    replicas: 3  |
|                                        |           | |       |  |││││││││││││││││││| | |       +-----------------+
|           service                      |           | +-------+  +------------------+ | |       |simple-stack.yml |
|              |                         |           +---------------------------------+ |       +-----------------+
| +------------+--------------+          |                                               |                          
| |            |              |          |           +---------------------------------+ |                          
| |            |              |          |           | +-------+  +------------------+ | |                          
| |  +---------+-----------+  +----------+           | |       |  |││││││││││││││││││| | |                          
| |  |  3 redis replicas   |  +--------------------->| |redis2 |  |│││redis:latest│││| | |                          
| |  +---------------------+  +----------+           | |       |  |││││││││││││││││││| | |                          
| |                           |          |           | +-------+  +------------------+ | |                          
| |       Swarm Manager       |          |           +---------------------------------+ |                          
| +---------------------------+          |                                               |                          
|                                        |           +---------------------------------+ |                          
|                                        |           | +-------+  +------------------+ | |                          
|                                        |           | |       |  |││││││││││││││││││| | |                          
|                                        +---------->| |redis3 |  |│││redis:latest│││| | |                          
|                                                    | |       |  |││││││││││││││││││| | |                          
|                                                    | +-------+  +------------------+ | |                          
|                                                    +---------------------------------+ |                          
+----------------------------------------------------------------------------------------+                                                 
                                        © Minh Hung Phan
```

## Docker Compose vs Docker Stack

The main difference between Docker Compose and Docker Stack lies in their scope and purpose:

1. Scope:
   - **Docker Compose**: Docker Compose is used for defining and running multi-container applications on a single Docker host. It allows you to define the services, networks, and volumes required for your application within a single compose file.
   - Docker Stack: Docker Stack is used for deploying and managing multi-container applications across multiple Docker Swarm nodes. It enables you to define and deploy a complete stack of services, including networks, volumes, and other configurations, within a stack file.

2. Orchestration:
   - **Docker Compose**: Docker Compose provides basic orchestration capabilities for multi-container applications on a single host. It allows you to define the relationships between services, control their startup order, and manage their configuration.
   - **Docker Stack**: Docker Stack is built on top of Docker Swarm and provides advanced orchestration capabilities for deploying and managing multi-container applications in a clustered environment. It enables you to scale services, handle rolling updates, manage secrets, and utilize swarm features such as service discovery and load balancing.

3. Swarm Mode Features:
   - **Docker Compose**: Docker Compose does not have direct integration with Docker Swarm features like service scaling, health checks, secrets management, etc. These features are specific to Docker Swarm and can't be fully utilized within Docker Compose.
   - **Docker Stack**: Docker Stack fully leverages the capabilities of Docker Swarm. It allows you to deploy and manage services as scalable replicas, perform rolling updates, configure service health checks, manage secrets, utilize overlay networks for service communication, and benefit from other Swarm-specific features.

In summary, Docker Compose is suitable for developing and testing applications on a single Docker host, while Docker Stack is designed for deploying and managing multi-container applications across a Docker Swarm cluster, providing advanced orchestration and scalability features.

## Creating a Stack

Let's start with the creation of a basic Docker stack. The first step is to create a .yml file which will contain the necessary configuration for our stack.

In the `simple-stack.yml` file below, we define two services: a web service running the nginx image, and a busybox service running the `radial/busyboxplus:curl` image:

```yml
version: '3'
services:
  web:
    image: nginx
  busybox:
    image: radial/busyboxplus:curl
    command: /bin/sh -c "while true; do echo Hello!; sleep 10; done"
```

## Deploying and Managing Stacks

To deploy our stack, we can use the `docker stack deploy` command and provide the compose file (`simple-stack.yml`) along with a name for the stack (e.g., `simple`). Once deployed, we can use various commands to manage the stack:

- `docker stack ls` lists the existing stacks in the cluster.
- `docker stack ps <stack-name>` shows the individual tasks within a stack.
- `docker stack services <stack-name>` lists the services in a stack.
- `docker service logs <service-name>` displays the logs of a specific service.

Let's deploy the stack and examine it using these Docker commands:

```bash
docker stack deploy -c simple-stack.yml simple
docker stack ls
docker stack ps simple
docker stack services simple
docker service logs simple_busybox
```

## Using Environment Variables

Environment variables can be easily defined within a Docker stack using the compose file. By adding the `environment` key under a service, we can specify the environment variables and their values. These variables can be accessed within the containers of the stack. To demonstrate this, we modify the command of the `busybox` service to echo the value of the `MESSAGE` environment variable.

Let's modify our stack to use an environment variable:

```yml
version: '3'
services:
  web:
    image: nginx
  busybox:
    image: radial/busyboxplus:curl
    command: /bin/sh -c "while true; do echo $$MESSAGE; sleep 10; done"
    environment:
      - MESSAGE=Hello!
```

Deploy the updated stack and check the logs:

```bash
docker stack deploy -c simple-stack.yml simple
docker service logs simple_busybox
```

## Publishing Ports

To expose a port for a service within a stack, we can add the `ports` key under the service and specify the port mapping. 

In our example, we publish port 8080 on the host, mapping it to port 80 of the web service:

```yml
version: '3'
services:
  web:
    image: nginx
    ports:
      - "8080:80"
  busybox:
    image: radial/busyboxplus:curl
    command: /bin/sh -c "while true; do echo $$MESSAGE; sleep 10; done"
    environment:
      - MESSAGE=Hello!
```

Deploy the updated stack and use `curl` to test it:

```bash
docker stack deploy -c simple-stack.yml simple
curl localhost:8080
```

## Service Communication

In a Docker stack, services can communicate with each other through a virtual network associated with the stack. To demonstrate this, we modify the command of the `busybox` service to include a curl request to the `web` service. We can reference the `web` service using its name and the appropriate port (80).


```yml
version: '3'
services:
  web:
    image: nginx
    ports:
      - "8080:80"
  busybox:
    image: radial/busyboxplus:curl
    command: /bin/sh -c "while true; do echo $$MESSAGE; curl web:80; sleep 10; done"
    environment:
      - MESSAGE=Hello!
```

Deploy the updated stack and check the logs:

```bash
docker stack deploy -c simple-stack.yml simple
docker service logs simple_busybox
```

## Scaling Services

Docker stacks allow us to easily scale services. We can define the number of replicas for a service using the `deploy.replicas` key within the compose file. To scale our `web` service to three replicas, we add the following to the `web` service configuration: `deploy.replicas: 3`.

```yml
version: '3'
services:
  web:
    image: nginx
    ports:
      - "8080:80"
    deploy:
      replicas: 3
  busybox:
    image: radial/busyboxplus:curl
    command: /bin/sh -c "while true; do echo $$MESSAGE; curl web:80; sleep 10; done"
    environment:
      - MESSAGE=Hello!
```

Deploy the updated stack and and verify the changes:

```bash
docker stack deploy -c simple-stack.yml simple
docker stack ps simple
```

After running these commands, you will observe multiple web tasks running as part of the stack.

## Removing Stacks

When a stack is no longer needed, it can be easily removed using the `docker stack rm` command followed by the stack name. This command removes all the services, networks, and tasks associated with the stack.

```bash
docker stack rm simple
```

## Relevant Documentation

- [Docker Stacks and Compose files](https://docs.docker.com/compose/compose-file/)
- [Deploy services to a swarm](https://docs.docker.com/engine/swarm/stack-deploy/)
- [Docker Swarm overview](https://docs.docker.com/engine/swarm/)

## Conclusion

In this tutorial, we have covered the basics of Docker stacks and their usage in managing complex, multi-container applications within a Docker swarm cluster. We have explored creating compose files for stacks, deploying and managing stacks, using environment variables, publishing ports, enabling service communication, scaling services, and removing stacks. Docker stacks provide a powerful toolset for orchestrating and managing containerized applications. To learn more about Docker stacks and their capabilities, refer to the official documentation. Happy stacking!