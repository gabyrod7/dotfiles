#!/bin/bash

if tmux has-session -t syncthing 2>/dev/null; then
  tmux attach -t syncthing
  exit 0
fi

tmux new-session -d -s syncthing 'syncthing'
#tmux attach -t syncthing
