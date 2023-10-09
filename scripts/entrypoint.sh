#!/bin/bash

# 每次启动时显示镜像打包时间
BUILD_TIME=$(cat /app/creat.txt)
echo -e "\033[32m镜像打包时间:$BUILD_TIME\033[0m"

# 判断是否存在配置文件
if [ ! -f /data/config.conf ]; then
  # 如果不存在则输出提示并创建配置文件然后退出
  echo "首次启动请编辑/data映射目录下配置文件后重启容器"
  cp /data/backup/config.conf.bak /data/config.conf
  exit 1 # 初始化配置后退出脚本
else
  /data/start.sh
fi
