
# Installing Docker

## Introduction 
The first step in setting up a new cluster is to install a container runtime such as Docker. In this tutorial, we will be installing Docker on our three servers in preparation for standing up a Kubernetes cluster. After completing this lesson, you should have three playground servers, all with Docker up and running.

## Commands

Here are the commands used in this tutorial:

This command retrieves the GPG key for the Docker repository and adds it to the system's package manager keyring:
```bash
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
```

This command adds the Docker repository to the system's package repositories:
```bash
sudo add-apt-repository \
"deb [arch=amd64] https://download.docker.com/linux/ubuntu \
$(lsb_release -cs) \
stable"
```

This command updates the local package list or index on a Linux system:
```bash
sudo apt-get update
```

This command installs the specified version of Docker Community Edition:
```bash
sudo apt-get install -y docker-ce=18.06.1~ce~3-0~ubuntu
```

This command marks the installed Docker package as "held," preventing automatic upgrades:
```bash
sudo apt-mark hold docker-ce
```

You can verify that docker is working by running this command:

```bash
sudo docker version
```