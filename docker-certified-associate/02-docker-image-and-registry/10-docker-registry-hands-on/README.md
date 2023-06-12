# Building a Private Docker Registry

Docker registries are vital for managing and distributing Docker images. Although Docker offers a free registry, Docker Hub, there may be times when you desire a more controlled environment for your images. Docker Hub doesn't offer free access to more than one private repository. Thankfully, building and managing your private registries is possible, providing complete control over your image storage and accessibility.

In this lab, you'll have the chance to construct a secure private registry. You'll know how to set up a secure, yet simple, private Docker registry once you complete the lab.

## Table of Contents

- [Introduction](#introduction)
- [Additional Resources](#additional-resources)
- [Solution](#solution)
  - [Set up the Private Registry on the Docker registry server](#set-up-the-private-registry-on-the-docker-registry-server)
  - [Test the Registry from the Docker Workstation Server](#test-the-registry-from-the-docker-workstation-server)
- [Conclusion](#conclusion)

## Introduction

The guide is divided into sections, each dealing with a different aspect of the setup process, and provides additional resources and solutions. It is designed to be easy to follow, whether you're an experienced DevOps professional or just starting with Docker. 

Let's get started on this exciting journey!

## Additional Resources

You've been tasked with constructing a secure, private Docker registry for your company, which has recently decided to use Docker for production containers. They've created Docker images for their proprietary software and need a secure location for storing and managing these images. Additionally, you're asked to set up a Docker workstation server to validate everything works as expected.

To complete this lab, ensure you meet the following registry requirements:

- Running a private Docker registry on the Docker registry server using version 2.7 of the registry image.
- The container name for the registry should be `registry`.
- The registry should restart automatically if it stops, or if the Docker daemon or server restarts.
- The registry should require authentication. Set up an initial account with the username `docker` and the password `kientree123`.
- The registry should use TLS with a self-signed certificate.
- The registry should listen on port 443.

Ensure the Docker workstation server fulfills the following requirements:

- Docker is logged in to the private registry.
- Docker is configured to accept the self-signed cert. Avoid turning off certificate verification using the `insecure-registries` setting.

To validate everything works correctly, push a test image named `ip-10-0-1-101:443/test-image:1` to the private registry. You can pull any image from Docker hub and tag it with `ip-10-0-1-101:443/test-image:1` as a test. Subsequently, delete the test image locally and pull it from the registry.

## Solution

Begin by logging in to the lab servers using the credentials provided on the hands-on lab page:

`ssh cloud_user@PUBLIC_IP_ADDRESS`

We recommend logging in to both servers at the same tab in separate tabs of your terminal application.

### Set up the Private Registry on the Docker registry server

1. In the Registry server, create an `htpasswd` file containing the login credentials for the initial account:

```bash
mkdir -p ~/registry/auth
docker run --entrypoint htpasswd \
  registry:2.7.0 -Bbn docker kientree123 > ~/registry/auth/htpasswd
```

2. Create a directory to hold the certificates for the registry server:

```bash
mkdir -p ~/registry/certs
```

3. Create a self-signed certificate for the registry:

```bash
openssl req \
  -newkey rsa:4096 -nodes -sha256 -keyout ~/registry/certs/domain.key \
  -x509 -days 365 -out ~/registry/certs/domain.crt
```

**NOTE**: For the Common Name field, enter the hostname of the registry server (`ip-10-0-1-101`). For the other prompts, hit enter to accept the default value.

4. Create a container to run the registry:

```bash
docker run -d -p 443:443 --restart=always --name registry \
  -v /home/cloud_user/registry/certs:/certs \
  -v /home/cloud_user/registry/auth:/auth \
  -e REGISTRY_HTTP_ADDR=0.0.0.0:443 \
  -e REGISTRY_HTTP_TLS_CERTIFICATE=/certs/domain.crt \
  -e REGISTRY_HTTP_TLS_KEY=/certs/domain.key \
  -e REGISTRY_AUTH=htpasswd \
  -e "REGISTRY_AUTH_HTPASSWD_REALM=Registry Realm" \
  -e REGISTRY_AUTH_HTPASSWD_PATH=/auth/htpasswd \
  registry:2.7.0
```

5. Verify whether Docker registry is up and running:

```bash
docker ps
```

Expected output:

```plaintext
CONTAINER ID        IMAGE               COMMAND                  CREATED             STATUS              PORTS                            NAMES
faab9313e3f9        registry:2.7.0      "/entrypoint.sh /etc…"   19 seconds ago      Up 17 seconds       0.0.0.0:443->443/tcp, 5000/tcp   registry
```

6. Once the registry starts up, verify that it is responsive:

```bash
curl -k https://localhost:443
```

It's OK if this command returns nothing, just make sure it does not fail.

### Test the Registry from the Docker Workstation Server

1. Get the public hostname from the registry server. It should be `ip-10-0-1-101`.

```bash
echo $HOSTNAME
```

2. On the Workstation server, add the registry's public self-signed certificate to `/etc/docker/certs.d`. The `scp` command is copying the file from the registry server to the workstation. The password is the normal `cloud_user` password provided by the lab.

**Note**: The following steps should be completed from the Workstation server.

```bash
sudo mkdir -p /etc/docker/certs.d/ip-10-0-1-101:443
sudo scp cloud_user@ip-10-0-1-101:/home/cloud_user/registry/certs/domain.crt /etc/docker/certs.d/ip-10-0-1-101:443
```

3. Log in to the private registry from the workstation. The credentials should be username `docker` and password `kientree123`.

```bash
docker login ip-10-0-1-101:443
```

Expected output:

```plaintext
WARNING! Your password will be stored unencrypted in /home/cloud_user/.docker/config.json.
Configure a credential helper to remove this warning. See
https://docs.docker.com/engine/reference/commandline/login/#credentials-store

Login Succeeded
```

4. Test the registry by pushing an image to it. You can pull any image from Docker hub and tag it appropriately to push it to the registry as a test image.

```bash
docker pull ubuntu
docker tag ubuntu ip-10-0-1-101:443/test-image:1
docker push ip-10-0-1-101:443/test-image:1
```

5. Verify image pulling by deleting the image locally and re-pulling it from the private repository.

```bash
docker image rm ip-10-0-1-101:443/test-image:1
docker image rm ubuntu:latest
docker pull ip-10-0-1-101:443/test-image:1
```

## Conclusion

Congratulations — you've completed this hands-on lab!
