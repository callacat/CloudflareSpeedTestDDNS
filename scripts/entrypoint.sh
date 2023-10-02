#!/bin/bash

# 显示镜像打包时间
BUILD_TIME=$(cat /app/creat.txt)
echo -e "\033[32m镜像打包时间:$BUILD_TIME\033[0m"

# 判断是否存在自定义配置文件
CONFIG_FILE="/data/config.conf"
if [ ! -f "$CONFIG_FILE" ]; then
  echo "首次启动请编辑/data映射目录下的配置文件后重启容器"
  mv /app/config.conf "$CONFIG_FILE"
fi

# 判断是否存在自定义脚本
CRON_SCRIPT="/data/cron.sh"
if [ ! -f "$CRON_SCRIPT" ]; then
  mv /app/cron.sh "$CRON_SCRIPT"
fi

# 创建软链接
if [ ! -L /app/config.conf ]; then
  rm /app/config.conf
  ln -sf "$CONFIG_FILE" /app/config.conf
fi

# 执行自定义脚本函数
run_custom() {
<<<<<<< HEAD
  if [ -f "$CRON_SCRIPT" ]; then
    chmod +x "$CRON_SCRIPT"
    load_config
  fi
}

load_config() {
  source /app/config.conf
  source /data/cron.sh
=======
  if [ -f /data/cron.sh ]; then
    echo "读取自定义脚本"
    chmod +x /data/cron.sh
    source /data/cron.sh # 使用source执行,以获取环境变量
  fi
}

run_custom

# 获取定时时间 
CRON_TIME=${CRON_TIME:-'5 8 * * *'} # 使用自定义time或默认配置中的时间

# 定义日志函数,显示当前执行时间
log_start() {
  echo -e "\033[32m当前执行时间:$(date +'%Y-%m-%d %H:%M:%S')\033[0m" >> /tmp/cron.log
>>>>>>> parent of 0305f5c (优化显示)
}

# 定义日志文件
LOG_FILE="/tmp/cron.log"

# 定义定时任务函数
custom() {
  cd /app && /app/load_config.sh && /app/time.sh && $cron_command
}

# 创建定时任务函数
set_cron() {
<<<<<<< HEAD
  cron_command="$1" # 获取参数作为要运行的命令
  echo "$CRON_TIME $custom >> $LOG_FILE 2>&1" > /etc/crontabs/cfyx # 写入定时任务
=======
  cron_command=$1 # 获取参数作为要运行的命令
  echo "$CRON_TIME cd /app && $cron_command >> /tmp/cron.log 2>&1" > /etc/crontabs/cfyx # 写入定时任务
>>>>>>> parent of 0305f5c (优化显示)
  crontab /etc/crontabs/cfyx && crond & # 载入定时任务并在后台运行
}

# 判断配置走不同逻辑
case "$ENABLE_DOWNLOAD" in
  true)
<<<<<<< HEAD
    /app/time.sh # 日志记录
    echo "当前使用优选IP进行测速"
    set_cron "/app/yxip.sh" # 设置定时任务
=======
    log_start # 日志记录  
    set_cron "/app/yxip.sh" # 设置定时任务 
>>>>>>> parent of 0305f5c (优化显示)
    ;;

  false)
    if [ -f /data/ip.txt ]; then # 自定义ip文件存在
<<<<<<< HEAD
      /app/time.sh # 日志记录
      echo "当前使用自定义IP进行测速"
      cp /data/ip.txt /app/cf_ddns/ip.txt # 拷贝自定义ip文件
      set_cron "/app/start.sh" # 设置定时任务
    elif [ "$IP_PR_IP" = "true" ]; then # 开启IP_PR模式
      /app/time.sh
      echo "当前使用IP_PR模式进行测速"
      set_cron "/app/start.sh"
    else # 其他情况使用默认ip
      /app/time.sh
      echo "当前使用默认IP进行测速"
=======
      log_start  # 日志记录
      cp /data/ip.txt /app/cf_ddns/ip.txt # 拷贝自定义ip文件
      set_cron "/app/start.sh" # 设置定时任务
    elif [ "$IP_PR_IP" = "true" ]; then # 开启IP_PR模式
      log_start
      set_cron "/app/start.sh"
    else # 其他情况使用默认ip
      log_start  
>>>>>>> parent of 0305f5c (优化显示)
      cp /app/ip.txt /app/cf_ddns/ip.txt # 拷贝默认ip文件
      set_cron "/app/start.sh"
    fi
    ;;
esac

# 执行一次性任务函数
run_once() {
<<<<<<< HEAD
  cd /app && $cron_command >> $LOG_FILE 2>&1 &
=======
#  log_start
  cd /app && $cron_command >> /tmp/cron.log 2>&1 &
>>>>>>> parent of 0305f5c (优化显示)
}

echo "$cron_command"
echo "$IP_PR_IP"
echo "$ENABLE_DOWNLOAD"
echo "$CRON_TIME"

# 启动时执行一次测速任务
run_custom && run_once

# 输出定时任务日志
<<<<<<< HEAD
tail -f $LOG_FILE
=======
echo -e "\033[32m已加入定时任务，当前定时: $CRON_TIME\033[0m\n"
tail -f /tmp/cron.log
>>>>>>> parent of 0305f5c (优化显示)
