#!/bin/bash

# This function trims leading and trailing whitespace from a string.
trim() {
  local trimmed="$1"
  echo "$trimmed" | xargs
}

# This function prints a message if the SHOW_INFO variable is set to true.
info() {
  local message="$1"
  if [ "$showInfo" = true ]; then
    echo "$message"
  fi
}

# This function sets up the environment variables and prints them if SHOW_INFO is true.
setup_env_vars() {
  echo "setup_env_vars"

  showInfo=${SHOW_INFO:=false}

  info "SHOW_INFO: $SHOW_INFO"
  info "CICD_BITBUCKET_COMMIT: $CICD_BITBUCKET_COMMIT"
  info "CICD_DEV_PROFILE: $CICD_DEV_PROFILE"
  info "CICD_DOCKER_BASE_URL: $CICD_DOCKER_BASE_URL"
  info "CICD_DOCKER_REPO_NAME: $CICD_DOCKER_REPO_NAME"
  info "CICD_APP_NAME: $CICD_APP_NAME"
  info "CICD_GKE_PROJECT_ID: $CICD_GKE_PROJECT_ID"
  info "CICD_GKE_CLUSTER_NAME: $CICD_GKE_CLUSTER_NAME"
  info "CICD_GKE_ZONE_NAME: $CICD_GKE_ZONE_NAME"
  info "CICD_APP_HELM_FOLDER: $CICD_APP_HELM_FOLDER"

  info "CICD_APP_HELM_PARENT_CHART: $CICD_APP_HELM_PARENT_CHART"

  info "CICD_GSA_DEPLOY_SECRET: $CICD_GSA_DEPLOY_SECRET"

  export USE_GKE_GCLOUD_AUTH_PLUGIN=True
  export DOCKER_URL=$CICD_DOCKER_BASE_URL/$CICD_GKE_PROJECT_ID/$CICD_DOCKER_REPO_NAME
  export IMAGE_NAME=$DOCKER_URL/$CICD_APP_NAME-$CICD_DEV_PROFILE:$CICD_BITBUCKET_COMMIT
  export IMAGE_NAME_LATEST=$DOCKER_URL/$CICD_APP_NAME-$CICD_DEV_PROFILE:latest

  info "DOCKER_URL: $DOCKER_URL"
  info "IMAGE_NAME: $IMAGE_NAME"
  info "IMAGE_NAME_LATEST: $IMAGE_NAME_LATEST"
}
