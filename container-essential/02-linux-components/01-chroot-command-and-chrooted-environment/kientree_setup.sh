#!/bin/bash

# Enter superuser mode
sudo su - << 'EOF'
# Create the /home/kientree directory
mkdir /home/kientree

# Add the napoleon user
useradd napoleon

# Create the bin and lib64 directories
mkdir /home/kientree/{bin,lib64}

# Copy the necessary binaries
cp /bin/bash /home/kientree/bin/bash
cp /bin/ls /home/kientree/bin/ls
cp /bin/cat /home/kientree/bin/cat

# Find the required libraries
libs=$(ldd /bin/bash /bin/ls /bin/cat | awk '{print $3}' | grep -v "^$")

# Copy the required libraries to /home/kientree/lib64
for lib in $libs; do
    cp $lib /home/kientree/lib64
done

# Create waterloo.txt file with the desired content
echo "There is no escape!" > /home/kientree/waterloo.txt

# Change the root directory to /home/kientree and run bash
chroot /home/kientree /bin/bash
EOF
