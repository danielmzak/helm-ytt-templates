#!/usr/bin/env python3

# example of usage: 
# $ ./wytt_proj.py --cfg cfg-sube-dummy-service.yaml
# note: install if needed
# $ pip install ruamel.yaml

import copy
import os
import argparse
import shutil
from ruamel.yaml import YAML

from wytt_utils import wytt_utils_find_paths

DIRS = ['scripts', 'ytt', 'ytt/config', 'ytt/value-templates']
BE_TEMPLATE_DIR = "be-apps/_be_template"
BE_APPS_DIR = "be-apps"


def create_directories(dirs, dst_dir):
    for d in dirs:
        os.makedirs(os.path.join(dst_dir, d), exist_ok=True)


def transform(data, profile, profiles):
    if isinstance(data, dict):
        for key, value in data.items():
            if isinstance(value, dict) and all(p in value for p in profiles):
                data[key] = value[profile]
            else:
                transform(value, profile, profiles)


def change_directory(path):
    os.chdir(path)


def load_yaml(file_path):
    yaml = YAML()
    with open(file_path, 'r') as file:
        return yaml.load(file)


def dump_yaml(data, file_path, prefix):
    yaml = YAML()
    with open(file_path, 'w') as file:
        file.write(prefix)
        yaml.dump(data, file)


def copy_values(infra_profile, path_to_template):
    shutil.copy(path_to_template, f"ytt/value-templates/template-values-{infra_profile}.yaml")


def create_chart(cfg, path_to_chart):
    chart = load_yaml(path_to_chart)
    chart["name"] = cfg["cfg"]["app"]
    chart["description"] = cfg["cfg"]["gitRepo"]
    for dependency in chart.get('dependencies', []):
        if dependency.get('name') == 'be-springboot':
            dependency['repository'] = f'file://../../{cfg["cfg"]["helmAppParentChart"]}'
    dump_yaml(chart, "Chart.yaml", "")


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument('--cfg', help='Configuration file for new project')
    parser.add_argument('--path_to_template', default=f'{BE_TEMPLATE_DIR}/_ytt/value-templates/template-values.yaml',
                        help='Path to template')
    parser.add_argument('--path_to_chart', default=f'{BE_TEMPLATE_DIR}/_ytt/chart_templates/Chart.yaml',
                        help='Path to template')

    args = parser.parse_args()
    cfg_file = args.cfg
    path_to_template = args.path_to_template
    path_to_chart = args.path_to_chart

    print(f"Passed parameters: cfg: {cfg_file}, template: {path_to_template}")

    wytt_abs_path, _, _ = wytt_utils_find_paths()

    change_directory(f'{wytt_abs_path}/{BE_TEMPLATE_DIR}')

    cfg = load_yaml(f'_new_projects/{cfg_file}')

    app_dir = cfg["cfg"]["app"]

    print(f'Generate new project for: {app_dir}')

    infra_profiles = cfg["cfg"]["infraProfiles"]
    print(f'for following infra profiles: {infra_profiles}')

    change_directory(f'{wytt_abs_path}/{BE_APPS_DIR}')
    create_directories([app_dir], os.getcwd())
    change_directory(app_dir)
    create_directories(DIRS, os.getcwd())
    shutil.copy(f'{wytt_abs_path}/{BE_TEMPLATE_DIR}/_new_projects/{cfg_file}', 'ytt/config/cfg.yaml')

    del cfg["cfg"]['infraProfiles']

    for p in infra_profiles:
        editable_cfg = copy.deepcopy(cfg)
        transform(editable_cfg, p, infra_profiles)
        dump_yaml(editable_cfg, f'ytt/config/cfg-{p}.yaml', "#@data/values\n---\n")
        copy_values(p, wytt_abs_path + "/" + path_to_template)

    create_chart(cfg, f'{wytt_abs_path}/{path_to_chart}')

    print("Configuration files generated successfully. Probably :)")
    print(f"Now you can check/edit template-values files, then run:\n\n ./wytt_gen.py --app {app_dir}")


if __name__ == "__main__":
    main()
