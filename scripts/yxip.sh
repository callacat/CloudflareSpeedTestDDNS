#!/bin/bash

# 下载txt.zip并解压
cd /app
wget -q -c --timeout=10 --header="User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/117.0.0.0 Safari/537.36 Edg/117.0.2045.43" https://zip.baipiao.eu.org -O txt.zip
if [ $? -ne 0 ]; then
    echo "下载优选IP失败，使用默认IP"
    exec /app/start.sh
    exit 1
fi
unzip -o txt.zip -d txt
rm -f cf_ddns/ip.txt
cat txt/*.txt | sort | uniq > cf_ddns/ip.txt
rm -rf txt txt.zip

# 执行/app/start.sh
exec /app/start.sh
