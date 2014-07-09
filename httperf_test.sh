#!/bin/bash

#-----------------------------------------------
# パスが書かれたファイルをランダムに並べ替えて
# httperfで負荷をかけるプログラム
# クライアント側で使用
#-----------------------------------------------

HTTPERF='/home/shimada-k/httperf-0.9.0/src/httperf'
SERVER='192.168.3.3'

if [ ! ${#} -eq 1 ]; then
    echo 'usage: httperf_text [num request rate]'
    exit 0;
fi

RATE=${1}
NUM_CONNS=`expr ${1} \* 50`

# echo ${RATE}
# echo ${NUM_CONNS}

# ランダムに並べ替える
cat list_text_ssd | sort -R > list_text_random
echo 'sort file is ready'

# httperfが読み込めるようにnull区切りのファイルにする
cat list_text_random | tr "\n" "\0" > list_text_uri
echo 'httperf uri file is ready'

echo "${HTTPERF} --hog --server=${SERVER} --port=80 --uri=/ --wlog=Y,/home/shimada-k/list_text_uri --rate=${RATE} --num-conns=${NUM_CONNS}"
${HTTPERF} --hog --server=${SERVER} --port=80 --uri=/ --wlog=Y,/home/shimada-k/list_text_uri --rate=${RATE} --num-conns=${NUM_CONNS}

