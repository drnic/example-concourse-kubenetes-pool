#!/bin/bash

set -eu

export KUBECONFIG=$PWD/kube/metadata
kube get all --all-namespaces
