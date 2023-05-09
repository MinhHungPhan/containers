#!/bin/bash

# Get the CoreDNS pod name
echo "Getting the CoreDNS pod name..."
COREDNS_POD=$(kubectl get pods -n kube-system -l k8s-app=kube-dns -o name | cut -d / -f 2)
echo "Done. CoreDNS pod name is ${COREDNS_POD}"

# Get the CoreDNS service IP
echo "Getting the CoreDNS service IP..."
COREDNS_SERVICE_IP=$(kubectl get svc -n kube-system kube-dns -o jsonpath='{.spec.clusterIP}')
echo "Done. CoreDNS service IP is ${COREDNS_SERVICE_IP}"

# Get the DNS search domain
echo "Getting the DNS search domain..."
DNS_SEARCH=$(kubectl get configmap -n kube-system kube-dns -o jsonpath='{.data.dns\.config}' | grep search | awk '{print $2}')
if [ -z "$DNS_SEARCH" ]; then
    echo "Error: DNS search domain not found."
else
    echo "Done. DNS search domain is ${DNS_SEARCH}"
fi

# Get the DNS server IP
echo "Getting the DNS server IP..."
DNS_SERVER=$(kubectl exec -n kube-system ${COREDNS_POD} -- cat /etc/resolv.conf | grep nameserver | awk '{print $2}')
if [ -z "$DNS_SERVER" ]; then
    echo "Error: DNS server IP not found."
else
    echo "Done. DNS server IP is ${DNS_SERVER}"
fi

# Output the results
echo "======================================="
echo "DNS Information in Kubernetes:"
echo "======================================="
echo "CoreDNS pod name: ${COREDNS_POD}"
echo "CoreDNS service IP: ${COREDNS_SERVICE_IP}"
echo "DNS search domain: ${DNS_SEARCH}"
echo "DNS server IP: ${DNS_SERVER}"
