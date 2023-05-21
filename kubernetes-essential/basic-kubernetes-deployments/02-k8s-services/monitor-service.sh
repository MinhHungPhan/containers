#!/bin/bash

NAMESPACE="default" # Using the default namespace
TEST_POD="curl"     # The name of the pod used for testing
IGNORE_SERVICES="kubernetes" # Services to ignore

# Delete the existing Deployment if it exists
echo "Deleting existing Deployment if it exists..."
kubectl -n ${NAMESPACE} delete deployment ${TEST_POD} --ignore-not-found=true

# Delete the existing Pod if it exists
echo "Deleting existing Pod if it exists..."
kubectl -n ${NAMESPACE} delete pod ${TEST_POD} --ignore-not-found=true

# Create a pod for testing purposes
echo "Creating a pod for testing purposes..."
kubectl run ${TEST_POD} --image=radial/busyboxplus:curl --restart=Never --command -- tail -f /dev/null

# Wait for the pod to be Running
while [[ $(kubectl get pods ${TEST_POD} -o 'jsonpath={..status.conditions[?(@.type=="Ready")].status}') != "True" ]]; do echo "waiting for pod" && sleep 1; done

while true
do
  echo "Checking services and endpoints..."

  # Get the services in the namespace
  SERVICES=$(kubectl -n ${NAMESPACE} get svc -o jsonpath='{.items[*].metadata.name}')

  for SERVICE in ${SERVICES}
  do
    # Check if we should ignore this service
    if [[ " ${IGNORE_SERVICES[@]} " =~ " ${SERVICE} " ]]; then
      echo "Ignoring service: ${SERVICE}"
      continue
    fi

    echo "Service: ${SERVICE}"

    # Get service details
    SERVICE_DETAILS=$(kubectl -n ${NAMESPACE} describe svc ${SERVICE})

    echo "${SERVICE_DETAILS}"

    # Check if we can connect to the service
    echo "Connecting to service ${SERVICE}..."
    CONNECTION_STATUS=$(kubectl -n ${NAMESPACE} exec ${TEST_POD} -- curl -s -o /dev/null -w "%{http_code}" ${SERVICE})

    if [[ "${CONNECTION_STATUS}" == "200" ]]; then
      echo "Successfully connected to the service."
    else
      echo "Failed to connect to the service. HTTP status code: ${CONNECTION_STATUS}"
    fi
  done

  echo "Completed checking services and endpoints. Waiting for 60 seconds before next check..."
  sleep 60
done
