#!/bin/bash

# 显示镜像打包时间
BUILD_TIME=$(cat /app/creat.txt)
echo -e "\033[32m镜像打包时间:$BUILD_TIME\033[0m"

# 判断是否存在自定义配置文件
if [ ! -f /data/config.conf ]; then
  echo "首次启动请编辑/data映射目录下的配置文件后重启容器"
  mv -n /app/cft/config.conf /data/config.conf
  chmod -R 777 /data/config.conf
  exit 1
else
  ln -sf /data/config.conf /app/cft/config.conf
  chmod +x /app/cft/*
  /app/cft/start.sh
fi