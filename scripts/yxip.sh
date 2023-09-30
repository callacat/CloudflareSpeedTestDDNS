#!/bin/sh

# 下载txt.zip并解压
cd /app
wget -4 https://zip.baipiao.eu.org/txt.zip -O txt.zip
if [ $? -ne 0 ]; then
    echo "下载优选IP失败，使用默认IP"
    exit 1
fi
unzip txt.zip -d txt
rm cf_ddns/ip.txt
cat txt/*.txt > cf_ddns/ip.txt
rm -rf txt txt.zip

# 执行/app/start.sh
exec /app/start.sh