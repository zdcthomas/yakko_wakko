#!/bin/bash
SESSION=$USER

tmux -2 new-session -d -s $SESSION
tmux new-window -t $SESSION:1 -n 'Vim'
tmux split-window -h
tmux select-pane -t 0
tmux send-keys "fish" C-m
tmux send-keys "vim ." C-m
tmux select-pane -t 1
tmux send-keys "fish" C-m
tmux resize-pane -R 80


tmux -2 attach-session -t $SESSION

