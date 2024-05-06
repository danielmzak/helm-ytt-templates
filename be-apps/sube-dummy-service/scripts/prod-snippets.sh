#!/bin/bash

# Code generated. DO NOT EDIT.

#
# switch to proper cluster
#

# $ gcloud config set project prod-001 && kubectl config use-context gke_prod-001_europe-west3-a_demo-cluster-prod

# go to the be-apps folder
# $ cd ../../

#
# helm snippet(s)
#

# $ helm install --namespace sube sube-dummy-service-prod --values sube-dummy-service/values-prod.yaml sube-dummy-service --dry-run --debug
# $ helm install --namespace sube sube-dummy-service-prod --values sube-dummy-service/values-prod.yaml sube-dummy-service

# $ helm upgrade --namespace sube sube-dummy-service-prod --values sube-dummy-service/values-prod.yaml sube-dummy-service --dry-run --debug
# $ helm upgrade --namespace sube sube-dummy-service-prod --values sube-dummy-service/values-prod.yaml sube-dummy-service

# $ helm upgrade --install --namespace sube sube-dummy-service-prod --values sube-dummy-service/values-prod.yaml sube-dummy-service --dry-run --debug

# use in ci/cd
# $ helm upgrade --install --namespace sube --create-namespace sube-dummy-service-prod --values sube-dummy-service/values-prod.yaml sube-dummy-service

#
# pipeline snippet(s)
#

#    - step: &redeploy-to-prod
#        name: Build & Deploy to prod
#        deployment: prod
#        <<: *step_configuration
#        script:
#          - git clone git@bitbucket.org:company-01/helm-ytt-templates.git
#          - source helm-ytt-templates/be-apps/be-apps/sube-dummy-service/scripts/prod-env-vars.sh
#          - source helm-ytt-templates/cicd/scripts/build_and_deploy.sh true
