#!/bin/bash

set -eu

: ${GCP_SERVICE_ACCOUNT_JSON:?require GCP Service Account JSON}
: ${K8S_CLUSTER_METADATA:?required}

gcloud auth activate-service-account --key-file <(echo "$GCP_SERVICE_ACCOUNT_JSON")

CLUSTER_NAME=$(cat $K8S_CLUSTER_METADATA/metadata | jq -r ".cluster_name")
CLUSTER_ZONE=$(cat $K8S_CLUSTER_METADATA/metadata | jq -r ".cluster_zone")
# CLUSTER_REGION=$(cat $K8S_CLUSTER_METADATA/metadata | jq -r ".cluster_region")

gcloud container clusters get-credentials $CLUSTER_NAME --region $CLUSTER_ZONE

kubectl get pods --all-namespaces