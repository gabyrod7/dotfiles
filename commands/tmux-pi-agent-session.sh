#!/bin/bash

if tmux has-session -t pi-agent 2>/dev/null; then
  tmux attach -t pi-agent
  exit 0
fi

tmux new-session -d -s pi-agent -n main
tmux split-window -h -t pi-agent:main
tmux send-keys -t pi-agent:main.1 "pi" C-m
tmux attach -t pi-agent
