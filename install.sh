#!/usr/bin/env bash
set -euo pipefail

USER_CONFIG_DIR="$HOME/.config"
USER_BIN_DIR="$HOME/.local/bin"
SCRIPT_DIR="$(dirname "$(realpath "${BASH_SOURCE[0]}")")"
CONFIG_PROGRAMS=(
    "tmux"
    "nvim"
)

GREEN='\033[0;32m'
YELLOW='\033[0;33m'
RED='\033[0;31m'
RESET='\033[0m'

OK="${GREEN}[OK]${RESET}"
NOTE="${YELLOW}[Note]${RESET}"
WARN="${RED}[Warning]${RESET}"

softlink_config_files() {
    echo "Linking configs."

    mkdir -p "$USER_CONFIG_DIR"

    for config in "${CONFIG_PROGRAMS[@]}"; do
        base_path="${SCRIPT_DIR}/config/${config}"
        target_path="${USER_CONFIG_DIR}/${config}"

        if [ ! -d "$base_path" ]; then
            printf "${NOTE} Config directory ${base_path} does not exist. Skipping...\n"
        elif [ -L "$target_path" ]; then
            printf "${NOTE} Symlink ${target_path} already exists. Moving on...\n"
        elif [ -e "$target_path" ]; then
            printf "${WARN} ${target_path} already exists but is not a symlink. Skipping...\n"
        else
            ln -s "$base_path" "$target_path"
            printf "${OK} Link for ${config} established.\n"
        fi
    done
    
}

softlink_commands() {
    echo "Linking commands."

    commands_dir="${SCRIPT_DIR}/commands"

    if [ ! -d "$commands_dir" ]; then
        printf "${NOTE} Commands directory ${commands_dir} does not exist. Skipping...\n"
        return
    fi

    mkdir -p "$USER_BIN_DIR"

    for command_path in "${commands_dir}"/*; do
        [ -f "$command_path" ] || continue

        command_name="$(basename "$command_path")"
        target_path="${USER_BIN_DIR}/${command_name}"

        chmod +x "$command_path"

        if [ -L "$target_path" ]; then
            printf "${NOTE} Symlink ${target_path} already exists. Moving on...\n"
        elif [ -e "$target_path" ]; then
            printf "${WARN} ${target_path} already exists but is not a symlink. Skipping...\n"
        else
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

