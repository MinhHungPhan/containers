# Setting up Docker Trusted Registry (DTR) with Mirantis Launchpad

In this guide, we'll walk you through the installation and configuration of Docker Trusted Registry (DTR) using Mirantis Launchpad. We'll cover the creation of self-signed certificates and ensure that the DTR interface can be accessed securely.

## Table of Contents

- [Introduction](#introduction)
- [Prerequisites](#prerequisites)
- [Generate Certificates](#generate-certificates)
- [Configuring DTR](#configuring-dtr)
- [Accessing DTR](#accessing-dtr)
- [Relevant Documentation](#relevant-documentation)
- [Conclusion](#conclusion)

## Introduction

Docker Trusted Registry (DTR) is a crucial component for securely storing and managing Docker images. Setting it up correctly is vital for seamless integration with the Docker environment.

## Prerequisites

- Familiarity with Docker Universal Control Plane (UCP)
- Mirantis Launchpad installed and properly configured
- `cluster.yaml` file (created during the initial cluster setup)

## Generate Certificates

To ensure secure communication with DTR, we need to generate appropriate certificates:

1. **Log in** to the UCP manager server.

2. **Create a Certificate Authority (CA)**:

```bash
openssl genrsa -out ca.key 4096
openssl req -x509 -new -nodes -key ca.key -sha256 -days 1024 -subj "/OU=dtr/CN=DTR CA" -out ca.crt
```

3. **Generate the DTR Key and Certificate Signing Request**:

```bash
openssl genrsa -out dtr.key 2048
openssl req -new -sha256 -key dtr.key -subj "/OU=dtr/CN=system:dtr" -out dtr.csr
```

4. **Configure Certificate Extension Data**. 

Create a file named `extfile.cnf` and add the following content:

```bash
keyUsage = critical, digitalSignature, keyEncipherment
basicConstraints = critical, CA:FALSE
extendedKeyUsage = serverAuth, clientAuth
subjectAltName = DNS:<DTR_server_hostname>,IP:<DTR_server_private_IP>,IP:127.0.0.1
```

5. **Generate the Public Certificate**:

```bash
openssl x509 -req -in dtr.csr -CA ca.crt -CAkey ca.key -CAcreateserial -out dtr.crt -days 365 -sha256 -extfile extfile.cnf
```

6. **Change the owner of dtr.crt to cloud_user**:

```bash
ls -l
sudo chown cloud_user:cloud_user dtr.crt
```

## Configuring DTR

1. **Edit `cluster.yaml`**:

Ensure you've added the DTR section, including the respective certificate contents:

```yaml
# ... existing code ...
  dtr:
    version: 2.8.2
    installFlags:
      - --ucp-insecure-tls
      - |- 
        --dtr-cert "<contents of dtr.crt>"
      - |- 
        --dtr-key "<contents of dtr.key>"
      - |- 
        --dtr-ca "<contents of ca.crt>"
  hosts:
# ... existing code ...
    - address: <DTR_server_private_IP>
      privateInterface: ens5
      role: dtr
      ssh:
        user: cloud_user
        keyPath: ~/.ssh/id_rsa
```

2. **Apply Cluster Configuration**:

Run the following command to apply the changes:

```bash
./launchpad apply
```

## Accessing DTR

1. Open a browser and navigate to: `https://<DTR_PUBLIC_IP>`.
   
2. Use your UCP admin credentials for authentication.

3. If prompted for a license, select "Skip for now".

## Relevant Documentation

- [Docker Trusted Registry](https://docs.mirantis.com/containers/v2.1/dockeree-products/dtr.html#)
- [Install Docker Trusted Registry](https://docs.mirantis.com/containers/v2.1/dockeree-products/dtr/dtr-admin/dtr-install.html)
- [Mirantis Launchpad](https://docs.mirantis.com/mke/3.4/launchpad.html)

## Conclusion

Congratulations! You've successfully set up Docker Trusted Registry using Mirantis Launchpad. By following this guide, you've laid the foundation for secure image storage and management using DTR.