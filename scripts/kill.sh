#!/bin/bash

pkill -f $(ps aux | grep start.sh | grep -v grep | awk '{print $2}')
pkill -f $(ps aux | grep yxip.sh | grep -v grep | awk '{print $2}')
pkill -f $(ps aux | grep cf_check.sh | grep -v grep | awk '{print $2}')
pkill -f $(ps aux | grep cf_ddns_cloudflare.sh | grep -v grep | awk '{print $2}')
pkill -f $(ps aux | grep cf_ddns_dnspod.sh | grep -v grep | awk '{print $2}')
pkill -f $(ps aux | grep cf_push.sh | grep -v grep | awk '{print $2}')