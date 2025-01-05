# README

- Example of using HELM charts with YTT templates in CICD pipelines

---
## Basic idea:
- DRY access - i.e. don't repeat the same values - HELM has it's own template system, but in value files there are usually the same properties in several locations.
- If there are multiple microservices based on the same dev stack, create a parent HELM chart and reuse it.
- Create a resuable basic config file and specify individual settings for each microservice.
- Abstract and generate common parts (HELM, CICD scripts ...)
- Make pipelines consistent
- Avoid search and replace access
- Make the whole process less buggy

---
## Workflow:
- See: [basic configuration file for default backend microservice](./be-apps/_be_template/_ytt/config/cfg.yaml)
- See: [example of a fully fledged configuration file for a specific backend microservice](./be-apps/_be_template/_new_projects/cfg-sube-dummy-service.yaml)

- this script [`wytt_proj.py`](./be-apps/_be_template/scripts/wytt_proj.py) creates new folder from config file and copy it here + change necessary files
- this script [`wytt_gen.py`](./be-apps/_be_template/scripts/wytt_gen.py) then generates from [ytt](https://carvel.dev/ytt/) template files resulting chart and scripts used in cicd
    - [`template-values.yaml`](./be-apps/_be_template/_ytt/value-templates/template-values.yaml)
    - and [scripts](./be-apps/_be_template/_ytt/script_templates/)
---
- in CICD pipelines then we can use:
```
    - step: &redeploy-to-dev
        name: Build & Deploy to dev
        deployment: dev
        <<: *step_configuration
        script:
          - git clone --depth=1 git@bitbucket.org:company-01/helm-ytt-templates.git
          - source helm-ytt-templates/be-apps/be-apps/sube-dummy-service/scripts/dev-env-vars.sh
          - source helm-ytt-templates/cicd/scripts/build_and_deploy.sh true
```
- see: generated env settings [`dev-env-vars.sh`](./be-apps/sube-dummy-service/scripts/dev-env-vars.sh)
- see: [cicd scrips](./cicd/scripts/)
- this process could be simplified (redeploy-to-{env-variable}), but bitbucket have same limits (doable in github/gitlab))

---
## Notes:
- example [springbooot "parent" chart](./be-springboot/)
- here is in [`deployment.yaml`](./be-springboot/templates/deployment.yaml) is the part which allow to smaller microservices start quickly, but bigger/slower one starts too, becouse of `failureThreshold` is setted to `60` 

```
          startupProbe:
            httpGet:
              path: /actuator/health
              port: http
            failureThreshold: 60
            periodSeconds: 10

```

- and example of microservice roles [`dev-gsa-ksa.sh`](./be-apps/sube-dummy-service/scripts/dev-gsa-ksa.sh) which was also generated via [`gsa-ksa.sh.txt`](./be-apps/_be_template/_ytt/script_templates/gsa-ksa.sh.txt)
