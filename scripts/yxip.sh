#!/bin/sh

# 下载txt.zip并解压
cd /app
wget https://zip.baipiao.eu.org/txt.zip -O txt.zip
unzip txt.zip -d txt
rm cf_ddns/ip.txt
cat txt/*.txt > cf_ddns/ip.txt
rm -rf txt txt.zip

# 执行/app/start.sh，并将输出重定向到一个文件
exec /app/start.sh > /app/start.log 2>&1 &

# 使用 tail -f 命令来查看 start.log 文件的内容
tail -f /app/start.log