# Docker Enterprise Cluster Setup on AWS EC2

## Table of Contents

- [Prerequisites](#prerequisites)
- [Launch EC2 Instances](#launch-ec2-instances)
   - [Create EC2 Instances](#create-ec2-instances)
   - [Instance Setup](#12-instance-setup)
   - [Allocate Elastic IPs](#13-allocate-elastic-ips)
- [Access Servers via SSH](#access-servers-via-ssh)
- [Access Servers via EC2 Instance Connect](#access-servers-via-ec2-instance-connect)
- [Create `cloud_user`](#create-cloud_user)
- [Setup a Password for `cloud_user`](#setup-a-password-for-cloud_user)
- [Conclusion](#conclusion)
- [References](#references)

## Introduction

This guide is specifically tailored for setting up three essential servers on Amazon EC2 instances running Ubuntu 18.04 Bionic Beaver LTS. These servers will form the foundational infrastructure for further deployments. We will focus on configuring one server as the Universal Control Plane (UCP) Manager, another as a Worker Node, and the third as the Docker Trusted Registry (DTR) Server. This setup is pivotal for those planning to establish a robust Docker Enterprise environment, laying the groundwork for a comprehensive Docker Enterprise cluster configuration in a separate process.

## Prerequisites

- AWS account with EC2 access.
- Basic knowledge of AWS EC2 and Docker.
- SSH client for remote server access.

## Launch EC2 Instances

### Create EC2 Instances

- Log in to your AWS Management Console.
- Navigate to EC2 Dashboard and click 'Launch Instance'.
- Choose 'Ubuntu Server 18.04 LTS (HVM), SSD Volume Type'.
- Select the appropriate instance type (e.g., `t2.medium` or higher) for each server.
- Configure instance details, add storage, and add tags as per your requirement.
- Configure a security group to allow inbound traffic on necessary ports:
  - Port 22 (SSH) for remote access.
  - Ports required by Docker Enterprise (Refer to Docker Enterprise documentation for the complete list of ports).

### Instance Setup

- Launch three instances in total, specifying their roles in the naming or tagging:
  - UCP Manager
  - Worker Node
  - DTR Server

### Allocate Elastic IPs

Allocating Elastic IPs in AWS for your EC2 instances is a crucial step to ensure that each server in your Docker Enterprise cluster has a static IP address. Here's how to allocate and associate Elastic IPs:

#### Step 1: Allocate Elastic IPs

1. **Log in to AWS Management Console**:

- Open your browser and log into your AWS Management Console.

2. **Navigate to the Elastic IPs Section**:

- In the AWS Management Console, go to the EC2 dashboard.
- In the navigation pane on the left, under "Network & Security", select "Elastic IPs".

3. **Allocate New Elastic IP**:

- Click on “Allocate Elastic IP address”.
- For the "Scope" option, leave it as the default value unless you have specific requirements.
- Click on "Allocate" to create a new Elastic IP.

4. **Repeat for Additional Servers**:

- Repeat the above steps to allocate a total of three Elastic IPs, one for each server (UCP Manager, Worker Node, and DTR Server).

#### Step 2: Associate Elastic IPs with EC2 Instances

1. **Select Elastic IP**:

- In the Elastic IPs page, select the newly allocated Elastic IP.

2. **Associate with EC2 Instance**:

- Click on “Actions” and then select “Associate Elastic IP address”.
- Choose the EC2 instance you want to associate the Elastic IP with (e.g., UCP Manager).
- Select the private IP of the instance to associate with the Elastic IP, if applicable.
- Click “Associate”.

3. **Repeat for Other Instances**:

- Repeat the process for each of the remaining EC2 instances (Worker Node and DTR Server).

#### Step 3: Verify Association

- After associating the Elastic IPs with the respective instances, verify the association:
   - Go back to the EC2 dashboard.
   - Select “Instances” to view your running instances.
   - Confirm that each instance now has the Elastic IP listed in its details.

## Access Servers via SSH

Accessing your servers via SSH (Secure Shell) is a key step in managing and configuring them, especially when they're hosted on platforms like AWS EC2. Here’s a step-by-step guide on how to do this:

### Step 1: Gather Your SSH Key and Server Information

- **SSH Key**: Ensure you have the private key file (`.pem` file) that corresponds to the EC2 instances. This key is generated when you first create your EC2 instance.
- **Server IP Addresses**: Note down the public IP addresses or Elastic IPs of your EC2 instances.

### Step 2: Set Permissions for Your Key File

- The private key file must have the correct permissions set to be used. Change its permissions with the following command:

```bash
chmod 400 /path/to/your-key.pem
```

- Replace `/path/to/your-key.pem` with the actual path to your key file.

### Step 3: Connect via SSH

- Use the SSH command to connect to your server. The general format is:

```bash
ssh -i /path/to/your-key.pem ubuntu@<server-ip>
```

- Replace `/path/to/your-key.pem` with your key file path and `<server-ip>` with your server's public IP address.
- The username is typically `ubuntu` for Ubuntu servers.

### Step 4: Verify the Connection

- Once connected, you should be at the command prompt of your EC2 instance.
- If you encounter any errors, verify that the IP address is correct and that your EC2 instance is running.

### Step 5: Repeat for Other Servers

- Repeat the above steps to connect to each server (UCP Manager, Worker Node, and DTR Server) using their respective IP addresses.

### Tips for Troubleshooting

- **Permission Denied Error**: This usually indicates a problem with the key file permissions or incorrect username.
- **Connection Timeout**: Check your EC2 instance’s security group rules to ensure that SSH (port 22) access is allowed from your IP address.

## Access Servers via EC2 Instance Connect

Accessing your AWS EC2 instances via EC2 Instance Connect provides a convenient and secure way to connect to your instances directly from the AWS Management Console without the need for additional SSH keys. Here's how to do it:

### Step 1: Ensure EC2 Instance Connect is Enabled

- **Check AMI Compatibility**: Ensure that your EC2 instances are using an Amazon Machine Image (AMI) that supports EC2 Instance Connect. Ubuntu 18.04 LTS is generally supported.
- **Security Group Configuration**: Make sure the security group associated with your EC2 instances allows inbound SSH traffic (port 22) from your IP address.

### Step 2: Open AWS Management Console

- **Log in to AWS**: Go to the AWS Management Console and log in with your credentials.

### Step 3: Navigate to Your EC2 Dashboard

- **Access EC2 Dashboard**: Once logged in, navigate to the EC2 dashboard.

### Step 4: Select the Instance

- **Choose the Instance**: In the “Instances” section, find and select the EC2 instance you wish to connect to.

### Step 5: Connect Using EC2 Instance Connect

- **Open EC2 Instance Connect**: With the instance selected, click on the “Connect” button at the top of the page.
- **Choose Connection Method**: In the connect dialog, ensure that “EC2 Instance Connect” is the chosen method.
- **Specify Username**: Enter the username for your instance; for Ubuntu, the default username is usually ‘ubuntu’.
- **Connect**: Click on “Connect”.

### Step 6: Use the Browser-based SSH Client

- **SSH Session**: A new browser tab or window will open with an SSH session connected to your instance. This is a browser-based terminal that you can use to run commands on your EC2 instance.

### Notes

- **Instance Connect Limitations**: EC2 Instance Connect provides a browser-based SSH terminal, but it might not have all the features of a dedicated SSH client.
- **Browser Requirements**: Ensure that your web browser is compatible with EC2 Instance Connect. Most modern browsers should work without issues.
- **Session Duration**: SSH sessions through EC2 Instance Connect are temporary. If you need longer sessions, consider using a traditional SSH client.

## Create `cloud_user`

Creating a new user, such as `cloud_user`, on all three of your servers (UCP Manager, Worker Node, and DTR Server) can be done using standard Linux commands. Follow these steps on each server:

### Step 1: Connect to Your Server

- Use EC2 Instance Connect, SSH, or your preferred method to connect to your first EC2 server. Repeat these steps for each server.

### Step 2: Create a New User

- Once connected, use the `adduser` command to create a new user named `cloud_user`:

```bash
sudo adduser cloud_user
```

- You will be prompted to set a password for the new user and optionally fill in additional information. It's important to choose a strong password, especially if this user will have administrative privileges.

### Step 3: Grant Sudo Privileges (Optional)

- If this user needs administrative privileges (to execute commands that require superuser access), add `cloud_user` to the `sudo` group:

```bash
sudo usermod -aG sudo cloud_user
```

- Being in the `sudo` group allows `cloud_user` to run commands with `sudo`, granting administrative access when needed.

### Step 4: Verify the User Creation

- To verify that the user has been created successfully, you can switch to the new user account:

```bash
su - cloud_user
```

- If you granted `sudo` privileges, test them by running a command that requires superuser access, like `sudo ls /root`.

### Step 5: Set Up SSH Access for cloud_user (Optional)

- If you need to set up SSH key-based authentication for `cloud_user`:

1. On your local machine, generate an SSH key pair if you don't already have one:

```bash
ssh-keygen -t rsa
```

2. Copy the public key to the server. You can use `ssh-copy-id`:

```bash
ssh-copy-id cloud_user@<server-ip>
```

3. On the server, ensure the SSH directory permissions are correctly set:

```bash
sudo chmod 700 /home/cloud_user/.ssh
sudo chmod 600 /home/cloud_user/.ssh/authorized_keys
sudo chown -R cloud_user:cloud_user /home/cloud_user/.ssh
```

### Step 6: Repeat for Each Server

- Repeat the above steps for each of the remaining servers (UCP Manager, Worker Node, and DTR Server).

## Setup a Password for `cloud_user`

Setting up a password for a user, like `cloud_user`, on your Linux server is a straightforward process. Here are the steps to follow:

### Step 1: Connect to Your Server

- First, connect to your server via SSH. If you're working with AWS EC2 instances, use the command:

```bash
ssh -i /path/to/your-key.pem ubuntu@<server-ip>
```

- Replace `/path/to/your-key.pem` with the path to your SSH key and `<server-ip>` with the IP address of your server.

### Step 2: Switch to the Root User (Optional)

- If you're not logged in as the root user or a user with `sudo` privileges, switch to the root user for ease of management:

```bash
sudo su
```

- This step is optional but can be helpful if you're performing multiple administrative tasks.

### Step 3: Set or Update the User's Password

- Use the `passwd` command to set or update the password for `cloud_user`:

```bash
passwd cloud_user
```

- You will be prompted to enter and confirm the new password. Choose a strong, secure password.

### Step 4: Follow the Prompts

- After entering the `passwd` command, you'll be asked to enter the new password and then to retype it for confirmation.

### Step 5: Ensure Password Strength

- It's important to use a strong password that combines letters, numbers, and special characters. Avoid common words or easy-to-guess combinations.

### Step 6: Exit Root User (If Used)

- If you switched to the root user, exit back to your normal user:

```bash
exit
```

### Step 7: Test the New Password

- To test the new password, switch to `cloud_user`:

```bash
su - cloud_user
```

- You'll be prompted for the password. Enter the new password you just set.

### Step 8: Repeat for Each Server

- If you need to set up a password for `cloud_user` on multiple servers (like UCP Manager, Worker Node, and DTR Server), repeat these steps on each server.

## Conclusion

Well done! You have successfully set up the foundational servers on AWS EC2 with Ubuntu 18.04 Bionic Beaver LTS. Each server, designated as the UCP Manager, Worker Node, and DTR Server, is now ready for the next stage of your infrastructure development. This setup is a crucial step towards building a fully-functional Docker Enterprise environment. You can now proceed to the specific configurations and installations required for Docker Enterprise in your subsequent setup stages.

## References

- [Docker Enterprise Documentation](https://docs.docker.com/ee/)
- [AWS EC2 Documentation](https://docs.aws.amazon.com/ec2/index.html)
- [Ubuntu 18.04 Documentation](https://ubuntu.com/server/docs)