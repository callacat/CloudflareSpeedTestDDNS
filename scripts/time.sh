#!/bin/bash

echo -e "\033[32m已加入定时任务，当前定时: $CRON_TIME\033[0m\n"
echo -e "\033[32m本次任务执行时间:$(date +'%Y-%m-%d %H:%M:%S')\033[0m" >> /tmp/cron.log