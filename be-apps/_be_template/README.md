# BE template for new project(s)

### create config for new project in be-apps/_be_template/_new_projects

```
# switch to helm-ytt-templates/be-apps/_be_template folder
# note use _ytt/config/cfg.yaml as source config for typical company-01 BE microservice
cp _ytt/config/cfg.yaml _new_projects/<cfg-new-project-name.yaml>
```

### edit <cfg-new-project-name.yaml> in your favorite editor

### generate new project
```
cd scripts && ./wytt_proj.py --cfg <cfg-new-project-name.yaml>
```

### if neccessary, check/edit generated files, then:

```bash
./wytt_gen.py --app <new-project-name>
```

---

### process manual step or use dedicated cicd pipelines: pre-deploy app:
- run <infra-profile>-helm-pre-deploy.sh script

for example: `helm-ytt-templates/be-apps/sube-dummy-service/scripts/dev-helm-pre-deploy.sh`

- run script which creates service account and bind them with kubernetes service account

for example: `helm-ytt-templates/be-apps/sube-dummy-service/scripts/dev-gsa-ksa.sh`

(for all clusters)

---

### shared scripts used in pipelines are in: 
    - `helm-ytt-templates/_cicd/scripts`

check `<infra-profile>-snippets.sh` 
 - use in pipelines 
 - or provide manual helm installation

for example: `helm-ytt-templates/be-apps/sube-dummy-service/scripts/dev-snippets.sh`

note: if helm chart is uninstalled remember to run scripts again ...
---
- install python3
- make sure that is default for script processing (ie: #!/usr/bin/env python3)
- make sure you have installed libraries (install_plibs.sh or install them manually via pip3)
