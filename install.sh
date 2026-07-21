#!/usr/bin/env bash
set -euo pipefail

USER_CONFIG_DIR="$HOME/.config"
USER_BIN_DIR="$HOME/.local/bin"
SCRIPT_DIR="$(dirname "$(realpath "${BASH_SOURCE[0]}")")"
#CONFIG_PROGRAMS=(
#    "tmux"
#    "nvim"
#)

GREEN='\033[0;32m'
YELLOW='\033[0;33m'
RED='\033[0;31m'
RESET='\033[0m'

OK="${GREEN}[OK]${RESET}"
NOTE="${YELLOW}[Note]${RESET}"
WARN="${RED}[Warning]${RESET}"

softlink_config_files() {
    echo "Linking configs."

    config_dir="${SCRIPT_DIR}/config"
    if [ ! -d "$config_dir" ]; then # No config folder to link from
        printf "${NOTE} Config directory ${config_dir} does not exist. Skipping...\n"
        return
    fi

    mkdir -p "$USER_CONFIG_DIR"

    for config_path in "${config_dir}"/*; do
        [ -d "$config_path" ] || continue # Skip anything that is not a config directory

        config_name="$(basename "$config_path")"
        target_path="${USER_CONFIG_DIR}/${config_name}"

        if [ -L "$target_path" ]; then # Target already exists as a symlink
            printf "${NOTE} Symlink ${target_path} already exists. Moving on...\n"
        elif [ -e "$target_path" ]; then # Target exists, but is a real file/folder
            printf "${WARN} ${target_path} already exists but is not a symlink. Skipping...\n"
        else # Safe to create the symlink
            ln -s "$config_path" "$target_path"
            printf "${OK} Link for ${config_name} established.\n"
        fi
    done
    
}

softlink_commands() {
    echo "Linking commands."

    commands_dir="${SCRIPT_DIR}/commands"
    if [ ! -d "$commands_dir" ]; then # No commands folder to link from
        printf "${NOTE} Commands directory ${commands_dir} does not exist. Skipping...\n"
        return
    fi

    user_dotlocal_path="${HOME}/.local"
    if ! [[ ":$PATH:" == *":${user_dotlocal_path}:"* ]]; then
        export PATH=$PATH:$user_dotlocal_path
    	printf "${NOTE} ${user_dotlocal_path} is not in your PATH, Consider adding it permanently to your shell configuration (e.g. ~/.bashrc).\n"
    fi

    mkdir -p "$USER_BIN_DIR"

    for command_path in "${commands_dir}"/*; do
        [ -f "$command_path" ] || continue # Skip anything that is not a regular command file

        command_name="$(basename "$command_path")"
        target_path="${USER_BIN_DIR}/${command_name}"

        chmod +x "$command_path"

        if [ -L "$target_path" ]; then # Command is already linked
            printf "${NOTE} Symlink ${target_path} already exists. Moving on...\n"
        elif [ -e "$target_path" ]; then # A non-symlink command already exists there
            printf "${WARN} ${target_path} already exists but is not a symlink. Skipping...\n"
        else # Safe to create the command symlink
            ln -s "$command_path" "$target_path"
            printf "${OK} Link for ${command_name} established.\n"
        fi
    done
}

main() {
    softlink_config_files
    softlink_commands

    echo "Done!"
}

main "$@"

