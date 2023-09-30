#!/bin/bash

# 如果 /data/config.conf 不存在，将其移动到 /data 目录
if [ ! -f /data/config.conf ]; then
    echo "首次启动请编辑/data映射目录下的配置文件后重启容器"
    mv /app/config.conf /data/config.conf
fi

# 如果 /data/cron.sh 不存在，将其移动到 /data 目录
if [ ! -f /data/cron.sh ]; then
    mv /app/cron.sh /data/cron.sh
fi

# 如果 /app/config.conf 不存在，创建软链接
if [ ! -L /app/config.conf ]; then
    rm /app/config.conf
    ln -sf /data/config.conf /app/config.conf
fi

# 如果存在自定义的cron.sh，执行它并获取输出
if [ -f /data/cron.sh ]; then
    chmod +x /data/cron.sh
    source /data/cron.sh  # 这里使用 source 来运行，以获取环境变量
fi

# 设置时间
time=${CRON_TIME:-'0 5 * * *'}

# 根据 ENABLE_DOWNLOAD 变量选择要执行的命令
if [ "$ENABLE_DOWNLOAD" = "true" ]; then
    echo "将使用优选IP进行测速"
    cron_command="/app/yxip.sh"
else
    echo "未选择优选IP进行测速，使用默认IP"
    cron_command="/app/start.sh"
fi

# 创建 cron 作业
echo "$time cd /app && $cron_command >> /data/cron.log 2>&1" > /etc/crontabs/cfyx

# 载入 cron 作业并启动 cron 守护进程（放到后台执行）
crontab /etc/crontabs/cfyx && crond &

# 执行一次脚本并将输出重定向到日志文件（同时输出日志）
cd /app && $cron_command | tee -a /data/cron.log

# 输出日志（放到后台执行）
tail -f /data/cron.log &