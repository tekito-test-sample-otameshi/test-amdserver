#!/bin/sh
# -*- coding: utf-8 -*-

# Fujitsu RX2530M2 省電力機能無効化影響検査用スクリプト
# 専用サーバ負荷試験を、時刻を記録しながら順次行う

# 測定と測定の間の待機時間 [分]
INTERVAL_SLEEP_MINUTES=10



########### ここからテスト用パラメータの整理
# ハードウェアスペックを調べる
# 論理 CPU 数
CPU_THREADS=`grep '^processor[^:]*:' /proc/cpuinfo | wc -l`

# 全メモリ容量 [kBytes]
MEM_KBYTES=`grep --max-count=1 '^MemTotal:' /proc/meminfo | awk '{ print $2 }'`

echo "# 測定条件"
echo "# 論理 CPU 数 : ${CPU_THREADS}"

# メモリ容量の 90% を計算（小数は切り捨て） [kBytes]
MEM_90PERCENT_KBYTES="`echo "${MEM_KBYTES} * 0.9" | bc | cut -d. -f1`"
echo "# 搭載メモリ全容量 : ${MEM_KBYTES} kB"
echo "# （搭載メモリの 90% : ${MEM_90PERCENT_KBYTES} kB）"
echo -e "\n\n"
echo "# 測定間のインターバル ${INTERVAL_SLEEP_MINUTES} 分間"
echo -e "\n\n"


# テストを実行する関数
# 1つ目の引数 : 実行コマンド
# 2つ目の引数 : 表示名称
ExecuteTest(){
    echo "############"
    echo "# [Begin] $2 Test"
    echo "#  StartTime : `date '+%s %Y/%m/%dT%H:%M:%S+0900'`"
    echo "#  CommandLine : $1"
    $1
    echo "#  Exit Status : $?"
    echo "#  EndTime : `date '+%s %Y/%m/%dT%H:%M:%S+0900'`"
    echo "# [End] $2 Test"
    echo "############"
    echo -e "\n\n"
}

# テスト間の sleep している時間を表示する関数
# 1つ目の引数 : sleep 時間
SleepForInterval(){
    echo "############"
    echo "# [Begin] Sleep $1"
    echo "#  StartTime : `date '+%s %Y/%m/%dT%H:%M:%S+0900'`"
    sleep $1
    echo "#  Exit Status : $?"
    echo "#  EndTime : `date '+%s %Y/%m/%dT%H:%M:%S+0900'`"
    echo "# [End] Sleep $1"
    echo "############"
    echo -e "\n\n"
    }


# NTP サーバとの日時のズレを表示
echo "# 時刻同期状況"
ntpdate -d ntp1.sakura.ad.jp 2>/dev/null | tail -1
echo -e "\n\n"


########### ここからテスト手順の記述

# 10分のインターバルを確保
SleepForInterval ${INTERVAL_SLEEP_MINUTES}m


# CPU 負荷テスト
CMD_CPU_STRESS="stress --cpu ${CPU_THREADS} --timeout 15m"
ExecuteTest "${CMD_CPU_STRESS}" 'CPU'

# 10分のインターバルを確保
SleepForInterval ${INTERVAL_SLEEP_MINUTES}m


# RAM 負荷テスト
CMD_RAM_STRESS="stress --vm 1 --vm-bytes ${MEM_90PERCENT_KBYTES}K --timeout 15m"
ExecuteTest "${CMD_RAM_STRESS}" 'RAM'

# 10分のインターバルを確保
SleepForInterval ${INTERVAL_SLEEP_MINUTES}m


# DISK 負荷テスト
CMD_DISK_STRESS='stress --hdd 2 --hdd-bytes 10G --timeout 15m'
ExecuteTest "${CMD_DISK_STRESS}" 'Disk'

# 10分のインターバルを確保
SleepForInterval ${INTERVAL_SLEEP_MINUTES}m


# Idle 負荷テスト
CMD_IDLE_STRESS='sleep 15m'
ExecuteTest "${CMD_IDLE_STRESS}" 'Idle'

# 10分のインターバルを確保
SleepForInterval ${INTERVAL_SLEEP_MINUTES}m


# ALL 負荷テスト
CMD_ALL_STRESS="stress --cpu ${CPU_THREADS} \
                --vm 1 --vm-bytes ${MEM_90PERCENT_KBYTES}K \
                --hdd 2 --hdd-bytes 10G \
                --timeout 20m"
ExecuteTest "${CMD_ALL_STRESS}" 'ALL'






## C-State 設定状況の表示
#echo "# powertop -d "
#powertop -d
#echo -e "\n\n"

# dmesg の冒頭（Command line :行のあたり）を表示
echo "# dmesg | head -4"
dmesg | head -4
echo -e "\n\n"

exit 0
