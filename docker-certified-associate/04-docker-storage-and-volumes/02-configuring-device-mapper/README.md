# Docker DeviceMapper Configuration

This guide is designed to help beginners navigate the process of configuring Docker's DeviceMapper storage driver. By the end of this walkthrough, you should have a clear understanding of how to setup and fully configure the DeviceMapper on your CentOS 7 server.


## Table of Contents

- [Introduction](#introduction)
- [Understanding DeviceMapper Modes](#understanding-devicemapper-modes)
- [Loop-LVM Mode vs Direct-LVM Mode](#loop-lvm-mode-vs-direct-lvm-mode)
- [Switching to direct-lvm mode](#switching-to-direct-lvm-mode)
- [Configuring direct-lvm](#configuring-direct-lvm)
- [Testing your Configuration](#testing-your-configuration)
- [Relevant Documentation](#relevant-documentation)
- [Conclusion](#conclusion)

## Introduction

In [the previous tutorial](/docker-certified-associate/04-docker-storage-and-volumes/01-docker-storage-deep-dive/README.md), we've discussed setting your Docker storage driver. Now, it's time to delve deeper into one specific storage driver: the DeviceMapper. The `DeviceMapper` is a default storage driver for CentOS 7 and earlier. Through this guide, we'll show you how to customize its configuration using the daemon config file.

## Understanding DeviceMapper Modes

DeviceMapper supports two different modes: `loop-lvm` and `direct-lvm`. By default, the `loop-lvm` mode is activated upon setting up the server.

You can check the current storage driver mode using the following command:

```bash
docker info
```

This command should output data that includes `Data file: /dev/loop0` and `Metadata file: /dev/loop1`, indicating that you are currently using the `loop-lvm` mode.

### Loop-LVM Mode

In loop-LVM mode, the loop devices are used as the underlying block devices for LVM. Loop devices are essentially virtual block devices that allow you to treat a regular file as a block device. LVM is then applied on top of these loop devices to create logical volumes.

`Loop-lvm` mode employs a loopback mechanism to simulate an additional physical disk using files on the local disk. This mode, while requiring minimal setup, isn't as efficient as it could be and is not recommended for a real production scenario.

**Use Cases**:
- Testing and experimentation: Loop-LVM mode is often used in testing environments or for experimenting with LVM functionality without modifying physical disks or partitions.
- Disk image management: Loop devices provide a convenient way to manage disk images, and using LVM on top of loop devices allows for flexible management of the virtual disks contained within those images.
- Encrypted volumes: Loop-LVM can be used to create encrypted volumes where the encrypted file is mounted as a loop device and LVM is applied on top to manage logical volumes within the encrypted container.

### Direct-LVM Mode

In direct-LVM mode, LVM operates directly on physical block devices (such as hard disks or SSDs) rather than using loop devices as an intermediate layer. This mode provides direct access to the underlying hardware and typically offers better performance compared to loop-LVM mode.

**Use Cases**:
- Production systems: Direct-LVM mode is commonly used in production environments where performance is a critical factor, as it eliminates the overhead introduced by the loop devices.
- Disk partitioning: When setting up a new system or configuring disks for optimal usage, direct-LVM is often preferred as it offers direct access to physical disks and their partitions.
- Storage area networks (SANs): Direct-LVM mode is typically used in SAN environments where high-performance block-level storage is required for virtualization platforms or database systems.

## Loop-LVM Mode vs Direct-LVM Mode

```plaintext
+-------------------+---------------------------------------------+------------------------------------------+
|                   | Loop-LVM Mode                               | Direct-LVM Mode                          |
+-------------------+---------------------------------------------+------------------------------------------+
| Setup             | Loopback mechanism simulates an additional  | Stores data on a separate device.        |
|                   | physical disk using files on the local disk.| Requires an additional storage device.   |
+-------------------+---------------------------------------------+------------------------------------------+
| Performance       | Bad performance, only use for testing.      | Good performance, use for production.    |
+-------------------+---------------------------------------------+------------------------------------------+
| Use Cases         | - Testing, experimentation                  | - Production systems                     |
|                   | - Disk image management                     | - Disk partitioning                      |
|                   | - Encrypted volumes                         | - Storage area networks (SANs)           |
+-------------------+---------------------------------------------+------------------------------------------+

                                            © Minh Hung Phan
```

## Switching to direct-lvm mode

If you are running a production server with Docker containers, it's better to use the `direct-lvm mode`. But to do that, you need to set up an additional storage device for your DeviceMapper block storage.

This process can be carried out in the cloud playground. Open your CentOS 7 server and click on `Actions`. Then, select `Add /dev/xvdb`. This option adds a new storage device. Wait for the addition to complete before proceeding.

## Configuring direct-lvm

With the additional storage device set up, it's time to configure Docker to use the `direct-lvm` mode.

1. Stop and disable Docker to prevent any interference with your setup:

```bash
sudo systemctl disable docker
sudo systemctl stop docker
```

2. Delete all Docker data to ensure a clean slate:

```bash
sudo rm -rf /var/lib/docker
```

3. Edit your `daemon.json` file (`etc/docker/daemon.json`) to explicitly set the storage driver to `devicemapper` and provide a series of storage options:

```json
{
    "storage-driver": "devicemapper",
    "storage-opts": [
        "dm.directlvm_device=/dev/xvdb",
        "dm.thinp_percent=95",
        "dm.thinp_metapercent=1",
        "dm.thinp_autoextend_threshold=80",
        "dm.thinp_autoextend_percent=20",
        "dm.directlvm_device_force=true"
    ]
}
```

Let's breakdown the above settings:

- `"dm.directlvm_device=/dev/xvdb"`: This line specifies the block device to use for the DeviceMapper storage.

- `"dm.thinp_percent=95"`: This indicates that 95% of the total block device size is allocated for storage provisioning.

- `"dm.thinp_metapercent=1"`: This specifies that 1% of the total block device size is allocated for storing metadata.

- `"dm.thinp_autoextend_threshold=80"`: When the data or metadata storage usage reaches 80%, LVM automatically extends it.

- `"dm.thinp_autoextend_percent=20"`: This tells LVM to increase the data or metadata storage by 20% each time it hits the auto-extend threshold.

- `"dm.directlvm_device_force=true"`: This option allows Docker to use the device, even if there's existing data on it.

4. Save your changes and exit the text editor.

5. Restart Docker:

```bash
sudo systemctl enable docker
sudo systemctl start docker
```

## Testing your Configuration

Let's verify that your changes have taken effect.

1. Run the `docker info` command:

```bash
docker info
```

2. Look for the `Storage Driver` line, which should say `devicemapper`.

3. The `Pool Name` should show `docker-thinpool`, and the `Data file` and `Metadata file` lines should no longer appear.

This confirms that you are now using the `direct-lvm` mode.

4. Let's ensure our configuration is working as expected. Run the following command:

```bash
docker run hello-world
```

This command will pull the hello-world image and run it in a container. If it runs successfully, it means your storage is working and you've successfully configured DeviceMapper to use `direct-lvm` mode.

## Relevant Documentation

For more details, you can refer to the following documents:

- [Docker storage drivers](https://docs.docker.com/storage/storagedriver/)
- [Use the Device Mapper storage driver](https://docs.docker.com/storage/storagedriver/device-mapper-driver/)

## Conclusion

Congratulations! You have successfully configured Docker to use the DeviceMapper storage driver in `direct-lvm` mode on your CentOS 7 server. With this guide, you can configure the DeviceMapper storage driver with ease and optimize your Docker environment for production workloads.

