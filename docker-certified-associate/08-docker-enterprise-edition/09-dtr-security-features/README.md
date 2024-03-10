# Docker Trusted Registry (DTR) Security Features

## Table of Contents

- [Introduction](#introduction)
- [Overview of DTR Security Features](#overview-of-dtr-security-features)
- [Enabling Security Scanning in DTR](#enabling-security-scanning-in-dtr)
- [Setting Up Repository Vulnerability Scanning](#setting-up-repository-vulnerability-scanning)
- [Understanding and Implementing Tag Immutability](#understanding-and-implementing-tag-immutability)
- [Relevant Documentation](#relevant-documentation)
- [Conclusion](#conclusion)

## Introduction

Welcome to our comprehensive guide on Docker Trusted Registry (DTR) security features. This lesson aims to provide a clear and detailed understanding of the additional security mechanisms available in DTR, which are not typically found in standard Docker registries. We will delve into the concepts of authentication, vulnerability scanning, and tag immutability, equipping you with the necessary skills to manage container images in a more secure manner. 

## Overview of DTR Security Features

Docker Trusted Registry (DTR) stands out from standard Docker registries by offering enhanced security features. These features are crucial for safeguarding your containerized applications against security vulnerabilities and ensuring the integrity of your Docker images.

## Enabling Security Scanning in DTR

To enable security scanning:

- Access the Docker Trusted Registry web UI.
- Navigate to `System > Security`.
- Here, you'll find the option to enable vulnerability scanning. Note that this requires a special license.

**Example:** Let's say you've logged into DTR and you're at the `System > Security` page. You'll see options related to security scanning. However, without the appropriate license, these options will not be actionable.

## Setting Up Repository Vulnerability Scanning

Once you've obtained the necessary license, you can set up vulnerability scanning for each repository:

- Create a new repository (e.g., `myrepo`).
- Click on `Show Advanced Settings` during repository creation.
- You will find the `Scan on push` option. This can be set to `Manual` or `On push`.

**Example:** If you choose `On push`, new images will be automatically scanned for vulnerabilities as they are pushed to the repository.

## Understanding and Implementing Tag Immutability

Tag immutability is another vital feature in DTR:

- While creating or modifying a repository, look for the `Immutability` option.
- Enabling it prevents overwriting of existing tags.

**Example:** If you enable immutability for a tag, any attempts to overwrite it with a new image will result in an error, thereby protecting the integrity of the tagged image.

## Relevant Documentation

- [Set Up Security Scanning in DTR](https://docs.docker.com/dtr/)
- [Prevent Tags from Being Overwritten](https://docs.docker.com/dtr/tags/)

## Conclusion

In this lesson, we've explored key security features of Docker Trusted Registry, including security scanning and tag immutability. These tools are essential for maintaining the security and integrity of your Docker images. By leveraging these features, you can significantly enhance the security posture of your containerized applications.