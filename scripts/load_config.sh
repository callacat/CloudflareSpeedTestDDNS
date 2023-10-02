#!/bin/bash

# 加载配置文件
source /app/config.conf

source /data/cron.sh # 使用source执行,以获取环境变量

# 获取并导出 CRON_TIME 的值
export CRON_TIME=${CRON_TIME:-'5 8 * * *'}
export ENABLE_DOWNLOAD=${ENABLE_DOWNLOAD:-true}
export IP_PR_IP=${IP_PR_IP:-false}