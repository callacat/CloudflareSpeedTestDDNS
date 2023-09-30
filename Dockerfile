# 使用alpine镜像，它是一个轻量级的Linux发行版
FROM alpine:latest

ENV TZ=Asia/Shanghai

# 安装依赖bash、jq、wget、curl、tar、sed、awk、tr、unzip
RUN apk update \
    && apk add --no-cache bash jq wget curl tar sed unzip git \
    && rm -rf /var/cache/apk/*

# 创建/data和/app目录
RUN mkdir /data /app

# 设置工作目录为/data
WORKDIR /data

# 克隆GitHub仓库并移动文件到当前目录，删除空文件夹
RUN git clone https://github.com/lee1080/CloudflareSpeedTestDDNS.git && \
    mv CloudflareSpeedTestDDNS/* . && \
    rm -rf CloudflareSpeedTestDDNS

# 执行cf_check.sh脚本并设置时区
RUN bash cf_ddns/cf_check.sh \
    && ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# 下载并解压txt.zip文件，替换ip.txt文件的内容，删除txt文件夹
RUN wget -O txt.zip https://zip.baipiao.eu.org/ && \
    unzip txt.zip -d txt && \
    rm cf_ddns/ip.txt && \
    cat txt/*.txt > cf_ddns/ip.txt && \
    rm -rf txt txt.zip

# 设置工作目录为/app
WORKDIR /app

ADD entrypoint.sh entrypoint.sh

# 给sh脚本添加可执行权限
RUN pwd && ls  && chmod +x entrypoint.sh

# 运行sh脚本
CMD ["bash", "/app/entrypoint.sh"]
