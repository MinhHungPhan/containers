# Configuring Backups for Docker UCP and DTR

## Table of Contents

- [Introduction](#introduction)
- [Prerequisites](#prerequisites)
- [Backing Up Docker Swarm](#backing-up-docker-swarm)
- [Backing Up UCP](#backing-up-ucp)
- [Backing Up DTR](#backing-up-dtr)
- [Relevant Documentation](#relevant-documentation)
- [Conclusion](#conclusion)

## Introduction

Welcome to the guide on configuring backups for Docker Universal Control Plane (UCP) and Docker Trusted Registry (DTR). Regular backups are a critical part of maintaining a robust and resilient production environment. In case of hardware failure or data corruption, backups ensure that you can restore your Docker infrastructure to a working state with minimal downtime.

This document will outline the steps necessary to back up your UCP and DTR data securely. We will cover how to back up Docker Swarm as a prerequisite, followed by specific instructions for UCP and DTR backup procedures.

## Prerequisites

Before proceeding with the backup processes, ensure that you have:

- Administrative access to the UCP manager node and the DTR node.
- Docker Swarm running within your infrastructure.
- Familiarity with command-line operations on the platform hosting your Docker instances.

## Backing Up Docker Swarm

Although this guide will not cover the specifics of backing up a Docker Swarm, it's important to note that it should be the first step in your backup strategy. Backing up Docker Swarm is the same for Docker Community Edition and Docker Enterprise. You can follow Docker’s official documentation for guidance on this process.

## Backing Up UCP

To back up UCP data, follow these steps:

1. **Log into the UCP manager server** where Docker UCP is running.

2. **Run the backup command** using Docker to create a UCP backup file:

```sh
sudo docker container run \
--rm \
--log-driver none \
--name ucp \
--volume /var/run/docker.sock:/var/run/docker.sock \
--volume /tmp:/backup \
mirantis/ucp:3.3.2 backup \
--file ucp_backup.tar \
--passphrase "mysecretphrase" \
--include-logs=false
```

3. **Verify the backup** to ensure it contains the correct data:

```sh
gpg --decrypt /tmp/ucp_backup.tar | tar --list
```

## Backing Up DTR

The backup process for DTR is two-fold: backing up the images and the metadata. Here's how to accomplish each:

1. **Log into the DTR server.**

2. **Obtain the DTR replica ID** and store it in a variable:

```sh
REPLICA_ID=$(sudo docker ps --format '{{.Names}}' -f name=dtr-rethink | cut -f 3 -d '-') && echo $REPLICA_ID
```

3. **Back up the registry images** by creating a TAR file from the DTR container's volume:

```sh
sudo tar -cvf dtr-backup-images.tar /var/lib/docker/volumes/dtr-registry-$REPLICA_ID
```

4. **Verify the contents** of the image backup file:

```sh
tar -tf dtr-backup-images.tar
```

5. **Set up the necessary environment variables** for the metadata backup, replacing `<UCP Manager Private IP>` with the actual IP address of your UCP manager:

```sh
UCP_PRIVATE_IP=<UCP Manager Private IP>
```

6. **Back up the DTR metadata** using Docker commands with the relevant information:

```sh
read -sp 'ucp password: ' UCP_PASSWORD; \
sudo docker run --log-driver none -i --rm \
--env UCP_PASSWORD=$UCP_PASSWORD \
mirantis/dtr:2.8.2 backup \
--ucp-url https://$UCP_PRIVATE_IP \
--ucp-insecure-tls \
--ucp-username admin \
--existing-replica-id $REPLICA_ID > dtr-backup-metadata.tar
```

7. **Confirm the backup** by listing the TAR file contents:

```sh
tar -tf dtr-backup-metadata.tar
```

## Relevant Documentation

- [Docker Swarm Backup](https://docs.docker.com/engine/swarm/admin_guide/#back-up-the-swarm)
- [Mirantis UCP Backup Documentation](https://docs.mirantis.com/containers/v2.1/dockeree-products/ucp/admin/disaster-recovery/backup-swarm.html)
- [Mirantis DTR Backup Documentation](https://docs.mirantis.com/containers/v2.1/dockeree-products/ucp/admin/disaster-recovery/backup-ucp.html)

## Conclusion

Performing regular backups for your Docker UCP and DTR installations is crucial for disaster recovery. With the steps provided in this guide, you should be able to create secure backups of your data and restore functionality quickly when necessary. Remember to test your backup process regularly and store your backup files in a secure location.