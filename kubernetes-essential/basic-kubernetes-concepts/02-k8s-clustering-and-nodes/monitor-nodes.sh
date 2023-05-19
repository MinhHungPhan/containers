#!/bin/bash

# Get the list of nodes
nodes=$(kubectl get nodes -o jsonpath='{range .items[*]}{.metadata.name}{"\n"}{end}')

# Loop through each node and retrieve information
for node in $nodes; do
  echo "Node: $node"
  echo "----------------------------------------"

  # Get the node status
  status=$(kubectl get node "$node" -o jsonpath='{.status.conditions[?(@.type=="Ready")].status}')
  echo "Status: $status"

  # Get the node addresses
  addresses=$(kubectl get node "$node" -o jsonpath='{range .status.addresses[*]}{.type}={.address}{"\n"}{end}')
  echo "Addresses:"
  echo "$addresses"

  echo
done
