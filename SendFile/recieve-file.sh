#!/bin/sh

##################################
Port=5743
FileSavePath=./
TempFile=temp
ECHO=echo
##################################

CheckPortUsage() {
    netstat -nlptu 2>/dev/null | awk "\$4~/$1/ {print $7}" | wc -l
}

SendStr() {
    echo "$@" | nc -l $Port
}

SendFile() {
    nc -l $Port < $@
}

RecieveStr() {
    nc -l $Port
}

RecieveFile() {
    nc -l $Port > $@
}

RecieveFileFromClient()
{
    # 获取文件名
    local FileName=`RecieveStr`
    $ECHO "File name: $FileName"

    # 接收文件
    $ECHO "Recieveing file data."
    RecieveFile $TempFile
    $ECHO "Done"

    # 用md5sum验证文件
    $ECHO "Verify this file."
    local RemoteCheckSum=`RecieveStr`
    local LocalCheckSum=`md5sum $TempFile | awk '{print \$1}'`

    # 比较验证码
    if [ $RemoteCheckSum = $LocalCheckSum ]; then
        $ECHO 'Success.'
        local FileFullName=$FileSavePath/$FileName
        mv $TempFile $FileFullName
        SendStr "Success"
    else
        $ECHO Fail.
        $ECHO "R:$RemoteCheckSum"
        $ECHO "L:$LocalCheckSum"
        SendStr 'Fail'
        rm $TempFile
    fi
}

##################################
# 检查端口是否已被占用
is_port_used=`CheckPortUsage $Port`
if [ $is_port_used -gt 0 ]; then
    $ECHO "Port $Port is used."
    exit
fi

# 如果用户指定了文件保存目录，且这个目录存在
if [ $# -gt 0 ] && [ -d $1 ] ; then
    FileSavePath=$1
fi

$ECHO "Waiting for request ..."
cmd=`RecieveStr`
if [ $cmd = 'send-file' ]; then
    RecieveFileFromClient
else
    $ECHO "Unknow command: $cmd"
fi
