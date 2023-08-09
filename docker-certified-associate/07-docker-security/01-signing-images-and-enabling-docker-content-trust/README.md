# Docker Content Trust: Signing and Running Docker Images

## Table of Contents

- [Introduction](#introduction)
- [What is Docker Content Trust?](#what-is-docker-content-trust)
- [Prerequisites](#prerequisites)
- [Enabling Docker Content Trust](#enabling-docker-content-trust)
- [Signing a Docker Image](#signing-a-docker-image)
- [Hands-On](#hands-on)
    - [Building Signed and Unsigned Docker Images](#building-signed-and-unsigned-docker-images)
    - [Running Signed and Unsigned Docker Images](#running-signed-and-unsigned-docker-images)
- [Relevant Documentation](#relevant-documentation)
- [Conclusion](#conclusion)

## Introduction

Welcome to a comprehensive lesson on Docker Content Trust (DCT). This guide is designed to offer a deep dive into the importance of software signing and how it's implemented in the Docker ecosystem. We will cover everything from the concept behind Docker Content Trust, signing Docker images, to running signed images.

## What is Docker Content Trust?

In the realm of software security, it's paramount to ensure that software running on systems remains untampered from its source. This trust is often enforced through software signing mechanisms. Docker Content Trust is Docker's way of implementing this. It provides a mechanism to sign container images, ensuring their integrity from the creator to the end-user. 

## Prerequisites

- A Docker Hub account is essential to follow this lesson. If you don't have an account, sign up for free at [Docker Hub](https://hub.docker.com).

## Enabling Docker Content Trust

Enabling Docker Content Trust is as simple as setting an environment variable:

```bash
export DOCKER_CONTENT_TRUST=1
```

## Signing a Docker Image

1. **Login to Docker Hub**: 

```bash
docker login
```

2. **Generate a delegation key pair**: Navigate to your home directory and generate a key pair.

```bash
cd ~/
docker trust key generate [YOUR_DOCKER_HUB_USERNAME]
```

3. **Add signer**: Add yourself as a signer to an image repository.

```bash
docker trust signer add --key [YOUR_DOCKER_HUB_USERNAME].pub [YOUR_DOCKER_HUB_USERNAME] [YOUR_DOCKER_HUB_USERNAME]/dct-test
```

## Hands-On

We'll start by creating a simple Docker image:

```bash
mkdir ~/dct-test
cd dct-test
vi dockerfile
```

In the `Dockerfile`, add the following content:

```Dockerfile
FROM busybox:latest

CMD echo It worked!
```

### Building Signed and Unsigned Docker Images

#### Unsigned Image

1. **Build an unsigned Docker Image**:

```bash
docker build -t [YOUR_DOCKER_HUB_USERNAME]/dct-test:unsigned .
```

2. **Push the unsigned Docer Image to Docker Hub**:

```bash
docker push [YOUR_DOCKER_HUB_USERNAME]/dct-test:unsigned .
```

#### Signed Image

1. **Build an signed Docker Image**:

```bash
docker build -t [YOUR_DOCKER_HUB_USERNAME]/dct-test:signed .
docker trust sign [YOUR_DOCKER_HUB_USERNAME]/dct-test:signed
```

2. **Push the unsigned Docer Image to Docker Hub**:

```bash
docker push [YOUR_DOCKER_HUB_USERNAME]/dct-test:signed .
```

### Running Signed and Unsigned Docker Images

1. **Run Unsigned Image**: To verify if the unsigned image can run:

```bash
docker run [YOUR_DOCKER_HUB_USERNAME]/dct-test:unsigned
```

2. **Enable Docker Content Trust**:

```bash
export DOCKER_CONTENT_TRUST=1
```

3. **Run Signed Image with DCT Enabled**:

```bash
docker run [YOUR_DOCKER_HUB_USERNAME]/dct-test:unsigned
```

Expected output:

```plaintext
docker: No valid trust data for unsigned.
See 'docker run --help'.
```

Once Docker Content Trust is enabled, if you attempt to run an unsigned image, it will fail.

4. **Run Signed Image with DCT Enabled**:

```bash
docker run [YOUR_DOCKER_HUB_USERNAME]/dct-test:signed
```

3. **Disable Docker Content Trust**:

```bash
export DOCKER_CONTENT_TRUST=0
```

You can now run both signed and unsigned images on your host.

## Relevant Documentation

- [Docker Content Trust Documentation](https://docs.docker.com/engine/security/trust/content_trust/#push-trusted-content)

## Conclusion

Software signing stands as a pillar of security, instilling confidence in users about the software's integrity. Docker Content Trust offers a seamless experience for Docker users, ensuring that the containers they deploy are as the creators intended them to be. Happy Dockering!