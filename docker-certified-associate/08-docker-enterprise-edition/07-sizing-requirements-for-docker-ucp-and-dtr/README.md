# Sizing Requirements for Docker, UCP, and DTR 

## Table of Contents

- [Introduction](#introduction)
- [Understanding Docker Sizing Requirements](#understanding-docker-sizing-requirements)
- [Universal Control Plane (UCP) Sizing Requirements](#universal-control-plane-ucp-sizing-requirements)
- [Docker Trusted Registry (DTR) Sizing Requirements](#docker-trusted-registry-dtr-sizing-requirements)
- [Examples](#examples)
- [Relevant Documentation](#relevant-documentation)
- [Conclusion](#conclusion)

## Introduction

Preparing for the Docker Certified Associate (DCA) exam, or simply setting up your Docker environment, requires a fundamental understanding of system resource allocation. This guide introduces you to the basics of sizing requirements for Docker and its management components: Universal Control Plane (UCP) and Docker Trusted Registry (DTR). It is designed to be an easily understandable primer for beginners, offering a foundation upon which one can build more detailed knowledge as needed.

## Understanding Docker Sizing Requirements

Docker's versatility means that it does not prescribe rigid sizing requirements. Instead, the resource allocation for Docker depends on the specifics of the container workloads you plan to run. Essentially, to determine the appropriate sizing for Docker, consider the following:

- The resources required by the applications within your containers.
- The expected load on these applications.
- Potential scaling needs in the future.

## Universal Control Plane (UCP) Sizing Requirements

UCP, which allows for the management of Docker clusters, has more specific requirements:

- **Minimum for Manager Nodes:**
  - 8 GB of memory
  - 2 CPUs
- **Recommended for Manager Nodes:**
  - 16 GB of memory
  - 4 CPUs

For a simple development cluster, the minimum may suffice. However, most production environments will necessitate the recommended configuration.

- **Worker Nodes:**
  - Minimum of 4 GB of memory
  - CPUs are not explicitly specified, but at least 1 CPU is necessary for operation.

The takeaway here is that manager nodes require more robust resources compared to worker nodes.

## Docker Trusted Registry (DTR) Sizing Requirements

DTR, which is concerned with storing and managing Docker images, demands higher specifications due to its storage requirements:

- **Minimum:**
  - 16 GB of memory
  - 2 CPUs
  - 10 gigabytes of disk space

- **Recommended:**
  - 16 GB of memory
  - 4 CPUs
  - 25 to 100 GB of disk space

These requirements account for the need to manage a potentially large volume of Docker images.

## Examples

### Example for a Docker Setup

Imagine you have three web applications you wish to containerize using Docker. Each application is expected to use approximately 1 GB of RAM and minimal CPU. For this scenario, a server with at least 4 GB of RAM and 2 CPUs could suffice for a basic development setup.

### Example for a UCP Setup

For a UCP manager node, if you're setting up a production-level cluster and expect moderate load, you should aim for the recommended setup with 16 GB of RAM and 4 CPUs.

### Example for a DTR Setup

Setting up a DTR for a small team of developers, you may store hundreds of images. Therefore, starting with the recommended 16 GB of RAM, 4 CPUs, and 25 GB of disk space would be prudent to ensure smooth operations.

## Relevant Documentation

- [DTR system requirements](https://docs.mirantis.com/containers/v2.1/dockeree-products/dtr/dtr-admin/dtr-install.html)
- [UCP system requirements](https://docs.mirantis.com/containers/v2.1/dockeree-products/ucp/admin/install-ucp.html)

## Conclusion

Understanding the resource requirements for Docker, UCP, and DTR is crucial for efficient deployment and management of containerized applications. Begin with the guidelines provided, and adjust based on the scale and performance needs of your specific environment. Remember that these recommendations serve as a starting point, and actual usage will inform any necessary adjustments over time.