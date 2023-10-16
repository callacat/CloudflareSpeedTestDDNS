# 使用Alpine Linux作为基础镜像
FROM alpine:latest

ENV TZ=Asia/Shanghai

# 安装所需的依赖包
RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.ustc.edu.cn/g' /etc/apk/repositories \
    && apk add --no-cache bash jq wget curl tar sed unzip git tzdata psmisc \
    && rm -rf /var/cache/apk/* \
    && ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# 创建/app和/config目录
RUN mkdir /app /data

# 设置工作目录
WORKDIR /app

# 下载CloudflareSpeedTestDDNS代码并移动文件
RUN git clone https://github.com/lee1080/CloudflareSpeedTestDDNS.git && \
    mv CloudflareSpeedTestDDNS/* . && \
    rm -rf CloudflareSpeedTestDDNS \
    && rm README.md

# 下载CloudflareSpeedTest并解压缩
RUN latest_version=$(curl -s https://api.github.com/repos/XIU2/CloudflareSpeedTest/releases/latest | jq -r .tag_name) && \
    arch=$(apk --print-arch) && \
    if [ "$arch" = "x86_64" ]; then \
        wget https://github.com/XIU2/CloudflareSpeedTest/releases/download/${latest_version}/CloudflareST_linux_amd64.tar.gz -O CloudflareST.tar.gz; \
    elif [ "$arch" = "aarch64" ]; then \
        wget https://github.com/XIU2/CloudflareSpeedTest/releases/download/${latest_version}/CloudflareST_linux_arm64.tar.gz -O CloudflareST.tar.gz; \
    else \
        echo "Unsupported architecture"; \
        exit 1; \
    fi && \
    mkdir CloudflareST && \
    tar -xzvf CloudflareST.tar.gz -C CloudflareST && \
    mv CloudflareST/* ./cf_ddns/ && \
    cp cf_ddns/ip.txt /app/ && \
    cp cf_ddns/ipv6.txt /app/ && \
    rm -rf CloudflareST CloudflareST.tar.gz \
    && date > /app/creat.txt

# 复制脚本文件夹中的所有内容到容器的/app目录下
COPY scripts/ /app/

# 给/app目录下的文件赋权
RUN chmod +x /app/*

# 设置容器入口点
ENTRYPOINT ["/app/entrypoint.sh"]
