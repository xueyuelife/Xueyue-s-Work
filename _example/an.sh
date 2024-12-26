#!/bin/bash

# 目标URL
URL="http://192.168.2.123:9010/set"
SECRET="MySecret"

while true; do
    # 获取当前应用的包名
    CURRENT_FOCUS=$(dumpsys window | grep mCurrentFocus)
    #   mCurrentFocus=null
    #   mCurrentFocus=Window{b061da6 u0 com.termux/com.termux.app.TermuxActivity}
    # 提取包名
    PACKAGE_NAME=$(echo "$CURRENT_FOCUS" | awk -F '[ /}]' '{print $5}')
    # 去除空格
    PACKAGE_NAME=$(echo "$PACKAGE_NAME" | tr -d '[:space:]')
    # 去除%0a
    # PACKAGE_NAME=$(echo "$PACKAGE_NAME" | tr -d '%0a')
    # 输出一下PACKAGE_NAME
    echo "$PACKAGE_NAME"
    # 若PACKAGE_NAME 为 NotificationShade ，则设置变量status为1否则为0
    if [ "$PACKAGE_NAME" = "NotificationShade" ]; then
        STATUS=1
    else
        STATUS=0
    fi
    # 如果包名不为空，则发送GET请求
    if [ ! -z "$PACKAGE_NAME" ]; then
        # 使用curl发送GET请求
        curl -G "$URL" --data-urlencode "secret=$SECRET" --data-urlencode "app_name=$PACKAGE_NAME" --data-urlencode "status=$STATUS"
    fi

    # 等待10秒
    sleep 10
done