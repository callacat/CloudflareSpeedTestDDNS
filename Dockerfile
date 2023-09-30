# 使用Alpine Linux作为基础镜像
FROM alpine:latest

# 安装所需的依赖包
RUN apk add --no-cache bash jq wget curl tar sed unzip git \
    && rm -rf /var/cache/apk/*

# 创建/app和/config目录
RUN mkdir /app /config

# 设置工作目录
WORKDIR /app

# 下载CloudflareSpeedTestDDNS代码并移动文件
RUN git clone https://github.com/lee1080/CloudflareSpeedTestDDNS.git && \
    mv CloudflareSpeedTestDDNS/* . && \
    rm -rf CloudflareSpeedTestDDNS

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
    rm -rf CloudflareST CloudflareST.tar.gz

# 创建/config软链接
RUN mv /app/config.conf /config/config.conf && \
     ln -s /config/config.conf /app/config.conf

# 复制脚本文件夹中的所有内容到容器的/app目录下
COPY script/ /app/

# 复制cron.sh文件到容器的/config目录下
COPY cron.sh /config/

# 分别给/app目录下的所有文件和/config/cron.sh文件赋权
RUN chmod +x /app/* /config/cron.sh

# 设置容器入口点
ENTRYPOINT ["/app/entrypoint.sh"]
