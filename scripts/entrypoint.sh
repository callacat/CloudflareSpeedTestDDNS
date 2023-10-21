#!/bin/bash

# 定义日志函数
log() {
  echo "$(date) $*" 
}

# 加载配置
config_file="/data/config.conf"
if [ ! -f "$config_file" ]; then
  log "请先编辑配置文件 $config_file 后再次启动"
  cp -f /app/config.conf /data/config.conf.bak
  mv /app/config.conf /data
  ln -s /data/config.conf /app/config.conf
  cp /app/scripts/yxip.conf /data
  cp -f /app/scripts/yxip.conf /data/yxip.conf.bak
  exit 1
fi

# 每次启动强制软链接配置文件
ln -sf /data/config.conf /app/config.conf

source "$config_file"

start="/app/start.sh"

# 如果yxip.conf不存在则直接启动
if [ ! -f "/data/yxip.conf" ]; then
  cp -f /app/scripts/yxip.conf /data/yxip.conf.bak
  start
  log "优选IP任务执行完成"
  exit 0
else
  # 每次启动强制覆盖优选IP配置文件备份
  cp -f /app/scripts/yxip.conf /data/yxip.conf.bak

  yxip="/data/yxip.conf"
  source "$yxip"

    # 主逻辑
  if [[ $ENABLE_DOWNLOAD == "true" ]]; then
    log "使用优选IP测速"
    /app/scripts/yxip.sh
  elif [ -f "/data/ip.txt" ]; then
    log "使用自定义IP测速"
    cp /data/ip.txt /app/cf_ddns/ip.txt
    start
  elif ! [[ $IP_PR_IP == "0" ]]; then
    log "使用IP_PR模式测速"
    start
  else
    log "使用默认IP测速"
    cp /app/backup/ip.txt /app/cf_ddns/ip.txt 
    start
  fi
fi