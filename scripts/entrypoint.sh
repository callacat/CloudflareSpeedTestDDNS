#!/bin/bash

# 默认定时
time='0 5 * * *'

# 如果存在自定义的cron.sh，执行它
if [ -f /config/cron.sh ]; then
    chmod +x /config/cron.sh
    /config/cron.sh
else
    # 设置时间
    time=${CRON_TIME:-'0 5 * * *'}
fi

# 如果 /data/config.conf 不存在，将其移动到 /data 目录
if [ ! -f /data/config.conf ]; then
    mv /app/config.conf /data/config.conf
fi

# 如果 /data/cron.sh 不存在，将其移动到 /data 目录
if [ ! -f /data/cron.sh ]; then
    mv /app/cron.sh /data/cron.sh
fi

# 如果 /app/config.conf 不存在，创建软链接
if [ ! -L /app/config.conf ]; then
    ln -s /data/config.conf /app/config.conf
fi

# 根据 ENABLE_DOWNLOAD 变量选择要执行的命令
if [ "$ENABLE_DOWNLOAD" = "true" ]; then
    echo "将使用优选IP进行测速"
    command="/app/yxip.sh"
else
    echo "未选择优选IP进行测速，使用默认IP"
    command="/app/start.sh"
fi

# 创建 cron 作业
echo "$time $command >> /var/log/cron.log 2>&1" > /etc/cron.d/cf_ddns-cron

# 载入 cron 作业
crontab /etc/cron.d/cf_ddns-cron

# 启动 cron 守护进程
crond -f