#!/bin/bash

tmux new-session -d -s pi-agent -n main
tmux split-window -h -t pi-agent:main
tmux send-keys -t pi-agent:main.1 "pi" C-m
tmux attach -t pi-agent
