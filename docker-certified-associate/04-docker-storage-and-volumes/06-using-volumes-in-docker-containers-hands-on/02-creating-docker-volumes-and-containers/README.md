# Docker Volumes Hands-On Lab: Handling Persistent Data

## Table of Contents

- [Introduction](#introduction)
- [Problem Statement](#problem-statement)
- [Solution](#solution)
   - [Creating Shared Volume](#creating-shared-volume)
   - [Creating Counter Container](#creating-counter-container)
   - [Creating Fluentd Container](#creating-fluentd-container)
- [Relevant Documentation](#relevant-documentation)
- [Conclusion](#conclusion)

## Introduction

Docker containers, by their nature, are ephemeral - meaning they are designed to be disposable. Hence, storing persistent data directly in a container's file system is generally discouraged. For storing persistent data and ensuring data longevity, Docker provides a feature called 'volumes'. Docker volumes allow you to manage your persistent data outside of the container itself, thereby ensuring data safety even if the container is disposed of. 

This tutorial guides you through a hands-on lab where you will be interacting with Docker volumes, shared volumes, and bind mounts. By doing this, you'll develop a strong foundational knowledge about Docker volumes and learn how they can be effectively used.

## Problem Statement

Suppose you are part of a team that wishes to employ an application named 'fluentd' to standardize log output from Docker containers. Your task is to create a proof-of-concept demonstrating the potential of this approach. 

You are required to:

1. Run a container that generates log data in a file.
2. Run a second container with fluentd to read, transform, and output the transformed data to a file on the host machine.

To assist you, a configuration file for fluentd has been provided. Detailed specifications of the proof-of-concept, including the specific requirements of the containers, the commands to generate data, volume and bind mount creation, are given below.

## Solution

Solution Architecture:

```plaintext
┌──────────────────────────────────────────────────────────────────────────────────────────────────────────────────┐
│Host                                                                                                              │
│                                                                                                                  │
│  ┌────────────────────────────┐          ┌────────────────────────────┐          ┌────────────────────────────┐  │
│  │     Counter Container      │          │         FILESYSTEM         │          │     Fluentd Container      │  │
│  ├────────────────────────────┤          ├────────────────────────────┤          ├────────────────────────────┤  │
│  │                            │          │                            │          │                            │  │
│  │                            │          │                            │          │                            │  │
│  │ ┌ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─  │          │ ┌ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─  │          │ ┌ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─  │  │
│  │                          │ │  volume  │                          │ │  volume  │                          │ │  │
│  │ │     /var/log/test       ◀┼──────────┼─│    test-data Volume     ─┼──────────┼▶│     /var/log/input       │  │
│  │                          │ │          │                          │ │          │                          │ │  │
│  │ └ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─  │          │ └ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─  │          │ └ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─  │  │
│  │                            │          │                            │          │                            │  │
│  │                            │          │ ┌ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─  │          │ ┌ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─  │  │
│  │                            │          │                          │ │   bind   │                          │ │  │
│  │                            │          │ │/etc/fluentd/fluent.conf ─┼──────────┼▶│/fluentd/etc/fluent.conf  │  │
│  │                            │          │                          │ │          │                          │ │  │
│  │                            │          │ └ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─  │          │ └ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─  │  │
│  │                            │          │                            │          │                            │  │
│  │                            │          │ ┌ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─  │          │ ┌ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─  │  │
│  │                            │          │                          │ │   bind   │                          │ │  │
│  │                            │          │ │  /etc/fluentd/output    ─┼──────────┼▶│    /var/log/output       │  │
│  │                            │          │                          │ │          │                          │ │  │
│  │                            │          │ └ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─  │          │ └ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─  │  │
│  └────────────────────────────┘          └────────────────────────────┘          └────────────────────────────┘  │
│                                                                                                                  │
│                                                                                                                  │
└──────────────────────────────────────────────────────────────────────────────────────────────────────────────────┘

                                                © Minh Hung Phan
```

### Creating Shared Volume

1. Start by logging in to the lab server using the credentials provided:

```bash
ssh cloud_user@PUBLIC_IP_ADDRESS
```
   
**Note**: Replace `cloud_user` with `<your-username>`

2. Create a shared volume named 'test-data':

```bash
docker volume create test-data
```

### Creating Counter Container

1. Create a container named 'counter' using the busybox image. This container will generate log data by counting numbers every second. Mount the 'test-data' volume to the container at `/var/log/test`:

```bash
docker run --name counter -d \
    --mount type=volume,source=test-data,destination=/var/log/test \
    busybox \
    sh -c 'i=0; while true; do echo "$i: $(date)" >> /var/log/test/1.log; i=$((i+1)); sleep 1; done'
```

2. Check the 'counter' container is up and running:

```bash
docker ps
```

Output:

```plaintext
CONTAINER ID   IMAGE     COMMAND                  CREATED         STATUS         PORTS     NAMES
d4e5c9a0f0fa   busybox   "sh -c 'i=0; while t…"   7 seconds ago   Up 5 seconds             counter
```

3. Confirm the 'counter' container is generating data:

```bash
docker exec counter cat /var/log/test/1.log
```

Output:

```plaintext
0: Sat Jul  8 10:01:55 UTC 2023
1: Sat Jul  8 10:01:56 UTC 2023
2: Sat Jul  8 10:01:57 UTC 2023
3: Sat Jul  8 10:01:58 UTC 2023
4: Sat Jul  8 10:01:59 UTC 2023
5: Sat Jul  8 10:02:00 UTC 2023
6: Sat Jul  8 10:02:01 UTC 2023
7: Sat Jul  8 10:02:02 UTC 2023
8: Sat Jul  8 10:02:03 UTC 2023
9: Sat Jul  8 10:02:04 UTC 2023
10: Sat Jul  8 10:02:05 UTC 2023
11: Sat Jul  8 10:02:06 UTC 2023
12: Sat Jul  8 10:02:07 UTC 2023
13: Sat Jul  8 10:02:08 UTC 2023
14: Sat Jul  8 10:02:09 UTC 2023
15: Sat Jul  8 10:02:10 UTC 2023
16: Sat Jul  8 10:02:11 UTC 2023
17: Sat Jul  8 10:02:12 UTC 2023
18: Sat Jul  8 10:02:13 UTC 2023
19: Sat Jul  8 10:02:14 UTC 2023
20: Sat Jul  8 10:02:15 UTC 2023
```

### Creating Fluentd Container

1. Create a second container called 'fluentd' with the `k8s.gcr.io/fluentd-gcp:1.30` image. 

2. Set the environment variable `FLUENTD_ARGS` with the value `-c /fluentd/etc/fluent.conf`.

3. Use bind mounts and shared volumes as described below:

```bash
docker run --name fluentd -d \
    --mount type=volume,source=test-data,destination=/var/log/input \
    --mount type=bind,source=/etc/fluentd/fluent.conf,destination=/fluentd/etc/fluent.conf \
    --mount type=bind,source=/etc/fluentd/output,destination=/var/log/output \
    --env FLUENTD_ARGS="-c /fluentd/etc/fluent.conf" \
    k8s.gcr.io/fluentd-gcp:1.30
```

4. Check the 'fluentd' container is up and running:

```bash
docker ps
```

Output:

```plaintext
CONTAINER ID   IMAGE                         COMMAND                  CREATED              STATUS              PORTS     NAMES
84dc99504667   k8s.gcr.io/fluentd-gcp:1.30   "/bin/sh -c '/run.sh…"   About a minute ago   Up About a minute             fluentd
d4e5c9a0f0fa   busybox                       "sh -c 'i=0; while t…"   13 minutes ago       Up 13 minutes                 counter
```

5. Verify that the fluentd container is generating output:

```bash
ls /etc/fluentd/output
```

You should see some files containing the transformed log data.

Output:

```plaintext
count.20230708100439.b5fff6e0a37eedcf9  count.20230708100440.b5fff6e0b2c9abc56  count.20230708100441.b5fff6e0c2116e23d  count.20230708100442.b5fff6e0d158713fe
```

## Relevant Documentation

- [Docker Volumes](https://docs.docker.com/storage/volumes/)
- [Fluentd Documentation](https://docs.fluentd.org/)
- [Docker Bind Mounts](https://docs.docker.com/storage/bind-mounts/)
- [Docker Environment Variables](https://docs.docker.com/engine/reference/run/#env-environment-variables)

## Conclusion

Congratulations! You have successfully implemented Docker volumes to create two interconnected containers, demonstrating how data persistence and inter-container interaction can be managed. This practical knowledge will help you solve complex problems using Docker volumes in the future.