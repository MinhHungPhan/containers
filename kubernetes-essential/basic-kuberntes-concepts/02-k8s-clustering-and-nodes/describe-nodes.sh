#!/bin/bash

# Get list of nodes and store in a text file
kubectl get nodes > node_list.txt

# Get list of nodes and store in a temporary file
kubectl get nodes --no-headers | awk '{print $1}' > node_names.txt

# Read the node names from the file and run 'kubectl describe' for each node
while read -r node_name; do
  # Run 'kubectl describe' for the current node and store output in a text file
  kubectl describe node "$node_name" > "node_description_${node_name}.txt"
done < node_names.txt

# Remove the temporary file
rm node_names.txt