#!/usr/bin/env bash
set -euo pipefail

USER_CONFIG_DIR=$HOME/.config
CONFIG_PROGRAMS=(
    "tmux:tmux.conf"
)

softlink_config_files() {
    for config in "${CONFIG_PROGRAMS}"; do
        directory="${config%%:*}"
        config_name="${config#*:}"

        echo "ln -s "${HOME}/dotfiles/config/${directory}/${config_name}" ${USER_CONFIG_DIR}/${directory}/${config_name}"
    done
    
}

main() {
    softlink_config_files
}

main "$@"

