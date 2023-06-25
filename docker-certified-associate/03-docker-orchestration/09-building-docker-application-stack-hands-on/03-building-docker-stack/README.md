
# Building Docker Application Stack

This tutorial provides a hands-on guide to building a Docker application stack, using Docker Swarm's powerful orchestration features. This guide will help you understand Docker stacks, how to manage complex multi-component applications, and how to scale services within an existing stack.

## Table of Contents

- [Introduction](#introduction)
- [Additional Resources](#additional-resources)
- [Hands-On](#hands-on)
    - [Build and Deploy the Application Stack](#build-and-deploy-the-application-stack)
    - [Scale the Fruit and Vegetable Services in the Stack](#scale-the-fruit-and-vegetable-services-in-the-stack)
- [Relevant Documentation](#relevant-documentation)
- [Conclusion](#conclusion)

## Introduction

Docker stacks provide a robust toolset for managing complex applications composed of multiple, interconnected components, each running in a separate container. This tutorial offers a hands-on approach to building a multi-component application as a Docker stack, and teaches you how to manage and scale services in an already deployed stack.

## Additional Resources

In this scenario, your company, a supermarket, is improving their Docker-based applications. They've developed three RESTful data services that communicate within a larger infrastructure. Your task is to design a Docker application stack to manage and scale these services as a unit. A Docker Swarm cluster is already set up for you to use.

The three services are as follows:

**1. Fruit Service:** Lists the fruits sold in the company's stores. Use the Docker image tag `kientree/fruit-service:1.0.1` to run this service. It listens on port 80 and should be named `fruit` inside the stack.

**2. Vegetable Service:** Lists the vegetables sold in the company's stores. Use the Docker image tag `kientree/vegetable-service:1.0.0` to run this service. It listens on port 80 and should be named `vegetables` inside the stack.

**3. All Products Service:** Combines data from the other two services into a single list of all produce. Use the Docker image tag `kientree/all-products:1.0.0` to run this service. It listens on port 80. Use the environment variables `FRUIT_HOST` and `FRUIT_PORT` to set the host and port for querying the fruit service. Similarly, use `VEGETABLE_HOST` and `VEGETABLE_PORT` for the vegetable service.

## Hands-On

### Build and Deploy the Application Stack

1. Log in to the lab server using the provided credentials: `ssh cloud_user@PUBLIC_IP_ADDRESS`

2. Create a project directory and a Docker compose YAML file:

```bash
cd ~/
mkdir produce
cd produce
vi produce.yml
```

3. Define your stack in `produce.yml` according to the given specifications:

```yml
version: '3'
services:
  fruit:
    image: kientree/fruit-service:1.0.0
  vegetables:
    image: kientree/vegetable-service:1.0.0
  all_products:
    image: kientree/all-products:1.0.0
    ports:
      - "8080:80"
    environment:
      - FRUIT_HOST=fruit
      - FRUIT_PORT=80
      - VEGETABLE_HOST=vegetables
      - VEGETABLE_PORT=80
```

In this configuration, each service is defined with its respective image. The `all_products` service also exposes port 8080 on the host, mapping it to port 80 within the container. Additionally, environment variables are set for communication between services, specifying the host and port values for `fruit` and `vegetables` services.

4. Deploy the stack using the following command:

```bash
docker stack deploy -c produce.yml produce
```

5. Verify that the stack is working using the following command:

```bash
curl localhost:8080
```

**Note**: The stack may take a moment to become responsive after deployment. 

6. List the services in a stack using the following command:

```bash
docker stack services produce
```

Expected output:

```plaintext
ID             NAME                   MODE         REPLICAS   IMAGE                              PORTS
4vl0jvhh0l5c   produce_all_products   replicated   1/1        kientree/all-products:1.0.0        *:8080->80/tcp
r6eirgxsl8e0   produce_fruit          replicated   1/1        kientree/fruit-service:1.0.0       
y5660y1gguot   produce_vegetables     replicated   1/1        kientree/vegetable-service:1.0.0 
```

7. Show the individual tasks (containers) associated with the services in the `produce` stack using the following command:

```bash
docker stack ps produce
```

Expected ouput:

```plaintext
ID             NAME                     IMAGE                              NODE      DESIRED STATE   CURRENT STATE            ERROR     PORTS
w8tlepq5trab   produce_all_products.1   kientree/all-products:1.0.0        node3     Running         Running 24 minutes ago             
v7x3fb3npgnz   produce_fruit.1          kientree/fruit-service:1.0.0       node1     Running         Running 24 minutes ago             
puo6vahfig8p   produce_vegetables.1     kientree/vegetable-service:1.0.0   node2     Running         Running 24 minutes ago   
```

### Scale the Fruit and Vegetable Services in the Stack

1. Set the number of replicas to 3 for the `fruit` and `vegetables` services in the compose file:

```yml
version: '3'
services:
  fruit:
    image: kientree/fruit-service:1.0.0
    deploy:
      replicas: 3
  vegetables:
    image: kientree/vegetable-service:1.0.0
    deploy:
      replicas: 3
  all_products:
    image: kientree/all-products:1.0.0
    ports:
      - "8080:80"
    environment:
      - FRUIT_HOST=fruit
      - FRUIT_PORT=80
      - VEGETABLE_HOST=vegetables
      - VEGETABLE_PORT=80
```

2. Redeploy the stack using the following command:

```bash
docker stack deploy -c produce.yml produce
```

3. Verify that the stack is still working using the following command:

```bash
curl localhost:8080
```

4. Verify that the number of replicas for the `fruit` and `vegetables` services has been set to 3, you can use the following command:

```bash
docker stack services produce
```

Expected output:

```plaintext
ID             NAME                   MODE         REPLICAS   IMAGE                              PORTS
4vl0jvhh0l5c   produce_all_products   replicated   1/1        kientree/all-products:1.0.0        *:8080->80/tcp
r6eirgxsl8e0   produce_fruit          replicated   3/3        kientree/fruit-service:1.0.0       
y5660y1gguot   produce_vegetables     replicated   3/3        kientree/vegetable-service:1.0.0 
```

5. Show the individual tasks (containers) associated with the services in the `produce` stack using the following command:

```bash
docker stack ps produce
```

Expected ouput:

```plaintext
ID             NAME                     IMAGE                              NODE      DESIRED STATE   CURRENT STATE            ERROR     PORTS
w8tlepq5trab   produce_all_products.1   kientree/all-products:1.0.0        node3     Running         Running 31 minutes ago             
v7x3fb3npgnz   produce_fruit.1          kientree/fruit-service:1.0.0       node1     Running         Running 31 minutes ago             
77p2ur82sn3d   produce_fruit.2          kientree/fruit-service:1.0.0       node2     Running         Running 15 seconds ago             
urhmsz2u361j   produce_fruit.3          kientree/fruit-service:1.0.0       node3     Running         Running 15 seconds ago             
puo6vahfig8p   produce_vegetables.1     kientree/vegetable-service:1.0.0   node2     Running         Running 31 minutes ago             
al7a76yddwip   produce_vegetables.2     kientree/vegetable-service:1.0.0   node3     Running         Running 15 seconds ago             
dffk9vywugqh   produce_vegetables.3     kientree/vegetable-service:1.0.0   node1     Running         Running 15 seconds ago    
```

## Relevant Documentation

- [Docker Stacks and Compose files](https://docs.docker.com/compose/compose-file/)
- [Deploy services to a swarm](https://docs.docker.com/engine/swarm/stack-deploy/)
- [Docker Swarm overview](https://docs.docker.com/engine/swarm/)

## Conclusion

Congratulations — you've completed this hands-on Docker tutorial! You've learned how to build a Docker application stack, manage a multi-component application, and scale services within a deployed stack. Keep exploring and expanding your Docker skills!

