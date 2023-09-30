#!/bin/bash
# 移动config.conf文件到/app目录，并创建软链接
mv /data/config.conf /app/config.conf
ln -s /app/config.conf /data/config.conf

# 添加定时任务执行脚本，默认是 0 5 * * * 北京时间早上5点执行脚本
echo "0 5 * * * bash /data/cf_ddns/start.sh" > crontab.txt
crontab crontab.txt
rm crontab.txt

# 容器每次启动时立即执行一次脚本，并同步显示执行脚本的日志
bash /data/cf_ddns/start.sh
tail -f /data/cf_ddns/cf.log