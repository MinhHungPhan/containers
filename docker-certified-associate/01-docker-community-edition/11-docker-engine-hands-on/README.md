# Installing and Configuring the Docker Engine

## Table of Contents

- [Introduction](#introduction)
- [Instructions](#instructions)
- [Solution](#solution)
- [Conclusion](#conclusion)

## Introduction

Docker CE is a free and open-source container runtime that provides a high-quality environment for running containers. This guide will walk you through the process of installing and configuring the Docker Engine. By following the steps outlined here, you will gain practical experience in setting up Docker CE and configuring a logging driver. This guide aims to provide you with valuable insights into the real-world installation and configuration of the Docker Engine on systems.

## Instructions

Your company is ready to start using Docker on some of its servers. To begin, you need to set up and configure Docker CE on an already provisioned server. Ensure that the server meets the following specifications:

1. Docker CE is installed and running on the server.
2. Use the latest version of Docker CE.
3. The user `cloud_user` has permission to run Docker commands.
4. The default logging driver is set to `syslog`.

If you encounter any difficulties, refer to the solution video or the detailed instructions provided for each objective. Good luck!

**Note:** When copying and pasting code into Vim from the lab guide, first enter `:set paste` (and then press `i` to enter insert mode) to avoid adding unnecessary spaces and hashes. To save and quit the file, press `Escape` followed by `:wq`. To exit the file without saving, press `Escape` followed by `:q!`.

## Solution

Log in to the server using the provided credentials:

```bash
ssh cloud_user@<PUBLIC_IP_ADDRESS>
```

## Install Docker CE on the server. 

1. Begin by ensuring that old versions of Docker are not present on the system:

```bash
sudo apt-get remove docker docker-engine docker.io containerd runc
```

2. Update the apt package index:

```bash
sudo apt update -y
```

3. Install the packages needed for apt to use a repository over HTTPS:

```bash
sudo apt install -y ca-certificates curl gnupg
```

4. Add the official Docker GPG key:

```bash
sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
```

5. Change the permissions of the docker.gpg file:

```bash
sudo chmod a+r /etc/apt/keyrings/docker.gpg
```

6. Set up the repository:

```bash
echo \
"deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
"$( . /etc/os-release && echo "$VERSION_CODENAME" )" stable" | \
sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
```

7. Update the list of available packages:

```bash
sudo apt -y update
```

8. Install Docker packages:

```bash
sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
```

**Note**: The package installation may take a few minutes.

9. Verify that your installation is working correctly:

```bash
sudo docker run hello-world
```

## Grant cloud_user access to run Docker commands. 

1. Confirm that the docker group has been created:

```bash
sudo groupadd docker
```

2. Add your user to the docker group:

```bash
sudo usermod -aG docker $USER
```

3. Either log out and log back in as cloud_user or run the following command:

```bash
newgrp docker
```

4. Once you have logged back in or executed the mentioned command, verify that cloud_user has access to Docker:

```bash
docker run hello-world
```

## Set the default logging driver to syslog. 

1. Edit the daemon.json file:

```bash
sudo vi /etc/docker/daemon.json
```

2. Add the following configuration to daemon.json to set the default logging driver:

```json
{
  "log-driver": "syslog"
}
```

3. Restart Docker:

```bash
sudo systemctl restart docker
```

4. Verify that the logging driver was set properly:

```bash
docker info | grep Logging
```

5. This command should return a line that says:

```bash
Logging Driver: syslog
```

6. Configure Docker to start on boot:

```bash
sudo systemctl enable docker.service
```

7. Configure the containerd service to start on boot:

```bash
sudo systemctl enable containerd.service
```

## Conclusion

Congratulations! You have successfully completed this hands-on lab.
