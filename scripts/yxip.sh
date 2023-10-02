#!/bin/bash

# 创建临时目录并下载txt.zip
mkdir -p tmp && wget -4 -q -c --timeout=15 --header="User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/117.0.0.0 Safari/537.36 Edg/117.0.2045.43" -O tmp/txt.zip https://zip.baipiao.eu.org

# 判断下载是否成功
if [ $? -eq 0 ]; then
    echo -e "\033[31m下载优选IP完成，开始测速\033[0m\n"
    rm -f /app/cf_ddns/ip.txt # 删除旧的ip.txt文件
    unzip -qo tmp/txt.zip -d tmp # 解压缩txt.zip文件到临时目录
    cat tmp/*.txt | sort | uniq > /app/cf_ddns/ip.txt # 将所有txt文件合并到一个ip.txt文件中，并去重排序
else
    echo -e "\033[31m下载优选IP失败，使用默认IP测速\033[0m\n"
    rm -f /app/cf_ddns/ip.txt # 删除旧的ip.txt文件
    cp /app/ip.txt /app/cf_ddns/ip.txt # 复制默认的ip.txt文件
fi

# 删除临时目录
rm -rf tmp

# 执行/app/start.sh
exec /app/start.sh