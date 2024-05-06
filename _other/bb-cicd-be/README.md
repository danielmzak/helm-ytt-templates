### custom ci/cd docker image in private gcr 

- https://console.cloud.google.com/artifacts/docker/shared/europe/docker-repo-shared?project=shared
```
# cd helm-ytt-templates/_other/bb-cicd-be
$ ./docker-build-and-push.sh <tag>
# example: ./docker-build-and-push.sh 1.0.0
#   this command use: 1.0.0.dockerfile

```
---
- https://support.atlassian.com/bitbucket-cloud/docs/use-docker-images-as-build-environments/
- https://cloud.google.com/container-registry/docs/advanced-authentication#using_a_json_key_file
---
### shared gcr sa
```bash
$ gcloud config set project shared
$ gcloud iam service-accounts create gcr-shared-view-sa
$ gcloud projects add-iam-policy-binding shared --member "serviceAccount:gcr-shared-view-sa@shared.iam.gserviceaccount.com" --role "roles/storage.objectViewer"
$ gcloud iam service-accounts keys create keyfile.json --iam-account gcr-shared-view-sa@shared.iam.gserviceaccount.com
```
https://bitbucket.org/company-01/workspace/settings/addon/admin/pipelines/account-variables

- `$ cat keyfile.json` 
- copy into `GCR_SHARED_JSON_KEY` 

- using in bitbucket ci/cd:

```
image:
    name: <region>.gcr.io/<project>/image:tag
    username: _json_key
    password: '$GCR_SHARED_JSON_KEY'

```
example:

```bash
image:
  name: europe-docker.pkg.dev/shared/docker-repo-shared/cloud-sdk-company-01-cicd-be:1.0.0
  username: _json_key
  password: '$GCR_SHARED_JSON_KEY'
```
