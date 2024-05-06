#!/bin/bash

# Code generated. DO NOT EDIT.

#
# switch to proper cluster
#

# $ gcloud config set project staging-001 && kubectl config use-context gke_staging-001_europe-west1-c_demo-cluster-staging

# go to the be-apps folder
# $ cd ../../

#
# helm snippet(s)
#

# $ helm install --namespace sube sube-dummy-service-staging --values sube-dummy-service/values-staging.yaml sube-dummy-service --dry-run --debug
# $ helm install --namespace sube sube-dummy-service-staging --values sube-dummy-service/values-staging.yaml sube-dummy-service

# $ helm upgrade --namespace sube sube-dummy-service-staging --values sube-dummy-service/values-staging.yaml sube-dummy-service --dry-run --debug
# $ helm upgrade --namespace sube sube-dummy-service-staging --values sube-dummy-service/values-staging.yaml sube-dummy-service

# $ helm upgrade --install --namespace sube sube-dummy-service-staging --values sube-dummy-service/values-staging.yaml sube-dummy-service --dry-run --debug

# use in ci/cd
# $ helm upgrade --install --namespace sube --create-namespace sube-dummy-service-staging --values sube-dummy-service/values-staging.yaml sube-dummy-service

#
# pipeline snippet(s)
#

#    - step: &redeploy-to-staging
#        name: Build & Deploy to staging
#        deployment: staging
#        <<: *step_configuration
#        script:
#          - git clone git@bitbucket.org:company-01/helm-ytt-templates.git
#          - source helm-ytt-templates/be-apps/be-apps/sube-dummy-service/scripts/staging-env-vars.sh
#          - source helm-ytt-templates/cicd/scripts/build_and_deploy.sh true
