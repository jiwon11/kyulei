#!/bin/bash

function main_command() {
    echo '명령어를 실행 중입니다.';
    sleep 1;
}

PIDFILE=/tmp/lock_example.pid

if [ -f $PIDFILE ];then
    PID=$(cat $PIDFILE);

    ps -p $PID > /dev/null 2>&1;

    if [ $? -eq 0 ];then
        echo "이미 실행 중입니다. PID: $PID";
        exit 1;
    else
        echo "$PIDFILE 는 존재하지만 프로세스가 실행 중이지 않습니다.";
        echo "상태를 확인해서 문자가 있다면 $PIDFILE 를 제거하고 다시 시작해주세요."
        exit 1;
    fi
fi

echo $$ > $PIDFILE;
echo "명령어를 실행합니다. 프로세스 ID: $(cat $PIDFILE)";
main_command
rm $PIDFILE;