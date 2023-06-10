# Docker Registry Usage

## Table of Contents

- [Introduction](#introduction)
- [Interacting with Docker Registries](#interacting-with-docker-registries)
- [The Insecure Way: Disabling Certificate Verification](#the-insecure-way-disabling-certificate-verification)
- [The Secure Way: Getting Docker to Trust the Self-Signed Certificate](#the-secure-way-getting-docker-to-trust-the-self-signed-certificate)
- [Pushing to and Pulling from a Private Registry](#pushing-to-and-pulling-from-a-private-registry)
- [Relevant Documentation](#relevant-documentation)
- [Conclusion](#conclusion)

 ## Introduction

Docker Registry is a server-side application that enables you to store and distribute Docker images. Essentially, it's a storage system for Docker images and a great tool for anyone working with Docker containers. This tutorial will guide you on how to interact with Docker registries, pull and search images, authenticate with Docker registries, disable certificate verification, get Docker to trust the self-signed certificate, and finally, push to and pull from a private registry.

## Interacting with Docker Registries

### Pulling and Searching Images

You can pull images from Docker Hub with `docker pull`, like so:

```shell
docker pull ubuntu
```

If you want to search for available images on Docker Hub from the command line, use `docker search`:

```shell
docker search ubuntu
```

Please note, `docker search` works only with Docker Hub, and not with private registries.

### Authenticating with Docker Registries

You may need to authenticate with the registry. This isn't necessary for pulling public images like the ubuntu image from Docker Hub, but it's required when interacting with private registries. To authenticate, use `docker login`:

```shell
docker login <registry public hostname>
```

Input your username and password when prompted. However, this command will fail when used with a private registry that uses a self-signed certificate, displaying a "certificate signed by unknown authority" error. 

```plaintext
$ docker login <registry public hostname>

Error response from daemon: Get https://<registry public hostname>/v2/: x509: certificate signed by unknown authority
```

The reason for the failure is that our registry is using a self-signed certificate. This means that the certificate is not verified by a trusted authority. As a result, our local Docker daemon does not trust the certificate being used by our registry.

There are two methods to address this:

- The insecure way: Disabling certificate verification (Not advisable due to security concerns)
- The secure way: Getting Docker to trust the self-signed certificate

## The Insecure Way: Disabling Certificate Verification

You can disable certificate verification by editing Docker's daemon configuration file, located at `/etc/docker/daemon.json`. Add the `insecure-registries` key, with your registry hostname as its value:

```json
{
    "insecure-registries" : ["<registry public hostname>"]
}
```

Restart Docker:

```shell
sudo systemctl restart docker
```

You should now be able to log in to your private Docker registry.

**Note**: This method is not advisable due to security concerns. It exposes you to potential man-in-the-middle attacks.

## The Secure Way: Getting Docker to Trust the Self-Signed Certificate

First, log out from the Docker registry:

```shell
docker logout <registry public hostname>
```

Next, remove the `insecure-registries` key from `/etc/docker/daemon.json` and restart Docker. 

To properly address the error, provide the public certificate to Docker by copying it to a specific location on your server:

```shell
sudo mkdir -p /etc/docker/certs.d/<registry public hostname>
sudo scp cloud_user@<registry public hostname>:/home/cloud_user/registry/certs/domain.crt /etc/docker/certs.d/<registry public hostname>
```

You can now successfully authenticate with your private Docker registry without getting a certificate error:

```shell
docker login <registry public hostname>
```

## Pushing to and Pulling from a Private Registry

Once you've configured Docker to use your private registry, you can push images to it with `docker push`:

```shell
docker pull ubuntu
docker tag ubuntu <registry public hostname>/ubuntu
docker push <registry public hostname>/ubuntu
```

To successfully pull an image from the private registry, we need to ensure that the local copy of the image is removed. If the image exists locally, Docker won't pull it from the private registry because it already has a local version.

To remove the local copy of the image, execute the `docker image rm` command followed by the image tag, which in this case is the host name and the image name combined (hostname/ubuntu). 

```shell
docker image rm <registry public hostname>/ubuntu
```

Note that the above command only removes the tag and not the underlying image. To remove the image itself, you need to run `docker image rm` again with just the image name:

```shell
docker image rm ubuntu
```

Now the original Docker Hub image has been deleted. You can verify this as the command will delete the entire image.

With the local image removed, you can now pull the image from your private registry using the `docker pull` command, again followed by the host name and the image name:

```shell
docker pull <registry public hostname>/ubuntu
```

This will pull the image from the private registry, as the local version no longer exists.

## Relevant Documentation

- Docker's guide on [how to set up a private Docker registry](https://docs.docker.com/registry/deploying/).
- Docker's guide on [docker login](https://docs.docker.com/engine/reference/commandline/login/).
- Docker's guide on [docker pull](https://docs.docker.com/engine/reference/commandline/pull/).
- Docker's guide on [docker push](https://docs.docker.com/engine/reference/commandline/push/).

## Conclusion

Docker Registry is like a big library for computer pictures called Docker images. You can store and manage them in one place and decide who can see them. You can also share your pictures with other people or keep them private just for your own group. Understanding how to use it effectively can lead to a smoother development and deployment process. The tutorial covered various essential aspects of Docker Registry usage, from interaction to authentication, dealing with certificates, and performing actions with a private registry.