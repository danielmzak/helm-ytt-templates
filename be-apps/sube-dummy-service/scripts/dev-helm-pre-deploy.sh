#!/bin/bash

# Code generated. DO NOT EDIT.

CURRENT_DIR=$PWD

#
# switch to proper cluster
#

gcloud config set project dev-001 && kubectl config use-context gke_dev-001_europe-west1-c_demo-cluster-dev

#
# pre-deploy app with 0 replicas
#

cd ../..
helm upgrade --install --namespace sube --create-namespace sube-dummy-service-dev --values sube-dummy-service/values-dev.yaml sube-dummy-service --set be-springboot.replicaCount=0

#
# create google service account with roles and bind it with kubernetes service account
#

cd "$CURRENT_DIR" || exit
source dev-gsa-ksa.sh
