#!/bin/bash
#=============================
# online tool 的封装
# .zshrc中直接调用的脚本
# 封装了创建、更新、查找功能
#============================

cmd="$1"
if [ "$cmd" = "" ]; then
    echo "Usage: online [command]"
    echo "[command]:"
    echo "         create : 重新生成ip列表"
    echo "         update [module_name] : 更新某模块地址(先编辑ip列表，然后自动更新该模块ip列表)"
    echo "         find   [module_name] {env} : 根据模块名查找对应的ip列表"
fi

workdir=$(cd `dirname $0`; pwd)
cd $workdir

#下面两个目录分别用来存放所有ip列表和当前要更改的ip列表
create_dir=".ip"
update_dir=".current_update_ip"

case $cmd in
    "create")
     #重新生成online_ip数据库
     sh $workdir/build.sh $create_dir
;;
    "update")
    module_name=$2
    if [ "$module_name" = "" ]; then
        echo "command update need specify module name!"
        echo "Usage: ex, online update trade-account"
        exit
    fi
    
    update_module_ip_file=$module_name".ip"
    update_file_full_path="$workdir/$update_dir/$update_module_ip_file"
    vim $update_file_full_path
    echo "pls enter any key to go on..."
    read key
    sh $workdir/build.sh $update_dir
    # 将update之后的ip列表移到库中更新替换保存
    mv $update_file_full_path "$workdir/$create_dir/" 

;;
    "find")
    bash $workdir/find.sh $2 $3 
;;
*)
esac
