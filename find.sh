#!/bin/bash
module_name=$1
env_name=$2

if [ "$module_name" = "" ];then
   echo "need args: module_name {env_name}!"
   exit
fi

USER="root"
DATABASE="tools"
TABLE="online_ip"

#--------------------main function-----------
# 从数据库读取env id 与 env name的映射关系
declare -A ENV_MAP
sql="SELECT env_name, env_id FROM online_env;"
rows=`mysql -u$USER $DATABASE -e "$sql"`
tmp=""
for row in $rows;do
    if [[ "$tmp" != '' ]];then
       ENV_MAP[$tmp]=$row
       # echo "key=" $tmp "value=" $row
       tmp=''
    else
       tmp=$row
   fi
done

COMMAND1="mysql -u$USER $DATABASE" 
declare -A RESULT
if [ "$env_name" = "" ];then
    sql="select id,ip,module_id,module_name,env_id,env_name,status from $TABLE where module_name like '%$module_name%' and status=1;"
 else
    env_id=${ENV_MAP[$env_name]}
    sql="select id,ip,module_id,module_name,env_id,env_name,status from $TABLE where module_name like '%$module_name%' and env_id=$env_id and status=1;"
fi


while read -a row
do
    if [ RESULT[${row[3]}] = "" ];then
        RESULT[${row[3]}]=${row[1]}
    else
        RESULT[${row[3]}]=${RESULT[${row[3]}]}" "${row[1]}
    fi
done< <(echo $sql | ${COMMAND1})



for module_name in ${!RESULT[@]}  
do  
    echo $module_name": "
    for ip in ${RESULT[$module_name]}  
    do
         echo $ip
    done
done  
