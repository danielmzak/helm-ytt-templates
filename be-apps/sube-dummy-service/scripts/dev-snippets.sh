#!/bin/bash

# Code generated. DO NOT EDIT.

#
# switch to proper cluster
#

# $ gcloud config set project dev-001 && kubectl config use-context gke_dev-001_europe-west1-c_demo-cluster-dev

# go to the be-apps folder
# $ cd ../../

#
# helm snippet(s)
#

# $ helm install --namespace sube sube-dummy-service-dev --values sube-dummy-service/values-dev.yaml sube-dummy-service --dry-run --debug
# $ helm install --namespace sube sube-dummy-service-dev --values sube-dummy-service/values-dev.yaml sube-dummy-service

# $ helm upgrade --namespace sube sube-dummy-service-dev --values sube-dummy-service/values-dev.yaml sube-dummy-service --dry-run --debug
# $ helm upgrade --namespace sube sube-dummy-service-dev --values sube-dummy-service/values-dev.yaml sube-dummy-service

# $ helm upgrade --install --namespace sube sube-dummy-service-dev --values sube-dummy-service/values-dev.yaml sube-dummy-service --dry-run --debug

# use in ci/cd
# $ helm upgrade --install --namespace sube --create-namespace sube-dummy-service-dev --values sube-dummy-service/values-dev.yaml sube-dummy-service

#
# pipeline snippet(s)
#

#    - step: &redeploy-to-dev
#        name: Build & Deploy to dev
#        deployment: dev
#        <<: *step_configuration
#        script:
#          - git clone git@bitbucket.org:company-01/helm-ytt-templates.git
#          - source helm-ytt-templates/be-apps/be-apps/sube-dummy-service/scripts/dev-env-vars.sh
#          - source helm-ytt-templates/cicd/scripts/build_and_deploy.sh true
