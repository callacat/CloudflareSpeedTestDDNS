#!/bin/bash

# 定义日志函数
log() {
  echo "$(date) $*" 
}

# 加载配置
config_file="/data/config.conf"
if [ ! -f "$config_file" ]; then
  log "请先编辑配置文件 $config_file 后再次启动"
  cp /app/config.conf /data/config.conf.bak
  mv /app/config.conf /data
  cp /app/scripts/cron.conf /data
  cp -f /app/scripts/cron.conf /data/cron.conf.bak
  ln -s /data/config.conf /app/config.conf
  exit 1
fi
source "$config_file"

start="/app/start.sh"

# 如果cron.conf不存在则直接启动
if [ ! -f "/data/cron.conf" ]; then
  cp -f /app/scripts/cron.conf /data/cron.conf.bak
  start
  log "优选IP任务执行完成"
  exit 0
else
  cron="/data/cron.conf"
  source "$cron"

  # 验证定时任务格式
  pattern="^[0-9]{4}-[0-9]{2}-[0-9]{2} [0-9]{2}:[0-9]{2}:[0-9]{2}$"
  # 如果CRON_TIME的值不为空且格式正确时，添加到定时任务且启动一次
  if ! [[ $CRON_TIME =~ $pattern ]]; then
  # 定义定时任务函数
  set_cron() {
    local command=$1
    echo "$CRON_TIME cd /app && $command" > /etc/crontabs/cfyx
    crontab /etc/crontabs/cfyx && crond & 
  }

    # 主逻辑
  if [[ $ENABLE_DOWNLOAD == "true" ]]; then
    log "使用优选IP测速"
    set_cron "/app/scripts/yxip.sh"

  elif [ -f "/data/ip.txt" ]; then
    log "使用自定义IP测速"
    cp /data/ip.txt /app/cf_ddns/ip.txt
    set_cron "$start"

  elif [[ $IP_PR_IP == "true" ]]; then
    log "使用IP_PR模式测速"
    set_cron "$start"

  else
    log "使用默认IP测速"
    cp /app/backup/ip.txt /app/cf_ddns/ip.txt
    set_cron "$start"  
  fi

  # 继续运行或跟踪日志
  tail -f /var/log/cron.log
  else
    log "定时任务格式不正确"
    set_cron "$start"
    exit 0
  fi
fi