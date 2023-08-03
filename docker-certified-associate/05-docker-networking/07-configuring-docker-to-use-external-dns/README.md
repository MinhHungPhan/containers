# Configuring Docker to use External DNS

## Table of Contents

- [Introduction](#introduction)
- [Understanding DNS](#understanding-dns)
- [Using Custom DNS with Docker](#using-custom-dns-with-docker)
   - [Configuring Docker Daemon's DNS](#configuring-docker-daemons-dns)
   - [Configuring Individual Containers' DNS](#configuring-individual-containers-dns)
- [Relevant Documentation](#relevant-documentation)
- [Conclusion](#conclusion)

## Introduction

Docker is a widely used technology that allows developers to create, deploy, and run applications inside containers. One vital part of this process is the ability to interact with external resources through Domain Name System (DNS). This guide will introduce you to how DNS works and demonstrate how to customize the DNS settings for Docker as a whole and for individual containers. Whether you need to set up a custom DNS server for the Docker Daemon or a particular container, this guide has you covered.

## Understanding DNS

DNS, or Domain Name System, acts like a phone book for the internet. It translates human-readable hostnames like google.com into IP addresses that computers use to identify each other on the network. When you type google.com into your browser, you're using DNS to find the actual server where the site is hosted.

## Using Custom DNS with Docker

### Configuring Docker Daemon's DNS

Docker containers use DNS to locate external resources. You can customize which DNS Docker uses for all the containers on a host by editing the `/etc/docker/daemon.json` file. Here's how:

1. Open the Docker daemon configuration file in a text editor:

```bash
sudo vi /etc/docker/daemon.json
```

2. Add the following configuration:

```json
{
    "dns": ["8.8.8.8"]
}
```

Here, `8.8.8.8` is the IP address of the Google public DNS. It's a free service provided by Google that you can use as a replacement for your current DNS provider. You can add multiple DNS servers as needed.

Google's DNS server 8.8.8.8 is used for translating domain names into IP addresses, like any other DNS service. It's popular for its speed, reliability, and accessibility and can be used by individuals, developers, and organizations to improve internet connectivity and performance.

3. Restart the Docker daemon to apply the changes:

```bash
sudo systemctl restart docker
```

4. To test the newly configured Docker Daemon's DNS:

```bash
docker run nicolaka/netshoot nslookup google.com
```

In this example, using 8.8.8.8 as a DNS server for your containers means they will query Google's servers to resolve domain names. You can also set up Google's DNS on your computer, router, or any device that connects to the internet, following specific instructions for each operating system or device.

### Configuring Individual Containers' DNS

1. You can override the default DNS settings for a specific container by using the `--dns` flag when running a container. Here's how:

```bash
docker run --dns 8.8.4.4 your_image_name command
```

2. To test a specific container's DNS using the secondary Google DNS (`8.8.4.4`):

```bash
docker run --dns 8.8.4.4 nicolaka/netshoot nslookup google.com
```

## Relevant Documentation

- [Docker Networking and DNS Configuration](https://docs.docker.com/v17.09/engine/userguide/networking/default_network/configure-dns/)
- [Docker Daemon DNS Options](https://docs.docker.com/engine/reference/commandline/dockerd/#daemon-dns-options)
- [Google Public DNS](https://developers.google.com/speed/public-dns)

## Conclusion

Customizing DNS within Docker provides greater control and flexibility in managing network interactions with external resources. This guide has shown you how to set up custom DNS for both the Docker Daemon and individual containers, providing practical examples along the way. Happy Dockering!