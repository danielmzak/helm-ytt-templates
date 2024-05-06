#!/bin/bash

# Code generated. DO NOT EDIT.

CURRENT_DIR=$PWD

#
# switch to proper cluster
#

gcloud config set project prod-001 && kubectl config use-context gke_prod-001_europe-west3-a_demo-cluster-prod

#
# pre-deploy app with 0 replicas
#

cd ../..
helm upgrade --install --namespace sube --create-namespace sube-dummy-service-prod --values sube-dummy-service/values-prod.yaml sube-dummy-service --set be-springboot.replicaCount=0

#
# create google service account with roles and bind it with kubernetes service account
#

cd "$CURRENT_DIR" || exit
source prod-gsa-ksa.sh
