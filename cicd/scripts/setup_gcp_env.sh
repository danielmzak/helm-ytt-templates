#!/bin/bash

# This function sets up the GCP environment
setup_gcp_env() {
  #
  # get secrets from shared project
  #

  echo "$SHARED_SM_ACCESSOR_GSA" | base64 -d >./shared-sm-accessor-gsa.json
  gcloud auth activate-service-account --key-file shared-sm-accessor-gsa.json
  gcloud config set project shared

  CICD_GKE_DEPLOY_SA=$(gcloud secrets versions access latest --secret="$CICD_GSA_DEPLOY_SECRET")

  #
  # settings for docker repo and GCP project
  #

  echo "$CICD_GKE_DEPLOY_SA" | base64 -d >./gke-deploy-sa.json
  gcloud auth activate-service-account --key-file gke-deploy-sa.json
  gcloud config set project "$CICD_GKE_PROJECT_ID"
  gcloud container clusters get-credentials --zone "$CICD_GKE_ZONE_NAME" "$CICD_GKE_CLUSTER_NAME"
  gcloud auth configure-docker
  gcloud auth configure-docker "$CICD_DOCKER_BASE_URL"
}
