#!/bin/bash

#================================
# 封装了update.sh
# 对外展示模块
# 可以实现ip列表创建与更新
#===============================
workdir=$(cd `dirname $0`; pwd)
cd $workdir

#*.ip文件存放目录
if [ "$1" = "" ];then
    file_ip='.ip'
else
    file_ip="$1"
fi

file_dir=$workdir"/"$file_ip
if [ ! -d "$file_dir" ]; then
    echo "ip file dir not exits: " $file_ip 
fi

file_list=`ls $file_dir`
if [ "$file_list" = "" ]; then
   echo "no file need to deal!"
   echo "pls put *.ip file to " $file_dir
fi

has_dealed_file=""
for file_name in $file_list
do
    post=`echo ${file_name#*.}`
    if [[ "$post" = 'ip' ]]; then
        # update sql according to this file
        echo 'deal ' $file_name '....'
        bash $workdir"/update.sh" $file_dir"/"$file_name 
        has_dealed_file=$has_dealed_file'\n'$file_name
    fi
done

echo "------------------------------"
echo "Done! Deals: " $has_dealed_file
