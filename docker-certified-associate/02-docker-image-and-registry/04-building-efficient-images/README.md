# Building Efficient Docker Images

This repository is a guide to building efficient Docker images. It contains examples, instructions, and concepts designed to provide a foundation for the creation of compact, efficient Docker images. It includes topics on how to implement best practices for Docker image building, like the use of multistage builds to reduce image sizes.

## Table of Contents

- [Introduction](#introduction)
- [General Tips](#general-tips)
- [Multi-stage Builds](#multi-stage-builds)
- [Hands-on](#hands-on)
    - [Inefficient Docker Image Building](#inefficient-docker-image-building)
    - [Efficient Docker Image Building](#efficient-docker-image-building)
- [Understanding the `-installsuffix cgo` Flag](#understanding-the--installsuffix-cgo-flag)
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

3. Then, create the Dockerfile using `vi Dockerfile`:

```Dockerfile
FROM golang:1.12.4
WORKDIR /helloworld
COPY helloworld.go .
RUN GOOS=linux go build -a -installsuffix cgo -o helloworld .
CMD ["./helloworld"]
```

- The command `RUN GOOS=linux go build -a -installsuffix cgo -o helloworld .` compiles the Go program into a Linux executable named `helloworld`, ensuring it's statically linked (no dependencies on C libraries).

- When the command includes `-installsuffix cgo`, it tells the Go compiler not to use cgo, which is a tool that allows Go programs to call C libraries. By not using cgo, the resulting binary is statically linked, meaning all necessary code is included within the executable itself. This makes the binary self-contained, without needing any external C libraries to run.

- For more information, you can refer to the [Understanding the `-installsuffix cgo` Flag](#understanding-the--installsuffix-cgo-flag) section.

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

## Understanding the `-installsuffix cgo` Flag

The use of the `-installsuffix cgo` flag versus not using it serves different purposes related to how the Go binary is compiled and its dependencies:

### With `-installsuffix cgo` Flag:

1. **Purpose**: To create a statically linked binary without dependencies on C libraries.

2. **Behavior**:

- Ensures the resulting binary does not rely on cgo, making it self-contained and portable.
- Places the build artifacts in a separate directory (`pkg/linux_amd64/cgo`), isolating them from the default cgo-enabled artifacts.
- When you use the `-installsuffix cgo` flag with the `go build` command, the directory structure will include a separate set of build artifacts specifically for the non-cgo version. Here's a simplified view of what the directory might look like after the build:

```
/helloworld
    |-- helloworld.go      # Your source Go file
    |-- helloworld         # The statically linked binary output
    |-- pkg                # Package directory for compiled packages
        |-- linux_amd64    # Directory for Linux AMD64 architecture
            |-- cgo        # Subdirectory for non-cgo build artifacts (created due to -installsuffix cgo)
                |-- <compiled non-cgo packages>
            |-- <default compiled packages>  # Default location for cgo-enabled build artifacts
```

Explanation:

- `/helloworld`: The working directory where your Dockerfile is set and where the `helloworld.go` source file is located.
- `helloworld.go`: The source Go file.
- `helloworld`: The compiled statically linked binary.
- `pkg/linux_amd64`: The directory for compiled package artifacts for the Linux AMD64 architecture.
    - `cgo`: Subdirectory containing non-cgo build artifacts created due to the `-installsuffix cgo` flag.
    - `<default compiled packages>`: Default location for cgo-enabled build artifacts.

The key point is that by using `-installsuffix cgo`, the Go toolchain creates a distinct directory structure under `pkg` for the non-cgo build artifacts, ensuring no cgo dependencies are included in the final binary.

3. **Use Case**:

- When you need a binary that runs in environments where C libraries are not available.
- Ideal for Docker containers or minimalistic environments where you want to avoid including C library dependencies.

### Without `-installsuffix cgo` Flag:

1. **Purpose**: To allow the Go binary to use cgo if necessary, potentially linking with C libraries.

2. **Behavior**:

- Compiles the binary normally, which may include cgo if any part of the code requires it.
- Places all build artifacts in the default location (`pkg/linux_amd64`), including cgo-dependent ones.
- Without the `-installsuffix cgo` flag, the directory structure will not have the separate subdirectory for non-cgo build artifacts. Instead, it will look more straightforward, as the Go compiler will place all build artifacts in the default locations. Here's a simplified view:

```
/helloworld
    |-- helloworld.go      # Your source Go file
    |-- helloworld         # The compiled binary output (might dynamically link to C libraries if cgo is used)
    |-- pkg                # Package directory for compiled packages
        |-- linux_amd64    # Directory for Linux AMD64 architecture
            |-- <compiled packages>  # Compiled packages, potentially including cgo dependencies
```

Explanation:

- `/helloworld`: The working directory where your Dockerfile is set and where the `helloworld.go` source file is located.
- `helloworld.go`: The source Go file.
- `helloworld`: The compiled binary, which may dynamically link to C libraries if cgo is used.
- `pkg/linux_amd64`: The directory where compiled package artifacts are stored, potentially including those that rely on cgo.

In this case, the build artifacts are not separated, and the resulting binary may have dependencies on C libraries if the Go code uses cgo. The directory does not include a separate subdirectory (like `cgo`) for the non-cgo artifacts.

3. **Use Case**:

- When your Go code needs to call C functions or use C libraries.
- Suitable for environments where you can ensure the presence of the necessary C libraries.

## Relevant Documentation

- [Dockerfile Best Practices](https://docs.docker.com/develop/develop-images/dockerfile_best-practices/)
- [Multi-stage Build](https://docs.docker.com/develop/develop-images/multistage-build/)
- [Build with Dockers - layers](https://docs.docker.com/build/guide/layers/)
- [cgo command - cmd/cgo](https://pkg.go.dev/cmd/cgo)

## Conclusion

We've discussed some of the general tips to keep in mind when building Docker images efficiently, and we've shown how to use multi-stage builds to significantly reduce the size of your images. Implementing these practices in your projects will lead to efficient, streamlined Docker images that are optimized for real-world usage. Happy Dockering!