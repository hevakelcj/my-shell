#!/bin/sh

##################################
Port=5743
ECHO=echo
##################################

SendStr() {
    echo "$@" | nc $IP $Port
}

SendFile() {
    nc $IP $Port < $@
}

RecieveStr() {
    nc $IP $Port
}

RecieveFile() {
    nc $IP $Port > $@
}

Wait() {
    sleep 0.05
}

##################################
if [ ! $# -eq 2 ]; then
    $ECHO "Usage: $0 <DistIP> <FileName>"
    exit
fi

IP=$1
# 测量是否能ping通对方
if not ping -c1 $IP > /dev/null 2>&1; then
    $ECHO "Network is not avaiable."
fi

FileName=$2
$ECHO "Send file: $FileName"
# 发送send-file命令
SendStr 'send-file'
Wait

# 发送文件名
SendStr $FileName
Wait

# 发送传递文件
$ECHO "Sending file data..."
SendFile $FileName
Wait

# 发送本地的md5sum校验码
checksum=`md5sum $FileName | awk '{print \$1}'`
SendStr $checksum
Wait

# 接收回馈
feedback="-`RecieveStr`"
if [ $feedback = '-Success' ]; then
    $ECHO "Send success."
elif [ $feedback = '-Fail' ]; then
    $ECHO "Send fail."
    $ECHO $checksum
else
    $ECHO "Remote reciever doesn't respond."
fi
