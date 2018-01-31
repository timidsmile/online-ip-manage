#!/bin/bash
#=========================
# 生成ip列表和更新ip列表的核心模块
# 快速更新一个模块的ip地址
# 输入要更新模块的ip文件名字
# 文件名字用模块名.ip 命名,输入的是全路径
# 如果该模块有php和java两个版本，分别用php-  trade- 为开头，后面跟模块名
# 用到了shell的map类型，需要最新bash执行
#========================
full_path_name=$1
if [ "$full_path_name" = "" ];then
    echo "need param file_name ! "
    echo "Usage: ex, sh update.sh passport.ip ! "
    exit
fi
#去掉路径前缀
file_name=$(basename $full_path_name)

workdir=$(cd `dirname $0`; pwd)
cd $workdir

#数据库连接相关信息
USER="root"
DATABASE="tools"
TABLE="online_ip"


#---------------function---------
function getModuleId() {
    module_name=$1

    sql="SELECT module_id FROM online_module WHERE module_name='$module_name';"
    rows=`mysql -u$USER $DATABASE -e "$sql"`   
    rows=`echo $rows | awk '{print $2}'`
    echo $rows
}

#---------------main function-----

# 从数据库读取env id 与 env name的映射关系
declare -A ENV_MAP
sql="SELECT env_name, env_id FROM online_env;"
rows=`mysql -u$USER $DATABASE -e "$sql"`
tmp=""
for row in $rows;do
    if [[ "$tmp" != '' ]];then
       ENV_MAP[$tmp]=$row
       #echo "key=" $tmp "value=" $row
       tmp=''
    else
       tmp=$row
   fi
done 

#根据文件名获取模块名及其对应的编号
module_name=`echo ${file_name%.*}`
#module_name=`echo ${module_name#*-}`
#模块id从数据库中查找
module_id=`getModuleId $module_name`

if [[ $module_id = '' || $module_id = 0 ]];then
    echo "FATAL: failed to get module_id! module_name: " $module_name
    exit
fi

#先把对应的该模块的所有ip置为无效,插入时再更新
sql="UPDATE online_ip set status=0 where module_id=$module_id"
mysql -u$USER $DATABASE -e "$sql"

#重新插入新的ip列表
awk '{print $2,$4}' $full_path_name> $workdir/file.tmp
cat file.tmp | while read line
do
    ip=`echo $line | awk '{print $1}'`
    env_name=`echo $line | awk '{print $2}'`
    tmp_env_name=`echo ${env_name%-*}`
    tmp_env_name=`echo ${tmp_env_name%_*}`
    env_id=${ENV_MAP[$tmp_env_name]}
    
    if [[ $env_id = '' || $env_id = 0 ]];then
        echo "FATAL: failed to get env_id! env_name: " $env_name
        exit
    fi

    sql="insert ignore into online_ip(ip, module_id, module_name,env_id, env_name,status) values ('$ip', $module_id, '$module_name', $env_id, '$env_name', 1)  on duplicate key update module_id=$module_id, module_name='$module_name',env_id=$env_id, env_name='$env_name',status=1;"

    mysql -u$USER $DATABASE -e "$sql"

    #echo $sql
done





