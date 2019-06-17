#!/bin/bash
SESSION=$USER

tmux new-session -ADd -s $SESSION -n to-be-deleted
WINDOW_NAME=$(echo $PWD | sed -E 's/.*\///')
tmux new-window -n $WINDOW_NAME
tmux kill-window -t to-be-deleted
tmux split-window -h
tmux select-pane -t 0
tmux send-keys "fish" C-m
tmux send-keys "vim ." C-m
tmux select-pane -t 1
tmux send-keys "fish" C-m
tmux resize-pane -R 80

tmux -2 attach-session -t $SESSION
