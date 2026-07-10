#!/usr/bin/env bash
set -euo pipefail

USER_CONFIG_DIR=$HOME/.config
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

    for config in "${CONFIG_PROGRAMS[@]}"; do
        base_path="${SCRIPT_DIR}/config/${config}"
        target_path=${USER_CONFIG_DIR}/${config}
    	program_config_directory="${SCRIPT_DIR}/config"

        if [ ! -d "$base_path" ]; then
            printf "${NOTE} Config directory ${base_path} does not exist. Skipping...\n"
        elif [ -L "$target_path" ]; then
            printf "${NOTE} Symlink ${target_path} already exists. Moving on...\n"
        elif [ -e "$target_path" ]; then
            printf "${WARV} ${target_path} already exists but is not a symlink. Skipping...\n"
        else
            ln -s "$base_path" "$target_path"
            printf "[OK] Link for ${config} established.\n"
        fi
    done
    
}

main() {
    softlink_config_files

    echo "Done!"
}

main "$@"

