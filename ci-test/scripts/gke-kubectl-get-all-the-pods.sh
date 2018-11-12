#!/bin/bash

set -eu

: ${GCP_SERVICE_ACCOUNT_JSON:?require GCP Service Account JSON}
: ${K8S_CLUSTER_METADATA:?required}

gcloud auth activate-service-account --key-file <(echo "$GCP_SERVICE_ACCOUNT_JSON")

CLOUD_PROVIDER=$(cat $K8S_CLUSTER_METADATA/metadata | jq -r ".provider")
case ${CLOUD_PROVIDER:?require "provider" key in pool resource metadata} in
  google|gcp)
    PROJECT=$(cat $K8S_CLUSTER_METADATA/metadata | jq -r ".project")
    CLUSTER_NAME=$(cat $K8S_CLUSTER_METADATA/metadata | jq -r ".cluster_name")
    CLUSTER_ZONE=$(cat $K8S_CLUSTER_METADATA/metadata | jq -r ".cluster_zone")
    # CLUSTER_REGION=$(cat $K8S_CLUSTER_METADATA/metadata | jq -r ".cluster_region")

    gcloud container clusters get-credentials $CLUSTER_NAME --region $CLUSTER_ZONE --project $PROJECT
    ;;
  *)
    echo "ERROR: unknown cloud provider $CLOUD_PROVIDER"
    exit 1
  ;;
esac

kubectl get pods --all-namespaces