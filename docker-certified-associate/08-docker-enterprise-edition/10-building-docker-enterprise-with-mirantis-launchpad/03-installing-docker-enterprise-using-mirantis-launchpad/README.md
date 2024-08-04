# Building a Docker Enterprise Infrastructure with Mirantis Launchpad

## Table of Contents

- [Introduction](#introduction)
- [Prerequisites](#prerequisites)
- [Learning Objectives](#learning-objectives)
- [Setup Instructions](#setup-instructions)
   - [Install Mirantis Launchpad](#install-mirantis-launchpad)
   - [Generate Certificates for DTR](#generate-certificates-for-dtr)
   - [Create the Cluster](#create-the-cluster)
- [Relevant Documentation](#relevant-documentation)
- [Conclusion](#conclusion)

## Introduction

Welcome to the world of Docker Enterprise, a robust platform for orchestrating container applications. This guide aims to simplify the process of setting up a Docker Enterprise cluster using Mirantis Launchpad. Whether you are a beginner or an experienced user, this tutorial will walk you through building a multi-server Docker EE cluster in a structured and comprehensible manner.

## Prerequisites

Before diving into the setup, ensure that you have:
- Basic understanding of Docker and containerization.
- Access to a multi-server environment where Docker EE will be installed.
- Familiarity with command-line operations and YAML file editing.

## Learning Objectives

By the end of this tutorial, you will:
- Install Mirantis Launchpad on a server.
- Generate necessary certificates for Docker Trusted Registry (DTR).
- Successfully create and configure a three-node Docker Enterprise cluster.

## Setup Instructions

### Install Mirantis Launchpad

1. **Download and Install**:

Download Mirantis Launchpad onto the UCP Manager server using the command:

```bash
wget https://github.com/Mirantis/launchpad/releases/download/0.14.0/launchpad-linux-x64
```

Rename the downloaded file to 'launchpad' and make it executable:

```bash
mv launchpad-linux-x64 launchpad
chmod +x launchpad
```

To verify the installation, check the Launchpad version:

```bash
./launchpad version
```

2. **Register the Cluster**:

Start the registration process with:

```bash
./launchpad register
```

Follow the prompts to input your details and accept the license agreement.

```bash
Name John Phan
Email john.phan@kientree.com
Company Kien Tree
I agree to Mirantis Launchpad Software Evaluation License Agreement https://github.com/Mirantis/launchpad/blob/master/LICENSE Yes
```

### Generate Certificates for DTR

Utilize OpenSSL to generate a Certificate Authority (CA) and server certificates. This is crucial for the security of your Docker Trusted Registry. Follow these steps:
- Generate a CA key and certificate.
- Create a server key and certificate signing request (CSR).
- Define certificate extension values for server authentication.
- Generate the server certificate using the CA certificate and key.

#### Generate a CA key and certificate.

To generate a Certificate Authority (CA) key and certificate as outlined in the provided content, you need to follow these steps:

1. **Generate a CA Key**:

Open a terminal and run the following OpenSSL command to create a new private key for your CA. This key is used to sign the Docker Trusted Registry (DTR) certificates. The command generates a 4096-bit RSA key, which is considered secure for most purposes.

```bash
openssl genrsa -out ca.key 4096
```

2. **Generate the CA Certificate**:

After generating the CA key, the next step is to create a self-signed CA certificate. This certificate will be used to sign the public key of your Docker Trusted Registry. Use the following command to generate the certificate:

```bash
openssl req -x509 -new -nodes -key ca.key -sha256 -days 1024 -subj "/OU=dtr/CN=DTR CA" -out ca.crt
```

Here's what this command does:
- `req -x509`: This tells OpenSSL to create a self-signed certificate.
- `-new`: Generates a new certificate request.
- `-nodes`: Creates an unencrypted private key, which is necessary for automated processes.
- `-key`: Specifies the CA key file generated in the first step.
- `-sha256`: Uses the SHA-256 hashing algorithm, which is a secure choice for certificate signing.
- `-days 1024`: Sets the certificate to be valid for 1024 days. You can adjust this value based on your requirements.
- `-subj "/OU=dtr/CN=DTR CA"`: Sets the subject of the certificate. In this case, it specifies the Organizational Unit (OU) as 'dtr' and the Common Name (CN) as 'DTR CA'. This can be modified to match your organizational naming conventions.
- `-out ca.crt`: Specifies the filename for the generated certificate.

3. **Verify the CA Key and Certificate**:

After generating the key and certificate, you should verify that they have been created successfully. Use the `ls` command to list the files in your current directory and ensure `ca.key` and `ca.crt` are present:

```bash
ls
```

To view the contents of the generated CA certificate, you can use the `cat` command:

```bash
cat ca.crt
```

These steps will generate the necessary CA key and certificate required for setting up Docker Trusted Registry as part of your Docker Enterprise infrastructure. Remember to keep the CA key (`ca.key`) secure, as it is a critical component of your certificate authority.

#### Create a server key and certificate signing request (CSR)

Creating a server key and a Certificate Signing Request (CSR) for your Docker Trusted Registry (DTR) involves two main steps:

1. **Generate a Server Private Key**:

The first step is to create a private key for the DTR server. This key is used to generate and sign the server's CSR, and later, to secure communications to and from the DTR server. Use OpenSSL to generate this key with the following command:

```bash
openssl genrsa -out dtr.key 2048
```

Here, `2048` specifies the size of the key in bits. A 2048-bit key size is generally considered secure and provides a good balance between security and performance.

2. **Generate a Certificate Signing Request (CSR)**:

Once you have the server's private key, the next step is to create a CSR. The CSR contains information like the organization's name and the server's domain name (Common Name), which will be included in the server's certificate. To generate the CSR, use this command:

```bash
openssl req -new -sha256 -key dtr.key -subj "/OU=dtr/CN=system:dtr" -out dtr.csr
```

The breakdown of the command is as follows:
- `req -new`: This tells OpenSSL you want to create a new certificate request.
- `-sha256`: This specifies the use of the SHA-256 hashing algorithm, which is currently considered secure.
- `-key dtr.key`: This designates the use of the private key file created in the first step.
- `-subj "/OU=dtr/CN=system:dtr"`: This sets the subject field for the CSR. It includes the Organizational Unit (OU) and the Common Name (CN). The CN typically includes the fully qualified domain name (FQDN) of the server for which the certificate is intended. In this case, it's represented as `system:dtr`.
- `-out dtr.csr`: This specifies the filename for the generated CSR.

3. **Verify the Server Key and CSR**:

After generating the key and CSR, ensure they are created successfully:

```bash
ls
```

This command lists the files in the current directory, and you should see `dtr.key` and `dtr.csr` among them. To view the contents of the CSR, you can use the `cat` command:

```bash
cat dtr.csr
```

These steps complete the generation of the server key and the CSR, which are crucial for securing your Docker Trusted Registry in the Docker Enterprise environment. The CSR will then be used to generate a server certificate, signed by the CA created in the previous steps.

#### Define certificate extension values for server authentication

Defining certificate extension values for server authentication is a critical step in creating a secure communication channel for your Docker Trusted Registry (DTR). These extensions specify the ways in which the certificate can be used. Here's how you do it based on the provided content:

1. **Create a Certificate Extension File**:

First, you need to create a configuration file that will contain the certificate extension values. This is typically done using a text editor. The provided content suggests using `vi`, a common text editor in Unix-like systems.

Open the text editor with a new file named `extfile.cnf`:

```bash
vi extfile.cnf
```

2. **Add Extension Values to the File**:

In the text editor, input the following extension values. These values determine the usage of your server certificate:

```bash
keyUsage = critical, digitalSignature, keyEncipherment
basicConstraints = critical, CA:FALSE
extendedKeyUsage = serverAuth, clientAuth
subjectAltName = IP:<DTR_PUBLIC_IP_SERVER>, IP:10.0.1.103,IP:127.0.0.1
```

Here is what each line signifies:
- `keyUsage`: Specifies how the key can be used. `digitalSignature` is used for verifying digital signatures. `keyEncipherment` allows the key to encrypt session keys.
- `basicConstraints`: Defines whether the certificate is for a CA. `CA:FALSE` indicates this certificate is not for a CA.
- `extendedKeyUsage`: This extension indicates additional purposes for which the certificate public key can be used. Here it includes server authentication (`serverAuth`) and client authentication (`clientAuth`).
- `subjectAltName`: Lists the alternative names for which the certificate is valid. It typically includes IP addresses and domain names. Replace `<DTR_PUBLIC_IP_SERVER>` with the actual public IP address of your DTR server.

3. **Save and Exit the File**:

After entering the extension values:
- To save and exit in `vi`, press `Esc`, then type `:wq` and press `Enter`.

4. **Verify the Configuration File**:

Ensure that the `extfile.cnf` file has been created and contains the correct information. Use the `cat` command to view its contents:

```bash
cat extfile.cnf
```

Creating and configuring this certificate extension file is essential for generating a server certificate with the correct usage parameters, ensuring secure and authenticated communications for your Docker Trusted Registry.

#### Generate the server certificate using the CA certificate and key

To generate the server certificate for your Docker Trusted Registry (DTR) using the Certificate Authority (CA) certificate and key, follow these steps based on the provided content:

1. **Generate the Server Certificate**:

Now that you have your CA certificate (`ca.crt`), CA key (`ca.key`), and the Certificate Signing Request (CSR) for the server (`dtr.csr`), along with the certificate extension file (`extfile.cnf`), you can generate the server certificate. Use the following OpenSSL command:

```bash
openssl x509 -req -in dtr.csr -CA ca.crt -CAkey ca.key -CAcreateserial -out dtr.crt -days 365 -sha256 -extfile extfile.cnf
```

Here's what each part of the command does:
- `x509`: This is the OpenSSL command used for displaying and managing X.509 certificates.
- `-req`: Indicates that you are using a CSR to generate the certificate.
- `-in dtr.csr`: Specifies the input file, which is your CSR.
- `-CA ca.crt`: Specifies the CA certificate to sign the CSR.
- `-CAkey ca.key`: Designates the CA private key to sign the CSR.
- `-CAcreateserial`: Tells OpenSSL to create a serial number file if one doesn't already exist. This is important for keeping track of certificates issued by the CA.
- `-out dtr.crt`: Specifies the output file for the generated server certificate.
- `-days 365`: Sets the validity period of the certificate to 365 days. You can adjust this duration based on your requirements.
- `-sha256`: Uses the SHA-256 hashing algorithm for signing the certificate.
- `-extfile extfile.cnf`: Includes the certificate extension file you created earlier, which specifies how the certificate can be used.

2. **Verify the Server Certificate**:

After generating the server certificate, verify its creation by listing the files in your directory:

```bash
ls
```

You should see `dtr.crt` among the listed files. To view the contents and details of the certificate, use the command:

```bash
openssl x509 -in dtr.crt -text -noout
```

This command displays the details of the certificate, including the issuer, validity period, and extensions.

By completing these steps, you have successfully generated a server certificate for your Docker Trusted Registry, signed by your own Certificate Authority. This certificate is a crucial component for secure communications in your Docker Enterprise setup.

### Create the Cluster

#### Configure Cluster YAML File

Configuring the cluster YAML file is a key step in setting up your Docker Enterprise cluster using Mirantis Launchpad. This file defines the configuration of your Docker Enterprise cluster, including the Universal Control Plane (UCP), Docker Trusted Registry (DTR), and the nodes in your cluster. Here's how to do it based on the provided content:

1. **Create the Cluster Configuration File**:

First, you need to create a new file named `cluster.yaml`. This file will contain the configuration for your Docker Enterprise cluster. You can use a text editor like `vi` for this purpose:

```bash
vi cluster.yaml
```

2. **Edit the Configuration File**:

In the text editor, enter the configuration details for your cluster. Here's an example template based on the provided content. You'll need to replace certain values with those specific to your setup, such as IP addresses and certificate contents.

```yaml
apiVersion: launchpad.mirantis.com/v1beta3
kind: DockerEnterprise
metadata:
    name: launchpad-ucp
spec:
    ucp:
    version: 3.3.2
    installFlags:
    - --admin-username=admin
    - --admin-password=secur1ty!
    - --default-node-orchestrator=kubernetes
    - --force-minimums
    dtr:
    version: 2.8.2
    installFlags:
    - --ucp-insecure-tls
    - |-
        --dtr-cert "<contents of dtr.crt>"
    - |-
        --dtr-key "<contents of dtr.key>"
    - |-
        --dtr-ca "<contents of ca.crt>"
    hosts:
    - address: 10.0.1.101
    privateInterface: ens5
    role: manager
    ssh:
        user: launchpad
        keyPath: ~/launchpad_id
    - address: 10.0.1.102
    privateInterface: ens5
    role: worker
    ssh:
        user: launchpad
        keyPath: ~/launchpad_id
    - address: 10.0.1.103
    privateInterface: ens5
    role: dtr
    ssh:
        user: launchpad
        keyPath: ~/launchpad_id
```

In the `installFlags` section under `dtr`, replace `<contents of dtr.crt>`, `<contents of dtr.key>`, and `<contents of ca.crt>` with the actual contents of your `dtr.crt`, `dtr.key`, and `ca.crt` files. Ensure that the indentation is correct, as YAML is sensitive to whitespace.

3. **Save and Exit the File**:

After entering all the configuration details:
- To save and exit in `vi`, press `Esc`, then type `:wq` and press `Enter`.

4. **Verify the Configuration File**:

Once you have saved your `cluster.yaml` file, it's good practice to check it for any errors or omissions. You can view the contents of the file with:

```bash
cat cluster.yaml
```

By following these steps, you will have successfully configured the `cluster.yaml` file for your Docker Enterprise cluster setup using Mirantis Launchpad. This configuration file is crucial as it directs Launchpad on how to set up and manage your Docker Enterprise cluster.

#### Apply Configuration

To apply the configuration for setting up your Docker Enterprise cluster using Mirantis Launchpad, you'll need to execute a specific command that instructs Launchpad to read your `cluster.yaml` file and set up the cluster accordingly. Here's how you can do it based on the provided content:

1. **Navigate to the Directory Containing the Launchpad Executable and `cluster.yaml` File**:

Ensure that you are in the directory where both the `launchpad` executable file and your `cluster.yaml` file are located. You can use the `ls` command to verify their presence:

```bash
ls
```

2. **Execute the Launchpad Apply Command**:

Use the Launchpad tool to apply the configuration from your `cluster.yaml` file. This will initiate the setup of your Docker Enterprise cluster based on the specifications you defined. Run the following command:

```bash
./launchpad apply
```

This command tells Launchpad to read the `cluster.yaml` file and apply the configuration to set up the Docker Enterprise cluster. During this process, Launchpad will communicate with the specified servers, set up the Universal Control Plane (UCP), Docker Trusted Registry (DTR), and configure each node as defined in your YAML file.

3. **Monitor the Output**:

The `launchpad apply` command will produce output on the terminal, showing the progress of the cluster setup. Pay attention to this output for any errors or confirmation messages that indicate the process is proceeding correctly.

4. **Verify Cluster Setup**:

After the command completes, verify that the Docker Enterprise cluster is set up correctly. You can do this by accessing the UCP and DTR interfaces using their respective URLs, which are usually the IP addresses of the servers you've set up. Log in with the credentials you specified in the `cluster.yaml` file to confirm that both the UCP and DTR interfaces are operational.

By following these steps, you will have applied the configuration to your Docker Enterprise environment using Mirantis Launchpad, thereby establishing your cluster with the specified settings and components.

#### Access and Verify

To access and verify your Docker Enterprise cluster setup using Mirantis Launchpad, follow these steps based on the provided content:

1. **Access the Universal Control Plane (UCP)**:

- Open a web browser and navigate to the UCP instance. The URL is typically the public IP address of the UCP Manager server, accessed via HTTPS. The format should be: `https://<UCP_MANAGER_IP>`
- When accessing for the first time, your browser may warn you about the site's security certificate, especially if you're using a self-signed certificate. You might need to proceed with the warning or add an exception, depending on your browser.

2. **Log in to UCP**:

- On the UCP login page, enter the username and password you defined in your `cluster.yaml` file under the UCP section (`--admin-username` and `--admin-password`).
- After logging in, you should be able to see the UCP dashboard. Take a moment to explore and ensure that the interface is responsive and shows the expected cluster information.

3. **Verify UCP Functionality**:

- In the UCP dashboard, check the status of your nodes, services, and other resources to ensure everything is functioning as expected. 
- Optionally, try deploying a test application or service to further confirm that UCP is managing cluster resources correctly.

4. **Access Docker Trusted Registry (DTR)**:

- Similar to accessing UCP, open a new browser tab and navigate to the DTR interface. The URL is typically the public IP address of the DTR server, also accessed via HTTPS: `https://<DTR_SERVER_IP>`
- As with the UCP, you may encounter a security warning due to the self-signed certificate which can be bypassed as per your browser's instructions.

5. **Log in to DTR**:

- Use the same credentials as UCP (the ones specified in your `cluster.yaml` file) to log into DTR.
- Upon successful login, you should see the Docker Trusted Registry interface.

6. **Verify DTR Functionality**:

- In the DTR interface, check for the availability of repositories, images, and other registry components.
- Optionally, try pushing or pulling an image to/from the registry to confirm it's working correctly.

7. **Troubleshooting**:

- If you encounter issues accessing UCP or DTR, verify the IP addresses and ports are correct and that there are no network or firewall restrictions preventing access.
- Additionally, check the logs on the UCP and DTR servers for any error messages or clues on connectivity or configuration issues.

By following these steps, you should be able to access and verify the functionality of your newly set up Docker Enterprise cluster, ensuring that both UCP and DTR are operational and ready for further use.

## Relevant Documentation

- [Docker Enterprise Documentation](https://docs.docker.com/ee/)
- [Mirantis Launchpad GitHub Repository](https://github.com/Mirantis/launchpad)
- [OpenSSL Documentation](https://www.openssl.org/docs/)
- [YAML Syntax](https://yaml.org/spec/1.2/spec.html)

## Conclusion

Congratulations on successfully setting up your Docker Enterprise cluster with Mirantis Launchpad! You have taken a significant step in mastering Docker orchestration and management. Experiment with your setup to explore the extensive capabilities of Docker Enterprise.