# Docker Trusted Registry (DTR)

Welcome to this guide on Docker Trusted Registry (DTR). Here, you will gain a deeper understanding of what DTR is, its unique features, and its significance in the Docker ecosystem.

## Table of Contents

- [Introduction](#introduction)
- [Key Features of DTR](#key-features-of-dtr)
- [High Availability in DTR](#high-availability-in-dtr)
- [DTR Cache](#dtr-cache)
- [Conclusion](#conclusion)
- [References](#references)

## Introduction

Docker Trusted Registry (DTR) is an enhanced, enterprise-ready private Docker registry, built upon the foundational concepts of private registries. It is a component of Docker Enterprise Edition and brings with it several additional features tailored for enterprise use-cases.

## Key Features of DTR

- **Web UI**: Just as with Docker Universal Control Plane (UCP), DTR has a dedicated web user interface.
- **High Availability**: DTR supports multiple registry nodes, forming a resilient infrastructure that ensures your Docker images are always available.
- **Geo-replication**: With DTR, images can be cached closer to the users' geographical locations, enhancing image download speeds.
- **Role-based Access Control**: DTR provides granular access controls, letting you define who can access and modify your Docker images.
- **Security Vulnerability Scans**: One standout feature of DTR is the ability to scan Docker images, identifying potential security vulnerabilities in the software.

## High Availability in DTR

DTR's approach to high availability revolves around maintaining a quorum among its replicas.

**Understanding Quorum**: 

A quorum is achieved when more than half of the replicas in a DTR cluster are operational. For instance:
- In a 4-replica cluster: A loss of 1 replica maintains the quorum, but if 2 or more replicas are lost, quorum is disrupted.
- In a 3-replica cluster: A loss of 1 replica is acceptable, but losing 2 replicas disrupts the quorum.

## DTR Cache

Caching in DTR ensures images are available closer to end-users, speeding up download times. Here's what you need to know about DTR Cache:

- **First-Time Pull**: On the first pull request from a cache, the cache fetches the image from the main DTR cluster. Subsequent pulls by other users are then served faster directly from the cache.
  
- **Authentication**: Users authenticate using the primary DTR URL. They remain unaware of the cache and still use the main DTR URL for both authentication and image pulling.

- **Transparent Redirection**: When a user requests an image, the main DTR responds with a redirect to the appropriate cache. This is seamless for the user.

- **User Profile Settings**: These determine which cache a user pulls images from based on their geographical location.

## Relevant Documentation

- [Docker Trusted Registry](https://docs.mirantis.com/containers/v2.1/dockeree-products/dtr.html#)
- [DTR cache fundamentals](https://docs.mirantis.com/containers/v2.1/dockeree-products/dtr/dtr-admin/configure/deploy-caches/dtr-cache-fundamentals.html)
- [Set up high availability](https://docs.mirantis.com/containers/v2.1/dockeree-products/dtr/dtr-admin/configure/set-up-high-availability.html)

## Conclusion

Docker Trusted Registry (DTR) extends the capabilities of private Docker registries with features specifically designed for enterprise needs. From high availability to geo-replication and security scanning, DTR ensures your Docker images are safe, available, and quickly accessible to users.