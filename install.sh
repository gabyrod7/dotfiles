#!/usr/bin/env bash
set -euo pipefail

USER_CONFIG_DIR=$HOME/.config
SCRIPT_DIR="$(dirname "$(realpath "${BASH_SOURCE[0]}")")"
CONFIG_PROGRAMS=(
    "tmux"
    "nvim"
)

softlink_config_files() {
    echo "Linking configs."

    for config in "${CONFIG_PROGRAMS[@]}"; do
        base_path="${SCRIPT_DIR}/config/${config}"
        target_path=${USER_CONFIG_DIR}/${config}
    	program_config_directory="${SCRIPT_DIR}/config"

        if [ ! -d "$base_path" ]; then
            echo "[Note] Config directory ${base_path} does not exist. Skipping..."
        elif [ -L "$target_path" ]; then
            echo "[Note] Symlink ${target_path} already exists. Moving on..."
        elif [ -e "$target_path" ]; then
            echo "[Warning] ${target_path} already exists but is not a symlink. Skipping..."
        else
            ln -s "$base_path" "$target_path"
            echo "[OK] Link for ${config} established."
        fi
    done
    
}

main() {
    softlink_config_files

    echo "Done!"
}

main "$@"

