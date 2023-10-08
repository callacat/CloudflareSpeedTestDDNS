#!/bin/bash

# 每次启动时显示镜像打包时间
BUILD_TIME=$(cat /app/creat.txt)
echo -e "\033[32m镜像打包时间:$BUILD_TIME\033[0m"

# 每次启动时强制覆盖配置文件备份
if [ -f /data/config.conf.bak ]; then
  rm /data/config.conf.bak
fi
cp /app/backup/config.conf.bak /data/config.bak

# 判断是否存在配置文件
if [ ! -f /data/config.conf ]; then
  # 如果不存在则输出提示并创建配置文件然后退出
  echo "首次启动请编辑/data映射目录下配置文件后重启容器"
  cp /app/backup/config.conf.bak /data/config.conf
  exit 1 # 初始化配置后退出脚本
else
  # 如果存在则在每次启动时检查并创建软链接
  if [ ! -L /app/config.conf ]; then
    ln -sf /data/config.conf /app/config.conf
  fi
  /app/start.sh
fi
