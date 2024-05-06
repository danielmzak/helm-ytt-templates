#!/bin/bash

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" &>/dev/null && pwd)"
HELM_BASE_DIR="${DIR%%/helm-ytt-templates/*}/helm-ytt-templates"

# This function builds and pushes the Docker image.
build_and_push_docker_image() {
  docker build -f "$CICD_DOCKERFILE_PATH" -t "$IMAGE_NAME" -t "$IMAGE_NAME_LATEST" .
  docker push "$IMAGE_NAME"
  docker push "$IMAGE_NAME_LATEST"
}

# This function deploys the application.
deploy_app() {
  cd "$HELM_BASE_DIR" || exit
  cd "${CICD_APP_HELM_FOLDER}" || exit
  helm dependency update
  cd ..
  helm upgrade --install --namespace "$CICD_NAMESPACE" --create-namespace "$CICD_APP_NAME"-"$CICD_DEV_PROFILE" --values "$CICD_APP_NAME"/values-"$CICD_DEV_PROFILE".yaml "$CICD_APP_NAME" --set "$CICD_APP_HELM_PARENT_CHART".image.tag="$CICD_BITBUCKET_COMMIT"
}

main() {
  SHOW_INFO=$1
  source "$DIR/setup_env_vars.sh" "$SHOW_INFO"
  source "$DIR/setup_gcp_env.sh"

  setup_env_vars
  setup_gcp_env
  build_and_push_docker_image
  deploy_app
}

# Call the main function with the command line arguments.
main "$@"
