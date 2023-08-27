# Securely Configuring Docker Daemon HTTP Socket

Welcome to this guide on how to securely configure the Docker daemon HTTP socket. By the end of this guide, you'll be able to expose the Docker socket securely and interact with Docker remotely.

## Table of Contents

- [Introduction](#introduction)
- [Prerequisites](#prerequisites)
- [Concepts](#concepts)
- [Setting Up the Server Certificates](#setting-up-the-server-certificates)
- [Setting Up Client Certificates](#setting-up-client-certificates)
- [Configuring Docker Host and Client](#configuring-docker-host-and-client)
- [Testing The Configuration](#testing-the-configuration)
- [Conclusion](#conclusion)
- [References](#references)

## Introduction

Docker, by default, is only accessible from the machine where it's running. This is a security feature. However, there might be instances where you'd want to expose the Docker socket externally to interact with it remotely. This guide will show you how to do that securely using mutual client/server certificate authentication.

## Prerequisites

- Two servers with Ubuntu 18.04 Bionic Beaver LTS (micro-sized).
- Docker Community Edition installed on both servers.
- Basic knowledge of OpenSSL and Docker.

## Concepts

**Analogy: The Trusted Locksmith and Visitor's Badge**

In the town, "CertAuthority" is not just known for crafting special locks for homeowners but also for creating unique badges for visitors. This ensures a consistent level of trust and verification throughout the town.

**For Homeowners (Servers)**:

1. Homeowners go to "CertAuthority" to get a special lock for their doors. This lock shows visitors that the house is genuinely theirs and not an imposter's.
2. "CertAuthority" checks the homeowner's credentials, ensures they are who they say they are, and then provides them with a special lock and key. This lock has a unique design that represents the homeowner's identity.

**For Visitors (Clients)**:

1. Visitors, wanting to prove their identity to homeowners, also approach "CertAuthority" but to craft a special badge.
2. The visitor crafts a unique base for their badge at "CertAuthority's" workshop. This base is made of a special material that's unique to each visitor.
3. With the base in hand, the visitor then etches their name and some unique patterns onto it. They submit this design to "CertAuthority" for approval and final crafting.
4. "CertAuthority" takes the visitor's badge design, checks it against their records, and then finalizes the badge by adding some finishing touches and a seal of approval. This badge is now valid for a year.

**Trust in the Town**:

When visitors approach a house, they wear their badge, and homeowners can verify the badge's authenticity using a special viewer provided by "CertAuthority." At the same time, visitors can check the house's lock against a reference book from "CertAuthority" to ensure they're at the right house.

This dual system ensures a two-way trust. Not only can visitors trust they're entering the genuine house (because of the special lock), but homeowners can also trust the identity of their visitors (because of the badge).

---

By having both the client and server obtain their certificates from the same "CertAuthority," the analogy now mirrors the real-world scenario where a single trusted CA can issue both client and server certificates.

## Setting Up the Server Certificates

Generate a certificate authority and server certificates:

```bash
openssl genrsa -aes256 -out ca-key.pem 4096
openssl req -new -x509 -days 365 -key ca-key.pem -sha256 -out ca.pem
openssl genrsa -out server-key.pem 4096
openssl req -subj "/CN=$HOSTNAME" -sha256 -new -key server-key.pem -out server.csr
echo subjectAltName = DNS:$HOSTNAME,IP:<server_private_IP>,IP:127.0.0.1 >> extfile.cnf
echo extendedKeyUsage = serverAuth >> extfile.cnf
openssl x509 -req -days 365 -sha256 -in server.csr -CA ca.pem -CAkey ca-key.pem -CAcreateserial -out server-cert.pem -extfile extfile.cnf
```

Alright, let's break these commands down!

1. **Creating a private key for the Certificate Authority (CA)**:

```bash
openssl genrsa -aes256 -out ca-key.pem 4096
```

- **openssl**: This is the main command line tool for the OpenSSL library.
- **genrsa**: This tells OpenSSL to generate an RSA private key.
- **-aes256**: This is an encryption algorithm. It means the private key you're generating will be encrypted with AES256, and you will need a passphrase to use it.
- **-out ca-key.pem**: This specifies the file where the private key will be saved.
- **4096**: This is the key size in bits. A larger key size is more secure, but slower.

2. **Generating a self-signed root CA certificate**:

```bash
openssl req -new -x509 -days 365 -key ca-key.pem -sha256 -out ca.pem
```

- **req**: This stands for 'request'. It's used to create and process certificate requests.
- **-new**: Create a new request.
- **-x509**: This option tells OpenSSL to create a self-signed certificate instead of a certificate request.
- **-days 365**: The certificate will be valid for 365 days.
- **-key ca-key.pem**: This specifies the private key to use.
- **-sha256**: Use SHA-256 as the signature algorithm.
- **-out ca.pem**: This is the file where the self-signed certificate will be saved.

3. **Generating a private key for the server**:

```bash
openssl genrsa -out server-key.pem 4096
```

- This is the same as the first command but generates a key for the server and doesn't encrypt the key.

4. **Creating a certificate signing request (CSR) for the server**:

```bash
openssl req -subj "/CN=$HOSTNAME" -sha256 -new -key server-key.pem -out server.csr
```

- **-subj "/CN=$HOSTNAME"**: This sets the subject name for the certificate (commonly used for the domain name or hostname of the server).
- **-key server-key.pem**: This specifies the private key for the server.
- **-out server.csr**: This specifies where to save the CSR.

5. **Setting extensions for the server certificate**:

```bash
echo subjectAltName = DNS:$HOSTNAME,IP:<server_private_IP>,IP:127.0.0.1 >> extfile.cnf
echo extendedKeyUsage = serverAuth >> extfile.cnf
```

- These commands append configuration settings to a file called `extfile.cnf`.
- **subjectAltName**: Allows users to specify additional host names for a single SSL certificate. Useful for multi-domain SSL certificates.
- **extendedKeyUsage = serverAuth**: Specifies the certificate's intended use, in this case, for server authentication.

6. **Generating the server certificate signed by the root CA**:

```bash
openssl x509 -req -days 365 -sha256 -in server.csr -CA ca.pem -CAkey ca-key.pem -CAcreateserial -out server-cert.pem -extfile extfile.cnf
```

- **x509**: This manages certificate data in the X.509 format.
- **-req**: This is saying the input is a CSR.
- **-in server.csr**: Specifies the CSR to use.
- **-CA ca.pem**: The root CA certificate.
- **-CAkey ca-key.pem**: The private key of the CA.
- **-CAcreateserial**: This creates a serial number file for the certificate.
- **-out server-cert.pem**: This is where the signed server certificate will be saved.
- **-extfile extfile.cnf**: This uses the previously created configuration file for certificate extensions.

In essence, these commands are about creating a self-signed Certificate Authority (CA) and then using that CA to sign a server certificate. The server certificate can then be used to establish secure (SSL/TLS) communications.

## Setting Up Client Certificates

1. Generate the client certificates:

```bash
openssl genrsa -out key.pem 4096
openssl req -subj '/CN=client' -new -key key.pem -out client.csr
echo extendedKeyUsage = clientAuth > extfile-client.cnf
openssl x509 -req -days 365 -sha256 -in client.csr -CA ca.pem -CAkey ca-key.pem -CAcreateserial -out cert.pem -extfile extfile-client.cnf
```

Alright, let's break these commands down step by step:

1. **openssl genrsa -out key.pem 4096**

- **openssl**: This is a command-line tool for using the various cryptography functions of OpenSSL's crypto library.
- **genrsa**: This command is used to generate an RSA private key.
- **-out key.pem**: This specifies the name of the output file where the private key will be saved. In this case, it's `key.pem`.
- **4096**: This is the size (in bits) of the private key. A 4096-bit key is considered very secure.

**In simple terms**: This command creates a secure private key and saves it to a file named `key.pem`.

2. **openssl req -subj '/CN=client' -new -key key.pem -out client.csr**

- **req**: This command primarily creates and processes certificate requests in OpenSSL.
- **-subj '/CN=client'**: This sets the subject name of the certificate request. `CN` stands for Common Name, and in this case, it's set to `client`.
- **-new**: This indicates that a new certificate request should be created.
- **-key key.pem**: This specifies the private key to use. We're using the `key.pem` we generated in the first command.
- **-out client.csr**: This specifies the name of the output file where the certificate request will be saved. Here, it's `client.csr`.

**In simple terms**: This command creates a new certificate request using the private key from `key.pem` and saves it to a file named `client.csr`.

3. **echo extendedKeyUsage = clientAuth > extfile-client.cnf**

- **echo**: This is a command that outputs the given string.
- **extendedKeyUsage = clientAuth**: This is a configuration setting that specifies the key usage for the certificate. `clientAuth` means the certificate will be used for client authentication.
- **> extfile-client.cnf**: This redirects the output of the `echo` command to a file named `extfile-client.cnf`.

**In simple terms**: This command creates a configuration file named `extfile-client.cnf` and writes the setting for client authentication to it.

4. **openssl x509 -req -days 365 -sha256 -in client.csr -CA ca.pem -CAkey ca-key.pem -CAcreateserial -out cert.pem -extfile extfile-client.cnf**

- **x509**: This command is used for displaying and managing X.509 certificates in OpenSSL.
- **-req**: This indicates that a certificate request is being provided.
- **-days 365**: This specifies the validity of the certificate. Here, it's set to 365 days.
- **-sha256**: This sets the hashing algorithm to SHA-256, which is a secure hashing algorithm.
- **-in client.csr**: This specifies the input certificate request file, which is `client.csr` from our second command.
- **-CA ca.pem**: This specifies the Certificate Authority (CA) certificate.
- **-CAkey ca-key.pem**: This specifies the CA's private key.
- **-CAcreateserial**: This creates a serial number file if one doesn't exist. Serial numbers are unique identifiers for certificates.
- **-out cert.pem**: This specifies the name of the output file where the signed certificate will be saved.
- **-extfile extfile-client.cnf**: This specifies the configuration file we created in the third command.

**In simple terms**: This command takes the certificate request from `client.csr`, signs it using the CA's private key from `ca-key.pem`, and then saves the signed certificate to a file named `cert.pem`.

2. Set appropriate permissions for security:

```bash
chmod -v 0400 ca-key.pem key.pem server-key.pem
chmod -v 0444 ca.pem server-cert.pem cert.pem
```

## Configuring Docker Host and Client

1. Configure Docker host:

```bash
sudo vi /etc/docker/daemon.json
```

Add the following content:

```json
{
"tlsverify": true,
"tlscacert": "/home/cloud_user/ca.pem",
"tlscert": "/home/cloud_user/server-cert.pem",
"tlskey": "/home/cloud_user/server-key.pem"
}
```

2. Update the Docker service file:

```bash
sudo vi /lib/systemd/system/docker.service
```

Modify the `ExecStart` line:

```
ExecStart=/usr/bin/dockerd -H=0.0.0.0:2376 --containerd=/run/containerd/containerd.sock
```

3. Reload the daemon and restart Docker:

```bash
sudo systemctl daemon-reload
sudo systemctl restart docker
```

4. Transfer certificate files to the client:

```bash
scp ca.pem cert.pem key.pem cloud_user@<client private IP>:/home/cloud_user
```

5. On the client machine:

```bash
mkdir -pv ~/.docker
cp -v {ca,cert,key}.pem ~/.docker
export DOCKER_HOST=tcp://<docker server private IP>:2376 DOCKER_TLS_VERIFY=1
```

## Testing The Configuration

Check the Docker version to ensure the remote connection:

```bash
docker version
```

## Relevant Documentation

- [Docker Security Documentation](https://docs.docker.com/engine/security/https/)

## Conclusion

You've now securely set up the Docker daemon HTTP socket to expose it externally. This allows for a secured remote interaction with Docker using client/server certificates. Happy Dockerizing! 🌱