# Docker Swarm Backup and Restore

## Table of Contents

- [Introduction](#introduction)
- [Backup](#backup)
- [Restore](#restore)
- [Relevant Documentation](#relevant-documentation)
- [Conclusion](#conclusion)

## Introduction

If you are managing a Docker Swarm cluster, it is important to know how to back up and restore your swarm data. This guide will walk you through the process of performing a simple backup and restore in a Docker Swarm cluster.

## Backup

To create a backup of your Docker Swarm data, follow these steps:

1. Log into your swarm manager.

2. Stop the Docker service temporarily to prevent any new data from being created. Run the following command:

```bash
sudo systemctl stop docker
```

3. Create a backup archive of the `/var/lib/docker/swarm` directory by running the following command:

```bash
sudo tar -zvcf backup.tar.gz -C /var/lib/docker/swarm
```

This command will compress and archive the entire contents of the `swarm` directory into a file named `backup.tar.gz`. You can choose a different name if desired.

4. Once the backup is created, start the Docker service again by running the following command:

```bash
sudo systemctl start docker
```

Your backup is now complete and ready to be used for restoration.

**Note:** For automated backups, you can incorporate the backup process into a shell script or a cron job. If you frequently shut down Docker on your swarm manager, consider having multiple swarm managers for high availability to avoid any downtime during the backup process.

## Restore

In case of a catastrophic event or the need to revert to a previous backup, you can restore your Docker Swarm data using the following steps:

1. Stop the Docker service on the swarm manager by running the following command:

```bash
sudo systemctl stop docker
```

2. Clear the contents of the `/var/lib/docker/swarm` directory to ensure no conflicting files remain. Run the command:

```bash
sudo rm -rf /var/lib/docker/swarm/*
```

This command will delete all files and subdirectories within the `swarm` directory, but not the directory itself.

3. Extract the backup contents into the `swarm` directory by running the following command:

```bash
sudo tar -zxvf backup.tar.gz -C /var/lib/docker/swarm/
```

This command will extract the backup archive (`backup.tar.gz`) into the `/var/lib/docker/swarm` directory.

4. Start the Docker service again by running the command:

```bash
sudo systemctl start docker
```

5. Docker Swarm will now use the restored data, and you can verify the status by running the command:

```bash
docker node ls
```


This command lists all the Docker nodes in your swarm cluster, confirming that the swarm is up and running.

## Relevant Documentation

For more information and detailed documentation on Docker Swarm backup and restore, refer to the [official Docker documentation](https://docs.docker.com/engine/swarm/admin_guide/#back-up-the-swarm).

## Conclusion

Congratulations! You have successfully backed up and restored your Docker Swarm data. By following these steps, you can ensure the safety and availability of your swarm cluster. Remember to regularly perform backups and store them securely. In case of any issues or disasters, you can rely on these backups to recover your swarm to a previous state.