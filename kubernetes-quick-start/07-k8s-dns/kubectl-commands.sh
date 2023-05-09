#!/bin/bash

# Run 'kubectl get namespaces' and save output to file
echo "Running 'kubectl get namespaces' command..."
kubectl get namespaces > kubectl_namespaces.txt
echo "Command: kubectl get namespaces" >> kubectl_namespaces.txt
echo "Done."

# Run 'kubectl get pods' and save output to file
echo "Running 'kubectl get pods' command..."
kubectl get pods > kubectl_pods.txt
echo "Command: kubectl get pods" >> kubectl_pods.txt
echo "Done."

# Run 'kubectl exec -it <pod-name> /bin/bash' and save output to file
echo "Running 'kubectl exec -it <pod-name> /bin/bash' command..."
POD_NAME="<pod-name>"
kubectl exec -it $POD_NAME /bin/bash > kubectl_pod_shell.txt
echo "Command: kubectl exec -it $POD_NAME /bin/bash" >> kubectl_pod_shell.txt
echo "Done."

# Run 'cat /etc/resolv.conf' on the pod and save output to file
echo "Running 'cat /etc/resolv.conf' command on pod..."
cat /etc/resolv.conf > kubectl_pod_resolv_conf.txt
echo "Command: cat /etc/resolv.conf" >> kubectl_pod_resolv_conf.txt
echo "Done."
