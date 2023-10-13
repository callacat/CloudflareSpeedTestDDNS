#!/bin/bash

# 设置计划任务执行时间，默认为 '5 8 * * *' 北京时间早上8点05分
export CRON_TIME='5 8 * * *'

# 是否使用优选IP测试，仅支持ipv4，不能和config.conf中的IP_PR_IP同时开启
export ENABLE_DOWNLOAD=true