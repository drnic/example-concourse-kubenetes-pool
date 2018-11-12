#!/bin/bash

set -eu

export KUBECONFIG=$PWD/kube/metadata
kubectl get all --all-namespaces
