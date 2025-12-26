#!/bin/bash

# 配置文件路径
CONF_FILE="$HOME/.config/aria2/aria2.conf"

# 获取最佳 Tracker 列表 (best.txt 比较精简且稳定)
list=$(curl -s https://raw.githubusercontent.com/ngosang/trackerslist/master/trackers_best.txt | awk NF | paste -sd "," -)

# 如果获取成功
if [ -n "$list" ]; then
  # 检查是否已有 bt-tracker 配置，有则替换，无则追加
  if grep -q "^bt-tracker=" "$CONF_FILE"; then
    sed -i "s|^bt-tracker=.*|bt-tracker=$list|" "$CONF_FILE"
  else
    echo "bt-tracker=$list" >>"$CONF_FILE"
  fi
  echo "Tracker list updated successfully!"

  # 如果 aria2 正在运行，尝试通过 RPC 重新加载配置（可选，需要安装 curl）
  # 这里为了简单，我们通常重启服务即可
else
  echo "Failed to fetch tracker list."
fi
