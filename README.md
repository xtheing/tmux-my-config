# tmux-my-config

自定义 tmux 配置插件，包含 TokyoNight 主题、系统监控状态栏。

## 功能特性

- TokyoNight 主题配色
- 状态栏实时显示：网络速度、内存使用、CPU 使用率、用户名
- 鼠标支持
- 窗口自动重编号
- 重新加载配置快捷键

## 安装

### 通过 TPM 安装

在 `~/.tmux.conf` 中添加：

```bash
set -g @plugin 'tmux-plugins/tpm'
set -g @plugin 'your-username/tmux-my-config'

run '~/.tmux/plugins/tpm/tpm'
```

然后在 tmux 中按 `Ctrl+b + I` 安装。

### 手动安装

```bash
git clone https://github.com/your-username/tmux-my-config ~/.tmux/plugins/tmux-my-config
```

在 `~/.tmux.conf` 末尾添加：

```bash
run '~/.tmux/plugins/tmux-my-config/my-tmux.tmux'
```

## 快捷键

| 快捷键 | 功能 |
|--------|------|
| `Ctrl+b + r` | 重新加载配置 |
| `Ctrl+b + %` | 水平分割窗口 |
| `Ctrl+b + "` | 垂直分割窗口 |

## 状态栏显示

```
[会话名] | 网络速度 | 内存 | CPU | 用户名@主机
```

## 文件结构

```
tmux-my-config/
├── my-tmux.tmux           # 主配置文件
├── scripts/
│   ├── tmux_status.sh     # 系统监控脚本
│   └── tmux_startup.sh    # 启动恢复脚本
└── README.md
```
