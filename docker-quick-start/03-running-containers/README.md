# Running Containers

Welcome to the Docker QuickStart course! This guide is designed to walk you through the process of running containers effectively. Whether you're a beginner or have been tinkering with Docker for a while, this document aims to clarify the nuances of container operation, from basic runs to more advanced, persistent containers. Let's dive into the world of Docker together, demystifying the process and helping you get the most out of your containerized environments.

## Table of Contents

- [Introduction](#introduction)
- [Creating Persistent Containers](#creating-persistent-containers)
- [The Evolution of Docker Commands](#the-evolution-of-docker-commands)
- [Hands-on Examples](#hands-on-examples)
- [Relevant Documentation](#relevant-documentation)
- [Conclusion](#conclusion)

## Introduction

In this section, we'll cover the basics of running containers. While you might be familiar with running simple images like `hello-world`, we'll explore how to create containers that serve longer-term purposes.

## Creating Persistent Containers

Learn about the ephemeral nature of containers and why, at times, you might need them to last longer. This is especially crucial in development environments where ongoing testing and code validation are needed.

## The Evolution of Docker Commands

### Docker Run vs Docker Container Run

- **docker run**: This is the original command used to create and start a container from a Docker image. It is simple and straightforward, suitable for quick container instantiation. The basic usage is `docker run [OPTIONS] IMAGE [COMMAND] [ARG...]`.
  
- **docker container run**: Introduced as part of Docker's efforts to streamline and clarify its command structure, `docker container run` functions similarly to `docker run`. The main difference lies in its more explicit naming, aligning with Docker's newer command syntax. Use it as `docker container run [OPTIONS] IMAGE [COMMAND] [ARG...]`.

Both commands are valid, but `docker container run` is more in line with Docker's current CLI structure, making it a preferable choice for new projects and documentation.

### Docker Images vs Docker Image ls

- **docker images**: This command lists all Docker images on your system. Type `docker images` to use it.
  
- **docker image ls**: A more recent addition, offering a similar function but aligning with Docker's current command structure. Type `docker image ls` to use it.

Understanding both sets of commands (legacy and new) is crucial for effectively navigating Docker's ecosystem, as both are commonly used across various resources.

## Hands-on Examples

Get practical with real-world examples. We'll run a container from an Ubuntu image, explore the environment, and delve into how it can be used in a testing setup.

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
│     │       apt-get update       │     │      │     │      cp hello-world.py     │     │
│     │                            │     │      │     │                            │     │
│     ├────────────────────────────┤     │      │     ├────────────────────────────┤     │
│     │                            │     │      │     │                            │     │
│     │  Base image: Ubuntu 16:04  │     │      │     │    kientree:getstarted     │     │
│     │                            │     │      │     │                            │     │
└─────┴────────────────────────────┴─────┘      └─────┴────────────────────────────┴─────┘
                                                                                          
          kientree:getstarted                              kientree:hello-world             
                                                                                          
                                                                                          
                                     © Minh Hung Phan                                     
                                   
```

### Running an Ubuntu Container

- **Pulling the Ubuntu Image**: Start by pulling an Ubuntu image using the command `docker pull ubuntu`:

```bash
docker pull ubuntu
```

- **Running the Container**: Use `docker container run -it --name python-container ubuntu bash` to create and enter an interactive container:

```bash
docker container run -it --name python-container ubuntu bash
```

### Exploring the Container Environment

- **Check Linux Version**: Inside the container, run `cat /etc/os-release` to verify the Ubuntu version:

```bash
cat /etc/os-release
```

- **Install Python**: Execute `apt-get update` followed by `apt-get install python3` to install Python in your container:

```bash
apt-get update
apt-get install python3
```

### Creating a Python Script in the Container

- **Installing Vim editor**: Install an editor like Vim with `apt-get install vim`: 

```bash
apt-get install vim
```

**Writing a Script**: Create a Python script using Vim:

```bash
vim hello-world.py
```

Let's say "Hello World!":

```py
print("Hello World!")
```

- **Running the Script**: Run your script with `python3 hello-world.py` to see it in action within the container.

```bash
python3 hello-world.py
```

## Relevant Documentation

- [Docker Official Documentation](https://docs.docker.com/)
- [Running containers](https://docs.docker.com/engine/reference/run/)
- [docker image ls](https://docs.docker.com/engine/reference/commandline/image_ls/)

## Conclusion

Remember, this guide is not just a set of instructions; it's a journey into the world of Docker. By understanding and practicing these steps, you'll be well-equipped to handle your Docker containers effectively. Let's embark on this exciting journey together!
