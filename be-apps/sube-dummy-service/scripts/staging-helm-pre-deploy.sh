#!/bin/bash

# Code generated. DO NOT EDIT.

CURRENT_DIR=$PWD

#
# switch to proper cluster
#

gcloud config set project staging-001 && kubectl config use-context gke_staging-001_europe-west1-c_demo-cluster-staging

#
# pre-deploy app with 0 replicas
#

cd ../..
helm upgrade --install --namespace sube --create-namespace sube-dummy-service-staging --values sube-dummy-service/values-staging.yaml sube-dummy-service --set be-springboot.replicaCount=0

#
# create google service account with roles and bind it with kubernetes service account
#

cd "$CURRENT_DIR" || exit
source staging-gsa-ksa.sh
