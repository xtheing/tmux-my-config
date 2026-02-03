#!/bin/bash

if [ -z "$TMUX" ]; then
    if [ -f ~/.tmux/resurrect/last ]; then
        tmux new-session -d -s restored
        tmux run-shell ~/.tmux/plugins/tmux-resurrect/scripts/restore.sh
        echo "Tmux 会话已恢复"
    else
        tmux new-session -d -s main
        tmux send-keys -t main "echo '欢迎使用 tmux！使用 Ctrl-b + % 水平分割，Ctrl-b + \" 垂直分割'" C-m
        echo "创建了新的 tmux 会话 'main'"
    fi

    if [ "$-" = "*i*" ] || [ -t 1 ]; then
        SESSION=$(tmux list-sessions | grep -o '^[[:alnum:]_-]*' | head -1)
        tmux attach-session -t "$SESSION"
    fi
fi
