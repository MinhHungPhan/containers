#!/bin/bash

NAMESPACE="default"  # Using the default namespace
DEPLOYMENT="nginx"   # Set your deployment name here

while true
do
  echo "Checking deployment status..."

  # Get deployment status
  DEPLOYMENT_STATUS=$(kubectl -n ${NAMESPACE} rollout status deployment/${DEPLOYMENT} --timeout=30s)

  echo "Deployment Status: ${DEPLOYMENT_STATUS}"

  if [[ "${DEPLOYMENT_STATUS}" == *"successfully rolled out"* ]]; then
    echo "Deployment successfully rolled out."

    # Get the pods for this deployment
    PODS=$(kubectl -n ${NAMESPACE} get pods -l app=${DEPLOYMENT} -o jsonpath='{.items[*].metadata.name}')

    echo "Checking pods status..."

    for POD in ${PODS}
    do
      POD_STATUS=$(kubectl -n ${NAMESPACE} get pod ${POD} -o jsonpath='{.status.phase}')
      echo "Pod: ${POD}, Status: ${POD_STATUS}"
    done
  else
    echo "Deployment is not yet successfully rolled out. Retrying in 60 seconds."
  fi

  sleep 60
done
