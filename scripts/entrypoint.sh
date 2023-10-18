#!/bin/bash

# 显示镜像打包时间
BUILD_TIME=$(cat /app/creat.txt)
echo -e "\033[32m镜像打包时间:$BUILD_TIME\033[0m"

# 判断是否存在自定义配置文件
if [ ! -f /data/config.conf ]; then
  echo "首次启动请编辑/data映射目录下的配置文件后重启容器"
  mv /app/config.conf /data/config.conf
  mv /app/cron.conf /data/cron.conf
  exit 1
else
  # 创建软链接
  ln -sf /data/config.conf /app/config.conf

  # 加载配置文件
  source /app/config.conf
  source /data/cron.conf

  # 判断配置走不同逻辑
  case "$ENABLE_DOWNLOAD" in

  # 如果启用下载  
    true)
      log_start # 日志记录 
      echo "当前使用优选IP进行测速"
      set_cron "/app/yxip.sh" # 设置定时任务 
      ;;

  # 如果不启用  
    false)
      if [ -f /data/ip.txt ]; then # 自定义ip文件存在
        log_start  # 日志记录
        echo "当前使用自定义IP进行测速"
        cp /data/ip.txt /app/cf_ddns/ip.txt # 拷贝自定义ip文件
        set_cron "/app/start.sh" # 设置定时任务
      elif [ "$IP_PR_IP" = "true" ]; then # 开启IP_PR模式
        log_start
        echo "当前使用IP_PR模式进行测速"
        set_cron "/app/start.sh"
      else # 其他情况使用默认ip
        log_start
        echo "当前使用默认IP进行测速"
        cp /app/ip.txt /app/cf_ddns/ip.txt # 拷贝默认ip文件
        set_cron "/app/start.sh"
      fi
      ;;
  esac

  # 如果定时任务不为空
  if "$CRON_TIME" != "" ; then
    # 定义日志函数,显示当前执行时间
    log_start() {
      /app/time.sh
    }

    # 创建定时任务函数 
    set_cron() {
      cron_command=$1 # 获取参数作为要运行的命令
      echo "$CRON_TIME cd /app && /app/time.sh && $cron_command >> /tmp/cron.log 2>&1" > /etc/crontabs/cfyx # 写入定时任务
      crontab /etc/crontabs/cfyx && crond & # 载入定时任务并在后台运行
    }

    # 输出定时任务日志
    tail -f /tmp/cron.log

  else
    # 执行一次性任务函数
    run_once() {
      cd /app && $cron_command >> /tmp/cron.log 2>&1 &
    }

    # 启动时执行一次测速任务
    run_once
  fi
fi
