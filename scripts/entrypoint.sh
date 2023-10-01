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

# 如果存在自定义的ip.txt，复制到 /app/cf_ddns/ip.txt 并强制替换
if [ -f /data/ip.txt ]; then
    echo "使用自定义IPv4测速" 
    rm -rf /app/cf_ddns/ip.txt
    cp /data/ip.txt /app/cf_ddns/ip.txt
fi

# 读取/app/config.conf
source /app/config.conf

# 如果IP_ADDR的值为ipv6，就则进入是否使用自定义ipv6的判断，否则跳过
if [ "$IP_ADDR" = "ipv6" ]; then
    # 如果存在自定义的ipv6.txt，复制到 /app/cf_ddns/ipv6.txt 并强制替换，如果不存在则使用默认ipv6
    if [ -f /data/ipv6.txt ]; then
        echo "使用自定义IPv6测速"
        rm -rf /app/cf_ddns/ipv6.txt
        cp /data/ipv6.txt /app/cf_ddns/ipv6.txt
    else
        echo "使用默认IPv6测速"
        rm -rf /app/cf_ddns/ipv6.txt
        cp /app/ip6.txt /app/cf_ddns/ipv6.txt
    fi
fi

# 设置时间
time=${CRON_TIME:-'0 5 * * *'}

# 当使用自定义IPv4时，不执行ENABLE_DOWNLOAD 变量的判断
if [ -f /data/ip.txt ]; then
    ENABLE_DOWNLOAD=false
fi

# 根据 ENABLE_DOWNLOAD 变量选择要执行的命令
if [ "$ENABLE_DOWNLOAD" = "true" ]; then
    echo "将使用优选IP进行测速"
    # wget https://zip.baipiao.eu.org -O txt.zip
    # if [ $? -ne 0 ]; then
    #     echo "下载优选IP失败，使用默认IP"
    #     cron_command="/app/start.sh"
    # fi
    # unzip txt.zip -d txt
    # rm cf_ddns/ip.txt
    # cat txt/*.txt > cf_ddns/ip.txt
    # rm -rf txt txt.zip
    cron_command="/app/yxip.sh"
else
    echo "未选择优选IP进行测速，使用默认IP"
    rm -f /app/cf_ddns/ip.txt
    cp /app/ip.txt /app/cf_ddns/ip.txt
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