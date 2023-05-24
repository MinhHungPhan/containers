# Deploying a Microservice Application to Kubernetes

## Introduction
Microservice applications can be quite complex but that complexity can offer many benefits. Kubernetes can help you take advantage of those benefits by making these complex infrastructures easier to manage through automation. In this hands-on lab, you will see the value of Kubernetes firsthand as you deploy a complex microservice architecture to the cluster and then independently scale some of its components.

## Solution

1. Begin by logging in to the lab server using SSH:
 ```bash
 ssh -i /path/to/private_key.pem username@PUBLIC_IP_ADDRESS
 ```
+ `-i /path/to/private_key.pem`: Specifies the path to the private key file associated with the key pair used when launching the EC2 instance. Replace `/path/to/private_key.pem` with the actual path to your private key file.
+ `username`: The username associated with the EC2 instance. The default `username` for Amazon Linux is `ec2-user`. For Ubuntu instances, it is `ubuntu`. For other distributions, refer to the specific documentation.

## Deploy the Stan's Robot Shop app to the cluster

1. Clone the Git repo that contains the pre-made descriptors:
 ```bash
 cd ~/
 git clone https://github.com/linuxacademy/robot-shop.git
 ```
2. Since this application has many components, it is a good idea to create a separate namespace for the app:
 ```bash
 kubectl create namespace robot-shop
 ```
3. Deploy the app to the cluster:
 ```bash
 kubectl -n robot-shop create -f ~/robot-shop/K8s/descriptors/
 ```
4. Check the status of the application's pods:
 ```bash
 kubectl get pods -n robot-shop
 ```
5. You should be able to reach the robot shop app from your browser using the Kube master node's public IP:
 ```bash
 http://$kube_master_public_ip:30080
 ```
## Scale up the MongoDB deployment to two replicas instead of just one

1. Edit the deployment descriptor:
 ```bash
 kubectl edit deployment mongodb -n robot-shop
 ```
2. You should see some YAML describing the deployment object.

- Under `spec:`, look for the line that says `replicas: 1` and change it to `replicas: 2`.
- Save and exit.

3. Check the status of the deployment with:
 ```bash
 kubectl get deployment mongodb -n robot-shop
 ```
After a few moments, the number of available replicas should be 2.
 ```bash
NAME      DESIRED   CURRENT   UP-TO-DATE   AVAILABLE   AGE
mongodb   2         2         2            2           9m6s
 ```
## Conclusion
Congratulations — you've completed this hands-on lab!