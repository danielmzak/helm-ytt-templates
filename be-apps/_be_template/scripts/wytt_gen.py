#!/usr/bin/env python3

# generates values and script for be project
# note: for projects with lang mutations use: wytt-gen-lm.py-snippet
#
# using:
#   ./wytt_gen.py app-directory
# for example:
#   $ ./wytt-gen-lm.py-snippet core-api
#

import os
import argparse
import sys
import shutil
import subprocess
from ruamel.yaml import YAML

from wytt_utils import wytt_utils_find_paths

SCRIPTS = ["env-vars.sh", "gsa-ksa.sh", "helm-pre-deploy.sh", "snippets.sh"]
SCRIPT_TEMPLATE_RELATIVE_PATH = "be-apps/_be_template/_ytt/script_templates"
OUTPUT_SCRIPT_PATH = "scripts"


def print_line():
    print("-" * 75)


def load_yaml(file_path):
    yaml = YAML()
    with open(file_path, 'r') as file:
        return yaml.load(file)


def run_command(command):
    try:
        subprocess.run(command, check=False)
    except subprocess.CalledProcessError as e:
        print(f"Error running command: {e}")


def generate_values(infra_profiles):
    print_line()
    print("Generate values")
    print_line()

    for p in infra_profiles:
        print(f"render values-{p}.yaml")
        with open(f"values-{p}.yaml", "w") as f:
            subprocess.run(
                ["ytt", "-f", f"ytt/config/cfg-{p}.yaml", "-f", f"ytt/value-templates/template-values-{p}.yaml"],
                stdout=f,
                check=False,
            )


def generate_scripts(path_to_script_template, infra_profiles):
    print_line()
    print("Generate scripts")
    print_line()

    pst = path_to_script_template
    osp = OUTPUT_SCRIPT_PATH

    for s in SCRIPTS:
        for p in infra_profiles:
            file = f"{p}-{s}"
            file_path = f"{osp}/{file}"
            print(f"render script: {s} for profile {p}: {file}")
            shutil.copy(f"{pst}/{s}.txt", f"{osp}/{file}.txt")
            run_command(["ytt", "-f", f"ytt/config/cfg-{p}.yaml", "-f", f"{osp}/{file}.txt",
                         "--output-files", f"{osp}/"])
            try:
                os.rename(f"{file_path}.txt", file_path)
            except OSError as e:
                print(f"Error renaming file: {e}")

            try:
                os.chmod(file_path, 0o755)
            except OSError as e:
                print(f"Error during chmode in file: {e}")


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument('--app', help='App folder')

    args = parser.parse_args()
    wytt_abs_path, _, _ = wytt_utils_find_paths()
    app_folder = wytt_abs_path + "/be-apps/" + args.app

    print(f"Passed parameters: app: {app_folder}")

    try:
        if not os.path.exists(app_folder):
            raise FileNotFoundError("The provided path doesn't exist.")
        elif not os.path.isdir(app_folder):
            raise IsADirectoryError("Provided argument is not a directory")

        os.chdir(app_folder)
    except (FileNotFoundError, IsADirectoryError) as e:
        print("An error occurred: ", str(e))
        sys.exit()

    run_command(["helm", "dependency", "update"])

    cfg = load_yaml("ytt/config/cfg.yaml")
    infra_profiles = cfg["cfg"]["infraProfiles"]

    generate_values(infra_profiles)
    generate_scripts(wytt_abs_path + "/" + SCRIPT_TEMPLATE_RELATIVE_PATH, infra_profiles)

    # run_command(["/bin/bash", "render-values-warehouse-utils.sh"])


if __name__ == "__main__":
    main()
