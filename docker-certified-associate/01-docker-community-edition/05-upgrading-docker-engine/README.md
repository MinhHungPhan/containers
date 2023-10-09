# Upgrading Docker Engine

## Table of Contents

- [Introduction](#introduction)
- [Downgrading to a Previous Version](#downgrading-to-a-previous-version)
- [Upgrading to a New Version](#upgrading-to-a-new-version)
- [Relevant Documentation](#relevant-documentation)
- [Conclusion](#conclusion)

## Introduction

Welcome to the Docker Engine Upgrade Guide. When using Docker to manage containers, it is crucial to keep the Docker Engine up-to-date. This guide will walk you through the process of both downgrading and upgrading the Docker Engine on Ubuntu Server. Whether you need to install a newer version or revert to a previous one, this guide has got you covered.

## Downgrading to a Previous Version

Before upgrading to a new version, it's essential to downgrade Docker to ensure a smooth transition. Follow these steps to downgrade Docker to a previous version:

1. Stop Docker by running the following command:

```bash
sudo systemctl stop docker
```

2. Remove the Docker packages using the following command:

```bash
sudo apt-get remove -y docker-ce docker-ce-cli
```

> Note: Don't worry, removing the packages will not delete your containers.

3. Update the local package listings:

```bash
sudo apt-get update
```

4. Install the earlier version of Docker using the package string. Run the following command:

```bash
sudo apt-get install -y docker-ce=5:18.09.4~3-0~ubuntu-bionic docker-ce-cli=5:18.09.4~3-0~ubuntu-bionic
```

Ensure that you replace the version string with the desired version you want to downgrade to.

5. Verify the Docker version by executing the following command:

```bash
docker version
```

The output should display the downgraded version you installed.

## Upgrading to a New Version

Upgrading Docker to a new version is a straightforward process. You don't need to stop Docker or remove any packages. Follow these steps to upgrade Docker to a newer version:

1. Install the new Docker packages using the following command:

```bash
sudo apt-get install -y docker-ce=5:18.09.5~3-0~ubuntu-bionic docker-ce-cli=5:18.09.5~3-0~ubuntu-bionic
```

Replace the version string with the desired version you want to upgrade to.

2. Verify the Docker version by running the following command:

```bash
docker version
```

The output should display the upgraded version you installed.

**Note:** The information provided in this guide is accurate at the time of writing.

## Relevant Documentation

- [Docker CE - Ubuntu Installation Guide](https://docs.docker.com/install/linux/docker-ce/ubuntu/#upgrade-docker-ce).

## Conclusion

Congratulations! You have successfully downgraded or upgraded your Docker Engine. Keeping your Docker installation up-to-date is crucial for security and accessing the latest features. In this guide, we discussed the process of both downgrading to a previous version and upgrading to a newer version of the Docker Engine on Ubuntu Server. Happy Dockerizing! 🌱