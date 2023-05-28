
# Storage Drivers

## Introduction
Welcome to this tutorial on storage drivers. In this guide, we will discuss storage drivers, which are a pluggable framework for managing the temporary internal storage of a container's writable layer. When you have software inside your container that writes files or data to the disk without using mounted volumes or external storage, it is stored in the container's internal storage.

The way we manage this internal storage depends on the storage driver we use. Docker provides a storage driver framework that offers various options for managing storage. This flexibility allows Docker to support multiple operating systems and environments since certain storage methods work only on specific environments.

The variety of environments and use cases in which Docker can be used means that there are a variety of storage needs.
Container storage can be implemented in multiple ways through the use of various storage drivers, and those provide a pluggable framework for using different kinds of container storage.

The choice of storage driver depends on your environment, specific use cases, and storage requirements. You can refer to the documentation for information on compatible storage drivers and the complete list of supported drivers. However, for now, let's focus on two important drivers: `overlay2` and `devicemapper`.

## Overlay2 and Devicemapper
Overlay2 is the default storage driver for both Ubuntu and CentOS 8 and newer versions. It provides file-based storage. On the other hand, CentOS 7 and earlier versions use devicemapper as the default storage driver, which provides block storage.

The differences between file-based storage and block storage are beyond the scope of this guide. Generally, if you primarily perform reading operations, overlay2 is suitable. It works well for most cases. However, if you have a specific scenario involving extensive writing to the disk, devicemapper might perform better.

To determine your current storage driver, you can use the `docker info` command. Executing this command will display various details about your Docker setup, including the storage driver. For example, if you see "Storage Driver: devicemapper" in the output, it means the current driver is devicemapper.

## Explicitly Setting the Storage Driver
If you need to change the storage driver, you can do so explicitly. We will demonstrate how to override the storage driver by explicitly defining it using the devicemapper driver as an example.

There are two ways to explicitly set the storage driver: by passing a flag to the Docker daemon or by modifying the Docker daemon's configuration file.

1. Passing a Flag to the Docker Daemon:
To set the storage driver as a flag when calling the Docker daemon, you can modify the systemd unit file for the Docker daemon. The unit file location is `user/lib/systemd/system/docker.service`. Open this file and add the storage driver flag, `-s devicemapper`, to the command that starts the Docker daemon.

Save the file, reload the systemd daemon configuration using `sudo systemctl daemon-reload`, and restart the Docker service with `sudo systemctl restart docker`. Running `docker info` will confirm that the storage driver is now set to devicemapper.

Although this method works, it is not the recommended way to set the storage driver. Therefore, we will revert the changes made in this step before proceeding to the next method.

2. Modifying the Daemon Configuration File:
The recommended way to set the storage driver is by modifying the Docker daemon's configuration file. This file is located at `etc/docker/daemon`.json. If the file doesn't exist, create it.

Edit the `daemon.json` file, ensuring the contents are valid JSON. Add the following configuration to set the storage driver explicitly:

```bash
{
  "storage-driver": "devicemapper"
}
```
Save the file and restart the Docker service with `sudo systemctl restart docker`. Running `docker info` will confirm that the storage driver is set to devicemapper.

Using the daemon configuration file (`daemon.json`) is preferred because it provides a standardized method that works consistently across different environments. Unit files and other ways of setting flags on the daemon can vary between environments.

## Relevant Documentation
https://docs.docker.com/storage/storagedriver/select-storage-driver/

## Tutorial Reference

This tutorial was performed on a CentOS 7 server running Docker CE

1. Get the current storage driver:
```bash
docker info
```
2. Set the storage driver explicitly by providing a flag to the Docker daemon:
```bash
sudo vi /usr/lib/systemd/system/docker.service
```
3. Edit the ExecStart line, adding the --storage-driver devicemapper flag:
```bash
ExecStart=/usr/bin/dockerd --storage-driver devicemapper ...
```
4. After any edits to the unit file, reload Systemd and restart Docker:
```bash
sudo systemctl daemon-reload
sudo systemctl restart docker
```
5. We can also set the storage driver explicitly using the daemon configuration file. This is the method that Docker recommends.
Note that we cannot do this and pass the `--storage-driver` flag to the daemon at the same time:
```bash
sudo vi /etc/docker/daemon.json
```
6. Set the storage driver in the daemon configuration file:
```bash
{
"storage-driver": "devicemapper"
}
```
7. Restart Docker after editing the file. It is also a good idea to make sure Docker is running properly after changing the
configuration file:
```bash
sudo systemctl restart docker
sudo systemctl status docker
```

## Conclusion
That concludes our tutorial on storage drivers. We have discussed the purpose of storage drivers, the importance of choosing the right driver based on your environment and use cases, and specifically looked at overlay2 and devicemapper as examples.