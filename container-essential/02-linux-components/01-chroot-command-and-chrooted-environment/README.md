# Chroot Command and Chrooted Environments

## Table of Contents

- [Introduction](#introduction)
- [Key Concepts](#key-concepts)
- [Demo Steps](#demo-steps)
- [Usage](#usage)
- [Tutorial Reference](#tutorial-reference)
- [Relevant Documentation](#relevant-documentation)
- [Conclusion](#conclusion)

## Introduction

The chroot command changes the apparent root directory of a process, creating a chrooted environment with limited visibility of the system.

## Key Concepts

- Chrooted environments isolate files and directories, providing a restricted view of the system.
- Chrooting can be useful for creating containerized environments or restricting user access.
- The process involves creating a chrooted directory, adding necessary files and libraries, and configuring user permissions.
- A demonstration is provided for creating a chrooted environment named "kientree" with a user named "napoleon."
- Chrooting can be used to create restricted SSH environments for users.

## Demo Steps

1. Create a chrooted directory and necessary files.
2. Add user(s) to the chrooted environment.
3. Configure permissions and move required libraries.
4. Test the chrooted environment by logging in as the user.

## Usage

To try out chrooting, follow the steps provided in the demonstration. Keep in mind that additional libraries and commands may need to be added based on your specific requirements.

## Tutorial Reference

1. Create the `/home/kientree` directory:

```bash
mkdir /home/kientree
```

2. To check the existence of a directory that you've just created, you can use the `ls` command:

```bash
ls -ld /home/kientree
```

Expected output:

```bash
drwxr-xr-x. 4 root root 30 Nov 13 22:26 /home/kientree
```

3. Add the "Napoleon" user:

```bash
useradd napoleon
```

4. To check if a user has been successfully created on a Unix-like system, you can use the `id` command:

```bash
id napoleon
```

Expected output:

```bash
uid=1001(napoleon) gid=1001(napoleon) groups=1001(napoleon)
```

5. Create the `bin` and `lib64` directories:

```bash
mkdir /home/kientree/{bin,lib64}
```

**Note:** The `lib64` directory on a 64-bit Linux system is a place where the system stores 64-bit shared library files. Shared libraries are collections of programming and data that can be used by multiple programs simultaneously. This concept is similar to a library in the real world, which contains books that anyone can read.

6. To list the contents of the directory `/home/kientree`, you can use the `ls` command:

```bash
ls /home/kientree
```

Expected output:

```bash
bin  lib64
```

7. Copy the necessary binaries:

```bash
cp /bin/bash /home/kientree/bin/bash
cp /bin/ls /home/kientree/bin/ls
cp /bin/cat /home/kientree/bin/cat
```

8. Now let's list the contents of the directory `/home/kientree/bin`:

```bash
ls /home/kientree/bin/
```

Expected output:

```bash
bash  cat  ls
```

9. Find the required libraries:

```bash
libs=$(ldd /bin/bash /bin/ls /bin/cat | awk '{print $3}' | grep -v "^$")
```

Here's a breakdown of each part of the command:

- Use the `ldd` command to print the shared libraries required by each program or shared library specified on the command line.

```bash
ldd /bin/bash /bin/ls /bin/cat
```

This part of the command will generate a list of shared libraries for the executables `/bin/bash` (the shell), `/bin/ls` (list directory contents), and `/bin/cat` (concatenate and display files).

Expected output:

```bash
/bin/bash:
        linux-vdso.so.1 (0x00007fff845b3000)
        libtinfo.so.6 => /lib64/libtinfo.so.6 (0x00007f7a9fcec000)
        libc.so.6 => /lib64/libc.so.6 (0x00007f7a9fa00000)
        /lib64/ld-linux-x86-64.so.2 (0x00007f7a9fe87000)
/bin/ls:
        linux-vdso.so.1 (0x00007fff78779000)
        libselinux.so.1 => /lib64/libselinux.so.1 (0x00007f6d83a2c000)
        libcap.so.2 => /lib64/libcap.so.2 (0x00007f6d83a22000)
        libc.so.6 => /lib64/libc.so.6 (0x00007f6d83800000)
        libpcre2-8.so.0 => /lib64/libpcre2-8.so.0 (0x00007f6d83762000)
        /lib64/ld-linux-x86-64.so.2 (0x00007f6d83a83000)
/bin/cat:
        linux-vdso.so.1 (0x00007ffdd7feb000)
        libc.so.6 => /lib64/libc.so.6 (0x00007fdcad800000)
        /lib64/ld-linux-x86-64.so.2 (0x00007fdcadbc4000)
```

- Now execute the following command:

```bash
libs=$(ldd /bin/bash /bin/ls /bin/cat | awk '/=>/ {print $3} !/=>/ {print $NF}' | grep '^/lib64' | sort -u)
```

This command is a pipeline of several commands in Unix-like systems that ultimately provides a list of shared library dependencies for the specified binaries without any empty lines.

The final result of this entire command sequence is a list of paths to the shared libraries required by `/bin/bash`, `/bin/ls`, and `/bin/cat`, with each path listed on a separate line, and empty lines removed from the output.

Expected output:

```bash
/lib64/libtinfo.so.6
/lib64/libc.so.6
/lib64/libselinux.so.1
/lib64/libcap.so.2
/lib64/libc.so.6
/lib64/libpcre2-8.so.0
/lib64/libc.so.6
/lib64/ld-linux-x86-64.so.2
```

10. To check the value of the libs variable after executing the command, you can simply echo it in your terminal. You can do this by typing the following command:

```bash
echo "$libs"
```

11. Copy the required libraries to `/home/kientree/lib64`:

There are two methods to copy the necessary libraries:

**Method 1: Using `xargs` with `echo`**

This method is efficient for copying multiple files listed in a variable. Execute the following command:

```bash
echo "$libs" | xargs -I{} cp {} /home/kientree/lib64
```

In this command, `$libs` should contain the paths of the libraries to be copied, and `xargs` will process each path, using `cp` to copy the files to `/home/kientree/lib64`.

**Method 2: Direct Copy Command**

Alternatively, you can use a direct `cp` command to copy each library individually. This method is more transparent and easier to modify:

```bash
cp /lib64/libtinfo.so.6 \
   /lib64/libc.so.6 \
   /lib64/libselinux.so.1 \
   /lib64/libcap.so.2 \
   /lib64/libpcre2-8.so.0 \
   /lib64/ld-linux-x86-64.so.2 \
   /home/kientree/lib64/
```

12. Now let's list the contents of the directory `/home/kientree/lib64`:

```bash
ls /home/kientree/lib64
```

Expected output:

```bash
ld-linux-x86-64.so.2  libc.so.6  libcap.so.2  libpcre2-8.so.0  libselinux.so.1  libtinfo.so.6
```

13. Create the `waterloo.txt` file with the desired content:

```bash
echo "There is no escape!" > /home/kientree/waterloo.txt
```

14. Change the root directory to `/home/kientree` and run Bash:

```bash
cd /home/kientree
chroot /home/kientree/ /bin/bash
```

15. Confirm commands work:

- Using the command `pwd`, confirm the present working directory and then confirm that you can use the `ls` command:

```bash
pwd
ls
```

- View the contents of `waterloo.txt` and find out how to escape your environment:

```bash
cat waterloo.txt
```

- Try the command `vi` and confirm it doesn't work:

```bash
vi waterloo.txt
```

Expected output:

```bash
bash: vi: command not found
```

## Relevant Documentation

- [chroot - Change the root directory for the execution of a command](https://www.ibm.com/docs/en/zos/2.3.0?topic=descriptions-chroot-change-root-directory-execution-command)

## Conclusion

Chrooting provides a way to create isolated and container-like environments. By following the above steps, you will have successfully created a chrooted environment for the "Napoleon" user. This environment restricts access to specific binaries and libraries, providing a limited view of the system. Feel free to modify the steps according to your requirements and explore further possibilities with chrooted environments.