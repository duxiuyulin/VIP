#!/bin/bash
## Author: SuperManito
## Modified: 2021-12-17
## Cron： 35 1,9,17 * * * bash cookie_sync.sh > sync.log

## 本脚本用于在ip被拉黑无法通过wskey更新ck的情况下使用，一般停几天就白回去了
## 需要自备一台没被拉黑ip的正常主机并且已部署容器（即执行此脚本的宿主机）
## 本脚本核心命令为ssh，请提前安装ssh并自行配置免密登录，具体方法百度
## 本脚本需在宿主机执行，并且已安装 ssh perl 命令

## ↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓ 需 要 定 义 的 变 量 ↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓

## 定义目标IP或ssh主机名（必填）
HostName=""

## 定义本地容器名或容器ID（必填）
ContainerName="jd"

## 定义目标主机的默认Shell
HostShell="bash"

## 定义目标远程主机配置文件（容器挂载目录）
HostConf="/opt/jd/config/config.sh"

## 定义本地配置文件（容器挂载目录）
LocalConf="/opt/jd/config/config.sh"

########################################################

## 定义Shell用户文件
ShellRC="~/.${HostShell}rc"

## 更新 Cookie（在容器定时中注释更新命令，添加执行本脚本至宿主机定时中，命令 crontab -e）
docker exec ${ContainerName} task cookie update

if [ "$(cat /etc/os-release | grep "^ID" | awk -F '=' '{print$NF}')" = "alpine" ]; then
    echo -e "\n\033[31m ----- 请到宿主机环境执行 ----- \033[0m\n"
    exit 1
fi

## 定义 pt_pin 数组，确认更新范围，仅同步 app_open 开头的 pt_key
pt_pin_array=(
    $(grep -E "^Cookie[0-9]{1,3}=.*app_open" $LocalConf | awk -F "[\"\']" '{print$2}' | sed "s/;/\n/g" | grep pt_pin | awk -F '=' '{print$2}')
)

## 主命令
for ((i = 1; i <= ${#pt_pin_array[@]}; i++)); do
    Num=$((i - 1))
    ## 格式化 pt_pin 用于搜索
    FormatPin=$(echo ${pt_pin_array[$Num]} | perl -pe '{s|[\.\/\[\]\!\@\#\$\%\^\&\*\(\)]|\\$&|g;}')

    ## 转义 pt_pin 中的 UrlEncode 输出中文
    EscapePin=$(printf $(echo ${pt_pin_array[$Num]} | perl -pe "s|%|\\\x|g;"))

    ## 账号序号
    CookieNum=$(grep -E "^Cookie.*pt_pin=${FormatPin}" $LocalConf | grep -o "Cookie.*=[\"\']" | sed "s/Cookie//g; s/[=\"\']//g;")

    ## 远程包含 pt_pin 的信息
    OldContent=$(ssh -o "StrictHostKeyChecking no" -T ${HostName} "source ${ShellRC} && grep -E "pt_pin=${FormatPin}" $HostConf")

    ## 本地的 py_key
    PtKeyLatest=$(grep -E "^Cookie.*pt_pin=${FormatPin}" $LocalConf | awk -F "[\"\']" '{print$2}' | sed "s/;/\n/g" | grep pt_key | awk -F '=' '{print$2}')
    ## 本地的 更新时间
    UpdateDateLatest=$(grep "\#.*上次更新：" $LocalConf | grep "${FormatPin}" | head -1 | perl -pe "{s|pt_pin=.*;||g; s|.*上次更新：||g; s|备注：.*||g; s|[ ]*$||g; s| |\\\ |g;}")

    ## 远程的 py_key
    PtKeyOld=$(echo ${OldContent} | grep -E "^Cookie.*pt_pin=" | awk -F "[\"\']" '{print$2}' | sed "s/;/\n/g" | grep pt_key | awk -F '=' '{print$2}')
    ## 远程的 更新时间
    UpdateDateOld=$(echo ${OldContent} | grep "\#.*上次更新：" | head -1 | perl -pe "{s|pt_pin=.*;||g; s|.*上次更新：||g; s|备注：.*||g; s|[ ]*$||g; s| |\\\ |g;}")

    ## 替换 pt_key
    ssh -o "StrictHostKeyChecking no" -T ${HostName} sed -i "s/${PtKeyOld}/${PtKeyLatest}/g" $HostConf
    if [ $? -eq 0 ]; then
        echo -e "${EscapePin} 同步完成 \033[32m[✔]\033[0m"
        ## 替换更新时间
        ssh -o "StrictHostKeyChecking no" -T ${HostName} sed -i "s/上次更新：${UpdateDateOld}/上次更新：${UpdateDateLatest}/g" $HostConf
    else
        echo -e "${EscapePin} 同步失败 \033[31m[X]\033[0m"
    fi
done

echo ''
