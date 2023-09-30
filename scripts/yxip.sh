#!/bin/sh

# 下载txt.zip并解压
wget https://zip.baipiao.eu.org/txt.zip -O txt.zip && \
unzip txt.zip -d txt && \
cat txt/*.txt > cf_ddns/ip.txt && \
rm -rf txt txt.zip

# 执行/app/start.sh
exec /app/start.sh
