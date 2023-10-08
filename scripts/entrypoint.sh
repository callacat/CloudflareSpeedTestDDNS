#!/bin/bash

# 每次启动时显示镜像打包时间
BUILD_TIME=$(cat /app/creat.txt)
echo -e "\033[32m镜像打包时间:$BUILD_TIME\033[0m"

# 判断是否存在自定义配置文件
if [ ! -f /data/config.conf ]; then
  echo "首次启动请编辑/data映射目录下的配置文件后重启容器"
  mv /app/backup/config.conf.bak /data/config.conf
fi

# 每次启动时创建一个内置的配置文件备份
rm /data/config.conf.bak
cp /app/backup/config.conf.bak /data/config.conf.bak

# 创建软链接
if [ ! -L /app/config.conf ]; then
  rm /app/config.conf
  ln -sf /data/config.conf /app/config.conf
fi

# 加载配置文件
source /app/config.conf 

# 创建定时任务函数 
set_cron() {
  cron_command=$1 # 获取参数作为要运行的命令
  echo "$CRON_TIME cd /app && /app/time.sh && $cron_command >> /tmp/cron.log 2>&1" > /etc/crontabs/cfyx # 写入定时任务
  crontab /etc/crontabs/cfyx && crond & # 载入定时任务并在后台运行
}

# 执行一次性任务函数
run_once() {
  cd /app && $cron_command >> /tmp/cron.log 2>&1 &
}

# 启动时执行一次测速任务
run_once

# 输出定时任务日志
tail -f /tmp/cron.log