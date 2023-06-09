# Building Efficient Docker Images

This repository is a guide to building efficient Docker images. It contains examples, instructions, and concepts designed to provide a foundation for the creation of compact, efficient Docker images. It includes topics on how to implement best practices for Docker image building, like the use of multistage builds to reduce image sizes.

## Table of Contents

- [Introduction](#introduction)
- [General Tips](#general-tips)
- [Multi-stage Builds](#multi-stage-builds)
- [Hands-on](#hands-on)
    - [Inefficient Docker Image Building](#inefficient-docker-image-building)
    - [Efficient Docker Image Building](#efficient-docker-image-building)
- [Relevant Documentation](#relevant-documentation)
- [Conclusion](#conclusion)

## Introduction

Dockerfiles enable us to construct our own images containing any software we need. However, ensuring that our Dockerfiles produce small, efficient images devoid of unnecessary data is crucial. In this guide, we will briefly touch on some general tips for creating efficient images and demonstrate the use of multi-stage builds to significantly decrease image sizes in certain situations.

## General Tips

Building Docker images as efficiently as possible usually means that the images need to be as small as possible. Here are some key points to consider:

- Docker images use a multi-layered file system, so it's best to put things less likely to change on lower-level layers to maximize caching during builds or image transfers.
- Avoid creating unnecessary layers; bundling commands into a single layer is more efficient.
- Don't include unnecessary files or packages in the image; professional images on Docker Hub are minimal because they exclude unnecessary files.

## Multi-stage Builds

The Dockerfile multi-stage build is a powerful feature for minimizing the size of Docker images. In a multi-stage build, multiple FROM instructions are used in the Dockerfile, each new FROM instruction can be seen as starting a new build stage. This means you can perform operations in one stage, then copy the relevant files to another stage, leaving behind everything you don't want in the final image.

## Hands-on

There are two common methods for building Docker images, which we'll categorize as "efficient" and "inefficient". In this guide, we will create two Go applications using both methods and compare the resulting Docker images.

### Inefficient Docker Image Building

We will start with the "inefficient" method. Here, we're going to build the application directly in the production image.

1. Let's start by setting up the project directories:

```bash
cd ~/
mkdir inefficient
cd inefficient
```

2. Next, create a source code file for your Go application (`helloworld.go`):

```go
package main
import "fmt"
func main() {
fmt.Println("hello world")
}
```

You can create this file using `vi helloworld.go`.

3. Then, create the Dockerfile:

```Dockerfile
FROM golang:1.12.4
WORKDIR /helloworld
COPY helloworld.go .
RUN GOOS=linux go build -a -installsuffix cgo -o helloworld .
CMD ["./helloworld"]
```

You can create this Dockerfile using `vi Dockerfile`.

4. Now, let's build and test the inefficient image:

```bash
docker build -t inefficient .
docker run inefficient
docker image ls
```

## Efficient Docker Image Building

Now let's switch to the "efficient" method. Here, we use a multi-stage build to first build the application in a separate "build" image, and then copy the compiled application into the production image.

1. First, switch to the efficient project directory and copy the files from the inefficient project:

```bash
cd ~/efficient
cp ../inefficient/helloworld.go ./
cp ../inefficient/Dockerfile ./
```

2. Change the Dockerfile to use a multi-stage build:

```Dockerfile
FROM golang:1.12.4 AS compiler
WORKDIR /helloworld
COPY helloworld.go .
RUN GOOS=linux go build -a -installsuffix cgo -o helloworld .

FROM alpine:3.9.3
WORKDIR /root
COPY --from=compiler /helloworld/helloworld .
CMD ["./helloworld"]
```

You can make these changes using vi Dockerfile.

3. Finally, build and test the efficient image:

```bash
docker build -t efficient .
docker run efficient
docker image ls
```

After running the above commands, you can compare the sizes of the inefficient and efficient images using the docker image ls command. The "efficient" Docker image should be significantly smaller because it does not contain the Go toolchain, only the compiled application.

## Relevant Documentation

- [Dockerfile Best Practices](https://docs.docker.com/develop/develop-images/dockerfile_best-practices/)
- [Multi-stage Build](https://docs.docker.com/develop/develop-images/multistage-build/)

## Conclusion

We've discussed some of the general tips to keep in mind when building Docker images efficiently, and we've shown how to use multi-stage builds to significantly reduce the size of your images. Implementing these practices in your projects will lead to efficient, streamlined Docker images that are optimized for real-world usage. Happy Dockering!