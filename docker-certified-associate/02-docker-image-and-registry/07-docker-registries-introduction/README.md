# Docker Registries Introduction

## Table of Contents

1. [Introduction](#introduction)
2. [Tutorial Reference](#tutorial-reference)
3. [Relevant Documentation](#relevant-documentation)
4. [Conclusion](#conclusion)

## Introduction

Welcome to this comprehensive tutorial on Docker registries. Docker registries serve as a centralized hub for storing and distributing Docker images. In this guide, we'll explore what Docker registries are and demonstrate the process of setting up and securing a private Docker registry. This will include enabling authentication and TLS for enhanced security.

## Tutorial Reference

Here are the steps and corresponding commands used in this tutorial:

1. Run a simple registry:

```bash
docker run -d -p 5000:5000 --restart=always --name registry registry:2
```

2. Stop and remove the registry:

```bash
docker container stop registry && docker container rm -v registry
```

3. Override the log level using an environment variable:

```bash
docker run -d -p 5000:5000 --restart=always --name registry -e REGISTRY_LOG_LEVEL=debug registry:2
```

4. Secure the registry by generating an `htpasswd` file to be used for authentication:

```bash
mkdir ~/registry
cd ~/registry
mkdir auth
docker run --entrypoint htpasswd registry:2.7.0 -Bbn testuser password > auth/htpasswd
```

The command runs a Docker container with the `registry:2.7.0` image and uses the `htpasswd` program inside the container to generate an encrypted password. The resulting password is saved in the `auth/htpasswd` file.

5. Generate a self-signed certificate:

```bash
mkdir certs
openssl req \
-newkey rsa:4096 -nodes -sha256 -keyout certs/domain.key \
-x509 -days 365 -out certs/domain.crt
```

When generating the certificate, fill out the relevant details, particularly the common name, which should be the public host name of your server.

Expected output:

```plaintext
Generating a 4096 bit RSA private key
...........++
...........................................................................................................................................................++
writing new private key to 'certs/domain.key'
-----
You are about to be asked to enter information that will be incorporated
into your certificate request.
What you are about to enter is what is called a Distinguished Name or a DN.
There are quite a few fields but you can leave some blank.
For some fields there will be a default value,
If you enter '.', the field will be left blank.
-----
Country Name (2 letter code) [AU]:US
State or Province Name (full name) [Some-State]:California
Locality Name (eg, city) []:San Francisco
Organization Name (eg, company) [Internet Widgits Pty Ltd]:Example Inc
Organizational Unit Name (eg, section) []:
Common Name (e.g. server FQDN or YOUR name) []:example.com
Email Address []:admin@example.com
```

6. Run the secure registry with authentication and TLS enabled:

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
registry:2
```

7. Test the registry:

```bash
curl -k https://localhost:443
```
Now, despite not receiving any output and lacking a body in our response, the request was successful. This indicates that our registry is responsive and fully operational. At this point, everything appears to be functioning smoothly.However, to confirm the complete functionality, we will need to access the registry directly.

## Relevant Documentation

For more details about the commands and steps used in this tutorial, please refer to the following documentation:

- [Deploying a Registry](https://docs.docker.com/registry/deploying/)
- [Registry Configuration](https://docs.docker.com/registry/configuration/)
- [Insecure Registry](https://docs.docker.com/registry/insecure/)

## Conclusion

This concludes our tutorial on Docker registries. By now, you should have an understanding of what Docker registries are and how they function. You should also know how to set up a private Docker registry and secure it with authentication and TLS.
