#!/usr/bin/env bash

CURRENT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

tmux set -g default-terminal "screen-256color"
tmux set -ga terminal-overrides ",*256col*:Tc"
tmux set -g terminal-features "xterm-256color:RGB"

tmux set -g allow-passthrough all
tmux set -g set-clipboard on

tmux set -g mode-style "fg=#7aa2f7,bg=#3b4261"
tmux set -g message-style "fg=#7aa2f7,bg=#3b4261"
tmux set -g message-command-style "fg=#7aa2f7,bg=#3b4261"

tmux set -g pane-border-style "fg=#3b4261"
tmux set -g pane-active-border-style "fg=#7aa2f7"

tmux set -g status "on"
tmux set -g status-justify "left"
tmux set -g status-style "fg=#7aa2f7,bg=#16161e"
tmux set -g status-left-length "100"
tmux set -g status-right-length "100"
tmux set -g status-left-style NONE
tmux set -g status-right-style NONE

tmux set -g status-left "#[fg=#15161e,bg=#7aa2f7,bold] #S #[fg=#7aa2f7,bg=#16161e,nobold,nounderscore,noitalics]"

tmux set -g status-right "#[fg=#16161e,bg=#16161e,nobold,nounderscore,noitalics]#[fg=#7aa2f7,bg=#16161e] #{prefix_highlight} \
#[fg=#3b4261,bg=#16161e,nobold,nounderscore,noitalics]#[fg=#7aa2f7,bg=#3b4261] #($CURRENT_DIR/scripts/tmux_status.sh network) \
#[fg=#3b4261,bg=#16161e,nobold,nounderscore,noitalics]#[fg=#7aa2f7,bg=#3b4261]MEM:#($CURRENT_DIR/scripts/tmux_status.sh memory) \
#[fg=#3b4261,bg=#16161e,nobold,nounderscore,noitalics]#[fg=#7aa2f7,bg=#3b4261]CPU:#($CURRENT_DIR/scripts/tmux_status.sh cpu) \
#[fg=#15161e,bg=#7aa2f7,bold] #(whoami)@#H"

tmux setw -g window-status-activity-style "underscore,fg=#a9b1d6,bg=#16161e"
tmux setw -g window-status-separator ""
tmux setw -g window-status-style "NONE,fg=#a9b1d6,bg=#16161e"
tmux setw -g window-status-format "#[fg=#16161e,bg=#16161e,nobold,nounderscore,noitalics]#[default]#I #W #[fg=#16161e,bg=#16161e,nobold,nounderscore,noitalics] "
tmux setw -g window-status-current-format "#[fg=#16161e,bg=#3b4261,nobold,nounderscore,noitalics]#[fg=#7aa2f7,bg=#3b4261,bold] #I #W #[fg=#3b4261,bg=#16161e,nobold,nounderscore,noitalics]"

tmux set -g mouse on
tmux set -g base-index 1
tmux setw -g pane-base-index 1
tmux set -g renumber-windows on
tmux set -g history-limit 10000
tmux set -sg escape-time 1
tmux set -g status-interval 1

tmux bind-key r run-shell "tmux source-file ~/.tmux.conf \; display '配置已重新加载!'"
