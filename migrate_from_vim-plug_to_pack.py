#!/bin/env python3

import os
import re
import shutil
import subprocess


def extract_github_info(vimrc_content):
    plugin_lines = re.findall(r"Plug ['\"]([^']+)[']", vimrc_content)
    return plugin_lines


def migrate_plugins(vimrc_path):
    # Read the existing vimrc file
    with open(vimrc_path, "r") as vimrc_file:
        vimrc_content = vimrc_file.read()

    # Extract GitHub repository information from plugin lines
    plugins_info = extract_github_info(vimrc_content)
    print(plugins_info)

    # Write the updated vimrc content
    with open(vimrc_path, "w") as vimrc_file:
        vimrc_file.write(vimrc_content)

    # Move plugins from plugged to pack directory and create submodules
    pack_path = os.path.expanduser("~/Dotfiles/vim/pack/plugins/start/")
    for github_info in plugins_info:
        plugin_name = github_info.split("/")[1]
        submodule_path = os.path.join(pack_path, plugin_name)

        subprocess.run(
            [
                "git",
                "submodule",
                "add",
                f"https://github.com/{github_info}.git",
                submodule_path,
            ],
            check=True,
        )

    print("Migration completed successfully!")


if __name__ == "__main__":
    vimrc_path = os.path.expanduser("~/Dotfiles/vimrc")
    migrate_plugins(vimrc_path)
