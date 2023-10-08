#!/bin/bash

# 每次启动时显示镜像打包时间
BUILD_TIME=$(cat /app/creat.txt)
echo -e "\033[32m镜像打包时间:$BUILD_TIME\033[0m"

# 判断是否存在自定义配置文件
if [ ! -f /data/config.conf ]; then
  echo "首次启动请编辑/data映射目录下的配置文件后重启容器"
  cp /app/backup/config.conf.bak /data/config.conf
fi

# 每次启动时创建一个内置的配置文件备份
if [ -f /data/config.conf.bak ]; then
  rm /data/config.conf.bak
fi
cp /app/backup/config.conf.bak /data/config.conf.bak

# 创建软链接
if [ ! -L /app/config.conf ]; then
  rm /app/config.conf
  ln -sf /data/config.conf /app/config.conf
fi

/app/start.sh

# # 执行任务
# /app/start.sh >> /tmp/cron.log 2>&1 &

# # 输出定时任务日志
# tail -f /tmp/cron.log
