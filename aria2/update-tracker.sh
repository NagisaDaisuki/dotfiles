#!/bin/bash

# --- 1. 配置路径与变量（适配Arch Linux）---
# Aria2 配置文件路径
CONFIG_FILE="$HOME/.config/aria2/aria2.conf"
# Systmed 服务名称
SERVICE_NAME="aria2"
# 下载链接
TRACKER_URL="https://cf.trackerslist.com/best_aria2.txt"
# 临时文件路径
TEMP_FILE="/tmp/aria2_trackers_best.txt"

# --- 2. 下载 Tracker 列表 ---
echo "正在从 $TRACKER_URL 下载 Tracker 列表..."

# 使用 curl 下载（比 wget 在脚本中更常用，且 Arch 默认通常有）
# -s：静默模式, -S：显示错误，-o：输出文件
curl -sS -L "$TRACKER_URL" -o "$TEMP_FILE"

# 检查下载是否成功且文件不为空（-s 判断文件大小不为0）
if [ ! -s "$TEMP_FILE" ]; then
  echo "错误：下载失败或文件为空！"
  rm -f "$TEMP_FILE"
  exit 1
fi

# --- 3. 处理列表格式 ---
# 逻辑说明：读取文件 -> 将换行符(\n)替换为逗号(,) -> 删除最后一个多余的逗号
# 这段逻辑兼容列表是"每行一个URL"或者"已经是逗号分隔"的情况

NEW_TRACKER=$(cat "$TEMP_FILE" | tr '\n' ',' | sed 's/,$//')

# 再次检查处理后的内容是否为空
if [ -z "$NEW_TRACKER" ]; then
  echo "错误：解析后的 Tracker 列表为空！"
  rm -f "$TEMP_FILE"
  exit 1
fi

# --- 4. 修改配置文件 ---
echo "正在更新配置文件..."

# 备份原配置文件（安全第一）
cp "$CONFIG_FILE" "${CONFIG_FILE}.bak"

# 检查是否存在 bt-tracker 配置项
if grep -q "^bt-tracker=" "$CONFIG_FILE"; then
  # 如果存在，使用 sed 整行替换 (使用 | 作为分隔符避免 URL 特殊字符冲突)
  sed -i "s|^bt-tracker=.*|bt-tracker=$NEW_TRACKER|" "$CONFIG_FILE"
else
  # 如果不存在，追加到文件末尾
  echo "bt-tracker=$NEW_TRACKER" >>"$CONFIG_FILE"
fi

# 清理临时文件
rm -f "$TEMP_FILE"

# --- 5. 重启服务 ---
echo "正在重启 Aria2 服务..."
systemctl --user restart "$SERVICE_NAME"

if [ $? -eq 0 ]; then
  echo "成功：Aria2 配置已更新并重启。"
else
  echo "警告：配置文件已更新，但服务重启失败。"
fi
