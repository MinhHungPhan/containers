# SSH Key Setup for `launchpad` User on Docker Enterprise Servers

## Table of Contents

- [Introduction](#introduction)
- [Server Setup Guide](#server-setup-guide)
    - [Step 1: Generate SSH Key Pair](#step-1-generate-ssh-key-pair)
    - [Step 2: Create the `launchpad` User on Each Server](#step-2-create-the-launchpad-user-on-each-server)
    - [Step 3: Set Up SSH Keys for the `launchpad` User](#step-3-set-up-ssh-keys-for-the-launchpad-user)
    - [Step 4: Test SSH Access](#step-4-test-ssh-access)
    - [Step 5: Optionally Disable the User When Not in Use](#step-5-optionally-disable-the-user-when-not-in-use)
- [Relevant Documentation](#relevant-documentation)
- [Conclusion](#conclusion)

## Introduction

Setting up SSH keys for the `launchpad` user across all servers in a Docker Enterprise cluster is a crucial step for secure and efficient system administration. This README guides you through the process of generating an SSH key pair, creating a `launchpad` user with password-less sudo permissions, and configuring SSH access for seamless operation with Mirantis Launchpad.

## Server Setup Guide

### Step 1: Generate SSH Key Pair

1. **On your local machine**, open a terminal.

2. **Generate the SSH key pair** with the command:

```bash
ssh-keygen -t rsa -b 4096 -C "launchpad_key"
```

3. **Name the key pair** `launchpad_id` when prompted.

4. **Locate** the generated keys, `launchpad_id` and `launchpad_id.pub`, usually in your `~/.ssh` directory.

### Step 2: Create the `launchpad` User on Each Server

1. **SSH into each server** (UCP Manager, Worker Node, DTR Server) using a user with sudo privileges.

2. **Create the `launchpad` user** on each:

```bash
sudo adduser launchpad
```

3. **Set up password-less sudo access**:

- Edit the sudoers file:

```bash
sudo visudo
```

- Add the following line to grant `launchpad` user full sudo access without a password:

```
launchpad ALL=(ALL) NOPASSWD: ALL
```

- Save and exit the editor.

### Step 3: Set Up SSH Keys for the `launchpad` User

1. **On your local machine**, display the public key:

```bash
cat ~/.ssh/launchpad_id.pub
```

- **Copy the content** of the `launchpad_id.pub` file.

2. **On each server**:

- Switch to the `launchpad` user:

```bash
sudo su - launchpad
```

- Create the SSH directory:

```bash
mkdir ~/.ssh && chmod 700 ~/.ssh
```

- Add the public key to authorized keys:

```bash
echo "<public_key_content>" >> ~/.ssh/authorized_keys
chmod 600 ~/.ssh/authorized_keys
```

- Replace `<public_key_content>` with the actual content of the public key.

### Step 4: Test SSH Access

- **From your local machine**, test SSH access to each server with the `launchpad` user:

```bash
ssh -i ~/.ssh/launchpad_id launchpad@<server-ip>
```

- Replace `<server-ip>` with the IP of each server (UCP Manager, Worker Node, DTR Server).

### Step 5: Optionally Disable the User When Not in Use

- To **disable the `launchpad` user** when not in use, run:

```bash
sudo usermod --expiredate 1 launchpad
```

- To **reenable the user**, set a future expiration date or clear it:

```bash
sudo usermod --expiredate "" launchpad
```

## Relevant Documentation

- [SSH Key Generation](https://www.ssh.com/ssh/keygen/)
- [Mirantis Launchpad Documentation](https://docs.mirantis.com/mke/3.7/launchpad.html)
- [Docker Enterprise Documentation](https://docs.docker.com/ee/)

## Conclusion

You've successfully set up the `launchpad` user with SSH key access and password-less sudo permissions on all your Docker Enterprise servers. This configuration allows Mirantis Launchpad to efficiently manage your Docker Enterprise cluster without password interruptions. Ensure to manage the `launchpad` user access securely, enabling it only as needed for administrative tasks.