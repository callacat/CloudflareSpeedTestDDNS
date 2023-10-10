#!/bin/bash

<<<<<<< HEAD
# 每次启动时显示镜像打包时间
BUILD_TIME=$(cat /app/creat.txt)
echo -e "\033[32m镜像打包时间:$BUILD_TIME\033[0m"

# 判断是否存在配置文件
if [ ! -f /data/config.conf ]; then
  # 如果不存在则输出提示并创建配置文件然后退出
  echo "首次启动请编辑/data映射目录下配置文件后重启容器"
  cp /data/backup/config.conf.bak /data/config.conf
  exit 1 # 初始化配置后退出脚本
else
  /data/start.sh
fi
    else # 其他情况使用默认ip
      log_start  
>>>>>>> parent of 0305f5c (优化显示)
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
<<<<<<< HEAD
  cd /app && $cron_command >> $LOG_FILE 2>&1 &
=======
=======
>>>>>>> parent of 0305f5c (优化显示)
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
<<<<<<< HEAD
tail -f $LOG_FILE
=======
echo -e "\033[32m已加入定时任务，当前定时: $CRON_TIME\033[0m\n"
tail -f /tmp/cron.log
>>>>>>> parent of 0305f5c (优化显示)
=======
echo -e "\033[32m已加入定时任务，当前定时: $CRON_TIME\033[0m\n"
tail -f /tmp/cron.log
>>>>>>> parent of 0305f5c (优化显示)
>>>>>>> parent of 4b3c30c (撤销更改)
