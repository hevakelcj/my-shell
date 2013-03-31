#!/bin/sh

# 
# this shell is used to backup our *.nb files
# 1. create folder ./backup/notebook-YYMMDD
# 2. copy all *.nb files to that folder
# 

echo **********开始备份日志文件**********

ymd=`date +%Y%m%d`
backup="./backup/notebook-$ymd"
echo 备份目录：$backup

echo ------------------------------------

if ! [ -d $backup ] ; then 
    mkdir -p $backup
fi

cp *.nb $backup

echo ***********日志备份完成！***********
