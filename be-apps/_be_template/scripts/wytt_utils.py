import os

REPO_NAME = "helm-ytt-templates"
UTIL_NAME = "wytt-utils"


def wytt_utils_find_paths():
    current_dir = os.getcwd()
    split_path = current_dir.split(REPO_NAME)

    absolute_part = split_path[0] + REPO_NAME
    relative_part = split_path[1]

    os.chdir(absolute_part)

    print(f'{UTIL_NAME}: absolute_part: {absolute_part}')
    print(f'{UTIL_NAME}: relative_part: {relative_part}')
    print(f'{UTIL_NAME}: repo: {REPO_NAME}')

    return [absolute_part, relative_part, REPO_NAME]
