# Building Services in Docker

In this lab, you will work with Docker services to practice scaling services by adjusting the number of replicas for an existing service. Additionally, you will create a new service and run it in the cluster.

## Table of Contents

- [Introduction](#introduction)
- [Creating Services ](#creating-services)
- [Scaling Services](#scaling-services)
- [Relevant Documentation](#relevant-documentation)
- [Conclusion](#conclusion)

## Introduction

Services are a fundamental and simple way to run containers using Docker swarm. They enable you to run multiple replica containers across all nodes in the Swarm cluster.

## Creating Services 

We will create two services using Docker images from our Docker Hub repository.

### Create the `products-fruits` service

1. Create the `products-fruits` service on the Docker Swarm Manager using the following command:

```bash
docker service create --name products-fruits -p 8080:80 --replicas 3 kientree/fruit-service:1.0.0
```

2. List the services running on a Docker Swarm cluster using the `docker service ls` command:

```bash
docker service ls
```

Expected output:

```plaintext
ID             NAME              MODE         REPLICAS   IMAGE                          PORTS
beb60q972qok   products-fruits   replicated   3/3        kientree/fruit-service:1.0.0   *:8080->80/tcp
```

3. List the tasks or replicas associated with a specific service named "products-fruit" in a Docker Swarm cluster using the `docker service ps <service-name>` command:

```bash
docker service ps products-fruits
```

Expected output:

```plaintext
ID             NAME                IMAGE                          NODE      DESIRED STATE   CURRENT STATE                ERROR     PORTS
mg14h3juomq0   products-fruits.1   kientree/fruit-service:1.0.0   node3     Running         Running about a minute ago             
xxonekwr6pn6   products-fruits.2   kientree/fruit-service:1.0.0   node1     Running         Running about a minute ago             
azaxz2w46ih9   products-fruits.3   kientree/fruit-service:1.0.0   node2     Running         Running about a minute ago
```

4. Verify that the service is working:

```bash
curl localhost:8080
```

You should see JSON data containing a list of fruits.

### Create the `products-vegetables` service

1. Create the `products-vegetables` service the Docker Swarm Manager using the following command:

```bash
docker service create --name products-vegetables -p 8081:80 --replicas 3 kientree/vegetable-service:1.0.0
```

2. List the services running on a Docker Swarm cluster using the `docker service ls` command:

```bash
docker service ls
```

Expected output:

```plaintext
ID             NAME                  MODE         REPLICAS   IMAGE                              PORTS
beb60q972qok   products-fruits       replicated   3/3        kientree/fruit-service:1.0.0       *:8080->80/tcp
0zoubxvu7s8z   products-vegetables   replicated   3/3        kientree/vegetable-service:1.0.0   *:8081->80/tcp
```

3. List the tasks or replicas associated with a specific service named "products-fruit" in a Docker Swarm cluster using the `docker service ps <service-name>` command:

```bash
docker service ps products-vegetables
```

Expected output:

```plaintext
ID             NAME                    IMAGE                              NODE      DESIRED STATE   CURRENT STATE                ERROR     PORTS
n0juadvq020y   products-vegetables.1   kientree/vegetable-service:1.0.0   node2     Running         Running about a minute ago             
nfl0i9fvna8m   products-vegetables.2   kientree/vegetable-service:1.0.0   node3     Running         Running about a minute ago             
i4kxehc8pp6s   products-vegetables.3   kientree/vegetable-service:1.0.0   node1     Running         Running about a minute ago   
```

4. Verify that the service is working:

```bash
curl localhost:8081
```

You should see JSON data containing a list of vegetables.

## Scaling Services

Scale the `products-fruit` service to 5 replicas using the following command:

```bash
docker service update --replicas 5 products-fruits
```

Alternatively, you can use the following command (both achieve the same result):

```bash
docker service scale products-fruits=5
```

To check the tasks or replicas for the `products-fruits service`, you can use the following command:

```bash
docker service ps products-fruits
```

Expected output:

```plaintext
ID             NAME                IMAGE                          NODE      DESIRED STATE   CURRENT STATE            ERROR     PORTS
mg14h3juomq0   products-fruits.1   kientree/fruit-service:1.0.0   node3     Running         Running 12 minutes ago             
xxonekwr6pn6   products-fruits.2   kientree/fruit-service:1.0.0   node1     Running         Running 12 minutes ago             
azaxz2w46ih9   products-fruits.3   kientree/fruit-service:1.0.0   node2     Running         Running 12 minutes ago             
onojwuo1mbvv   products-fruits.4   kientree/fruit-service:1.0.0   node1     Running         Running 9 seconds ago              
tamajt7uriev   products-fruits.5   kientree/fruit-service:1.0.0   node2     Running         Running 9 seconds ago    
```

## Relevant Documentation

You may want to refer to the following official Docker documentation for additional insights:
- [Services](https://docs.docker.com/engine/swarm/services/)
- [How Swarm Mode Works - Services](https://docs.docker.com/engine/swarm/how-swarm-mode-works/services/)
- [Service Create](https://docs.docker.com/engine/reference/commandline/service_create/)

## Conclusion

Congratulations! You have successfully completed this hands-on lab.





