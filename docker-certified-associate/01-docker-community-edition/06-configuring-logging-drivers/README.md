# Docker Logging Drivers

## Table of Contents

- [Introduction](#introduction)
- [Tutorial Reference](#tutorial-reference)
- [Relevant Documentation](#relevant-documentation)
- [Conclusion](#conclusion)

## Introduction

The ability to store and access container logs is crucial for effective container management. Docker logging drivers offer a flexible framework to manage and retrieve log data from containers and services within Docker. With Docker, you have a range of logging drivers to choose from, allowing you to select the logging implementation that best suits your needs. In this tutorial, we will explore Docker logging drivers and learn how to configure the default logging driver for the system and override it for individual containers.

## Tutorial Reference

To follow along with the examples and instructions in this tutorial, execute the following commands and configurations:

1. Check the current default logging driver:

```bash
docker info | grep Logging
```

2. Edit the `daemon.json` file to set a new default logging driver configuration:

```bash
sudo vi /etc/docker/daemon.json
```

Add the following configuration to the `daemon.json` file:

```json
{
  "log-driver": "json-file",
  "log-opts": {
    "max-size": "15m"
  }
}
```

3. Restart Docker after editing daemon.json:

```bash
sudo systemctl restart docker
```

4. Run a Docker container, overriding the system default logging driver settings:

```bash
docker run --log-driver json-file --log-opt max-size=50m nginx
```

In the above steps, we covered setting the default logging driver for the system in the `daemon.json` file and overriding it for individual containers using the `--log-driver` and `--log-opt` flags with the `docker run` command.

## Relevant Documentation

For more detailed information about Docker logging drivers and their configuration options, please refer to the [official Docker documentation available](https://docs.docker.com/config/containers/logging/configure/).

## Conclusion

Configuring Docker logging drivers allows you to choose the most suitable logging implementation for your containers. By setting the default logging driver and overriding it for specific containers, you can tailor your logging configuration to meet the specific needs of your application. Docker provides a range of logging drivers, each with its own set of options, enabling you to customize the logging behavior according to your requirements.