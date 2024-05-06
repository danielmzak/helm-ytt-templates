#!/bin/bash

# Code generated. DO NOT EDIT.

#
# create GSA (Google Service Account) for app and bind it /with KSA
#

ERR_MSG=$(gcloud iam service-accounts describe sube-dummy-service-gsa@prod-001.iam.gserviceaccount.com 2>&1 | grep ERROR)

if [[ "$ERR_MSG" == *"ERROR"* ]]; then
    echo "Service account doesn't exist - creating one"
    gcloud iam service-accounts create sube-dummy-service-gsa \
       --description="GSA for sube-dummy-service on prod" \
       --display-name="app: sube-dummy-service-gsa"
else
    echo "Service account already exist - skipping ..."
fi

#
# GSA roles
#

echo "->roles" ; \
gcloud projects add-iam-policy-binding prod-001 --member="serviceAccount:sube-dummy-service-gsa@prod-001.iam.gserviceaccount.com" --role="roles/logging.logWriter" ; \
gcloud projects add-iam-policy-binding prod-001 --member="serviceAccount:sube-dummy-service-gsa@prod-001.iam.gserviceaccount.com" --role="roles/cloudprofiler.agent" ; \
gcloud projects add-iam-policy-binding prod-001 --member="serviceAccount:sube-dummy-service-gsa@prod-001.iam.gserviceaccount.com" --role="roles/cloudtrace.agent" ; \
gcloud projects add-iam-policy-binding prod-001 --member="serviceAccount:sube-dummy-service-gsa@prod-001.iam.gserviceaccount.com" --role="roles/secretmanager.secretAccessor" ; \
gcloud projects add-iam-policy-binding prod-001 --member="serviceAccount:sube-dummy-service-gsa@prod-001.iam.gserviceaccount.com" --role="roles/cloudsql.client" ; \
echo "<-roles"

#
# bind GSA and KSA
#

gcloud iam service-accounts add-iam-policy-binding sube-dummy-service-gsa@prod-001.iam.gserviceaccount.com \
    --role roles/iam.workloadIdentityUser \
    --member "serviceAccount:prod-001.svc.id.goog[sube/sube-dummy-service-prod]"

kubectl annotate serviceaccount sube-dummy-service-prod \
    --namespace sube \
    iam.gke.io/gcp-service-account=sube-dummy-service-gsa@prod-001.iam.gserviceaccount.com
