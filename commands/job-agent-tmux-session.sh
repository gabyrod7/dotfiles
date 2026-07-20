#!/usr/bin/env bash

SESSION="job_agent"
PROJECT_DIR="$HOME/projects/agents/job_application_agent/"

# Attach if session already exists
if tmux has-session -t "$SESSION" 2>/dev/null; then
  tmux attach -t "$SESSION"
  exit 0
fi

# Create session in project dir
tmux new-session -d -s "$SESSION" -n main -c "$PROJECT_DIR"

# Split into two columns
tmux split-window -h -t "$SESSION":main -c "$PROJECT_DIR"

# Right pane: run pi
tmux send-keys -t "$SESSION":main.1 "pi" C-m

## Make panes equal width
#tmux select-layout -t "$SESSION":main even-horizontal

# Focus left pane
tmux select-pane -t "$SESSION":main.0

# Attach
tmux attach -t "$SESSION"
