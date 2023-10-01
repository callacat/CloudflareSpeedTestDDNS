#!/bin/bash

# 下载txt.zip并解压到临时目录
mkdir tmp
wget -4 -q -c --timeout=15 --header="User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/117.0.0.0 Safari/537.36 Edg/117.0.2045.43" -O tmp/txt.zip https://zip.baipiao.eu.org
if [ $? -ne 0 ]; then
    echo -e "\033[31m下载优选IP失败，使用默认IP\033[0m\n"
    rm -rf tmp # 删除临时目录
    rm -f /app/cf_ddns/ip.txt # 删除旧的ip.txt文件
    cp /app/ip.txt /app/cf_ddns/ip.txt # 复制默认的ip.txt文件
    exec /app/start.sh # 执行start.sh脚本
fi
unzip -qo tmp/txt.zip -d tmp # 解压缩txt.zip文件到临时目录
rm -f /app/cf_ddns/ip.txt # 删除旧的ip.txt文件
cat tmp/*.txt | sort | uniq > /app/cf_ddns/ip.txt # 将所有txt文件合并到一个ip.txt文件中，并去重排序
rm -rf tmp # 删除临时目录

# 执行/app/start.sh
exec /app/start.sh