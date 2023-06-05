# Docker installation bash script

This bash script automates the installation of Docker CE on Ubuntu-based systems. By running this script, you can easily install Docker along with the required packages and repository configurations.

## Usage

1. Copy the script content into a file, e.g., `install_docker.sh`.

2. Make the script executable by running the following command:

```bash
chmod +x install_docker.sh
```

3. Execute the script with root privileges using `sudo`:

```bash
sudo ./install_docker.sh
```

The script will update the package index, install the necessary packages, add the Docker GPG key, add the Docker repository, update the package index again, and finally install Docker CE on the system.

**Note**: Make sure to run the script on an Ubuntu-based system.