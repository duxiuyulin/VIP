#!/usr/bin/env bash
## Mod: Build2021125V1
## 添加你需要重启自动执行的任意命令，比如 ql repo
## 安装node依赖使用 pnpm install -g xxx xxx（Build 20210728-002 及以上版本的 code.sh，可忽略）
## 安装python依赖使用 pip3 install xxx（Build2021125V1 及以上版本的 extra.sh，可忽略）

#------ 说明区 ------#
## 1. 拉取仓库
### （1）定时任务→添加定时→命令【ql extra】→定时规则【15 0-23/4 * * *】→运行
### （2）若运行过 1custom 一键脚本，点击运行即可
### （3）推荐配置：如下。自行在设置区填写编号
## 2. 安装依赖
### （1）默认不安装nodejs依赖，因为 Build 20210728-002 及以上版本的 code.sh 自动检查修复依赖
### （2）若需要在此处使用，请在设置区设置
## 3. Ninja
### （1）默认启动并自动更新
### （2）⚠未修改容器映射的请勿运行，否则会出现青龙打不开或者设备死机等不良后果，映射参考 https://github.com/MoonBegonia/ninja#%E5%AE%B9%E5%99%A8%E5%86%85

#------ 设置区 ------#
# shellcheck disable=SC2005
## 1. 拉取仓库编号设置，默认 shufflewzc 仓库
CollectedRepo=(4) ##示例：CollectedRepo=(2 4 6)
OtherRepo=()      ##示例：OtherRepo=(1 3)
## 2. 是否安装依赖和安装依赖包的名称设置
dependencies="al py pl" ##yes为全部安装，no为不安装，al为安装alpine依赖，py为安装python依赖，js为安装nodejs依赖，pl为安装perl依赖
alpine_pkgs="bash curl gcc git jq libffi-dev make musl-dev openssl-dev perl perl-app-cpanminus perl-dev py3-pip python3 python3-dev wget"
py_reqs="bs4 cryptography pyaes requests rsa tomli"
js_pkgs="@iarna/toml axios crypto-js got"
pl_mods="File::Slurp JSON5 TOML::Dumper"
## 3. Ninja 是否需要启动和更新设置
Ninja="on" ##up为更新，on为启动，down为不运行

#------ 编号区 ------#
: <<\EOF
一、集成仓库（Collected Repositories)
2-JDHelloWorld
3-he1pu
4-shufflewzc
6-Aaron-lv
7-yuannian1112
二、其他仓库（Other Repositories）
1-passerby-b
2-curtinlv
3-smiek2221
4-cdle
5-ZCY01
6-whyour/hundun
7-moposmall
8-Ariszy (Zhiyi-N)
9-photonmang
10-jiulan
12-star261
13-Wenmoux
14-Tsukasa007
15-ccwav
EOF

#------ 代码区 ------#
# 🌱拉取仓库
CR2() {
    ql repo https://github.com/JDHelloWorld/jd_scripts.git "jd_|jx_|getJDCookie" "activity|backUp|Coupon|enen|update|test" "^jd[^_]|USER|^TS|utils|notify|env|package|ken.js"
}
CR3() {
    ql repo https://github.com/he1pu/JDHelp.git "jd_|jx_|getJDCookie" "Coupon|update" "^jd[^_]|USER|^sign|^ZooFaker|utils"
}
CR4() {
    ql repo https://github.com/shufflewzc/faker2.git "jd_|jx_|gua_|jddj_|getJDCookie" "activity|backUp|Coupon|update" "^jd[^_]|USER|utils|function|^JS|^TS|^JDJRValidator_Pure|^ZooFaker|^sign|ql"
}
CR6() {
    ql repo https://github.com/Aaron-lv/sync.git "jd_|jx_|getJDCookie" "activity|backUp|Coupon" "^jd[^_]|USER|utils" "jd_scripts"
}
CR7() {
    ql repo https://github.com/yuannian1112/jd_scripts.git "jd_|jx_|getJDCookie" "activity|backUp" "^jd[^_]|USER|utils"
}
for i in "${CollectedRepo[@]}"; do
    CR"$i"
    sleep 10
done

OR1() {
    ql repo https://github.com/passerby-b/JDDJ.git "jddj_" "scf_test_event|jddj_fruit_code.js|jddj_getck.js|jd_|jddj_cookie"
}
OR2() {
    ql repo https://github.com/curtinlv/JD-Script.git "jd_"
}
OR3() {
    ql repo https://github.com/smiek2121/scripts.git "jd_|gua_" "" "^MovementFaker|^JDJRValidator|^ZooFaker|^sign|^cleancart"
}
OR4() {
    ql repo https://github.com/cdle/xdd.git "jd_" "disposable|expired|jdc"
}
OR5() {
    ql repo https://github.com/ZCY01/daily_scripts.git "jd_"
}
OR6() {
    ql repo https://github.com/whyour/hundun.git "quanx" "tokens|caiyun|didi|donate|fold|Env"
}
OR7() {
    ql repo https://github.com/moposmall/Script.git "Me"
}
OR8() {
    ql repo https://github.com/Ariszy/Private-Script.git "JD"
}
OR9() {
    ql repo https://github.com/photonmang/quantumultX.git "JDscripts"
}
OR10() {
    ql repo https://github.com/jiulan/platypus.git "jd_|jx_" "" "overdue" "main"
}
OR11() {
    ql repo https://github.com/panghu999/panghu.git "jd_"
}
OR12() {
    ql repo https://github.com/star261/jd.git "jd_|star" "" "code" "main"
}
OR13() {
    ql repo https://github.com/Wenmoux/scripts.git "other|jd" "" "" "wen"
}
OR14() {
    ql repo https://github.com/Tsukasa007/my_script.git "jd_|jx_" "jdCookie|USER_AGENTS|sendNotify|backup" "" "master"
}
OR15() {
    ql repo https://github.com/ccwav/QLScript2.git "jd_" "NoUsed" "ql|utils"
}
for i in "${OtherRepo[@]}"; do
    OR"$i"
    sleep 5
done

# 🍪Ninja
update_Ninja_normal() {
    cd /ql/ninja/backend && git checkout . && git pull
    pnpm install && pm2 start
    cp sendNotify.js /ql/scripts/sendNotify.js
}

check_Ninja_normal() {
    NOWTIME=$(date +%Y-%m-%d-%H-%M-%S)
    i=0
    while ((i <= 0)); do
        echo "扫描 Ninja 是否在线"
        if [ -z "$(pgrep -f ninja)" ]; then
            i=0
            echo "$NOWTIME"" 扫描结束！Ninja 掉线了不用担心马上重启！"
            cd /ql || exit
            pgrep -f ninja | xargs kill -9
            cd /ql/ninja/backend || exit
            pnpm install
            pm2 start
            if [ -n "$(pgrep -f Daemon)" ]; then
                i=1
                echo "$NOWTIME"" Ninja 重启完成！"
                curl "https://api.telegram.org/bot$TG_BOT_TOKEN/sendMessage?chat_id=$TG_USER_ID&text=Ninja 已重启完成"
            fi
        else
            i=1
            echo "$NOWTIME"" 扫描结束！Ninja 还在！"
        fi
    done
}

if [ "$Ninja" = "up" ]; then
    update_Ninja_normal &
elif [ "$Ninja" = "on" ]; then
    check_Ninja_normal
fi

# 📦依赖
# shellcheck disable=SC2015
install() {
    count=0
    flag=$1
    while true; do
        echo ".......... $2 begin .........."
        result=$3
        if [ "$result" -gt 0 ]; then
            flag=0
        else
            flag=1
        fi
        if [ $flag -eq "$1" ]; then
            echo "---------- $2 succeed ----------"
            break
        else
            count=$((count + 1))
            if [ $count -eq 6 ]; then
                echo "!! 自动安装失败，请尝试进入容器后执行 $2 !!"
                break
            fi
            echo ".......... retry in 5 seconds .........."
            sleep 5
        fi
    done
}

install_alpine_pkgs() {
    apk update
    apk_info=" $(apk info) "
    for i in $alpine_pkgs; do
        if expr "$apk_info" : ".*\s${i}\s.*" >/dev/null; then
            echo "$i 已安装"
        else
            install 0 "apk add $i" "$(apk add --no-cache "$i" | grep -c 'OK')"
        fi
    done
}

install_py_reqs() {
    pip3 install --upgrade pip
    pip3_freeze="$(pip3 freeze)"
    for i in $py_reqs; do
        if expr "$pip3_freeze" : ".*${i}" >/dev/null; then
            echo "$i 已安装"
        else
            install 0 "pip3 install $i" "$(pip3 install "$i" | grep -c 'Successfully')"
        fi
    done
}

install_js_pkgs_initial() {
    if [ -d "/ql/scripts" ] && [ ! -f "/ql/scripts/package.bak.json" ]; then
        cd /ql/scripts || exit
        rm -rf node_modules
        rm -rf .pnpm-store
        mv package-lock.json package-lock.bak.json
        mv package.json package.bak.json
        mv pnpm-lock.yaml pnpm-lock.bak.yaml
        install 1 "npm install -g package-merge" "$(echo "$(npm install -g package-merge && npm ls -g package-merge)" | grep -cE '(empty)|ERR')" &&
            export NODE_PATH="/usr/local/lib/node_modules" &&
            node -e \
                "const merge = require('package-merge');
                 const fs = require('fs');
                 const dst = fs.readFileSync('/ql/repo/Oreomeow_checkinpanel_master/package.json');
                 const src = fs.readFileSync('/ql/scripts/package.bak.json');
                 fs.writeFile('/ql/scripts/package.json', merge(dst, src), function (err) {
                     if (err) {
                         console.log(err);
                     }
                     console.log('package.json merged successfully!');
                 });"
    fi
    npm install
}
install_js_pkgs_each() {
    is_empty=$(npm ls "$1" | grep empty)
    has_err=$(npm ls "$1" | grep ERR)
    if [ "$is_empty" = "" ] && [ "$has_err" = "" ]; then
        echo "$1 已正确安装"
    elif [ "$has_err" != "" ]; then
        uninstall_js_pkgs "$1"
    else
        install 1 "npm install $1" "$(echo "$(npm install --force "$1" && npm ls --force "$1")" | grep -cE '(empty)|ERR')"
    fi
}
uninstall_js_pkgs() {
    npm uninstall "$1"
    rm -rf "$(pwd)"/node_modules/"$1"
    rm -rf /usr/local/lib/node_modules/lodash/*
    npm cache clear --force
}
install_js_pkgs_all() {
    install_js_pkgs_initial
    for i in $js_pkgs; do
        install_js_pkgs_each "$i"
    done
    npm ls --depth 0
}

install_pl_mods() {
    if command -v cpm >/dev/null 2>&1; then
        echo "App::cpm 已安装"
    else
        install 1 "cpanm -fn App::cpm" "$(cpanm -fn App::cpm | grep -c "FAIL")"
        if ! command -v cpm >/dev/null 2>&1; then
            if [ -f ./cpm ]; then
                chmod +x cpm && ./cpm --version
            else
                cp -f /ql/repo/Oreomeow_checkinpanel_master/cpm ./ && chmod +x cpm && ./cpm --version
                if [ ! -f ./cpm ]; then
                    curl -fsSL https://cdn.jsdelivr.net/gh/Oreomeow/checkinpanel/cpm >cpm && chmod +x cpm && ./cpm --version
                fi
            fi
        fi
    fi
    for i in $pl_mods; do
        if [ -f "$(perldoc -l "$i")" ]; then
            echo "$i 已安装"
        else
            install 1 "cpm install -g $i" "$(cpm install -g "$i" | grep -c "FAIL")"
        fi
    done
}
[[ $dependencies == yes ]] && {
    install_alpine_pkgs
    install_py_reqs
    install_js_pkgs_all
    install_pl_mods
} &
[[ $dependencies == *al* ]] && install_alpine_pkgs &
[[ $dependencies == *py* ]] && install_py_reqs &
[[ $dependencies == *js* ]] && install_js_pkgs_all &
[[ $dependencies == *pl* ]] && install_pl_mods &
