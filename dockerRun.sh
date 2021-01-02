#!/bin/sh
#说明
show_usage="args: [-n , -p , -a , -r , -t, -o]\
                                  [--name=, --port=, --args=, --repository=, --tag, --operate]"
#参数
# 容器名称
opt_name=""

# 启动参数
opt_args=""

# 仓库地址
opt_repository=""

##  操作
opt_operate=""

GETOPT_ARGS=`getopt -o n:a:r:o: -al name:,args:,repository:,operate: -- "$@"`
eval set -- "$GETOPT_ARGS"

start(){
    processId=$(cat ./run.pid)
    if  [ ! -n "$processId" ] ;then
        echo "新建容器,开始启动"
        docker run  --name $opt_name  $opt_args -d $opt_repository  >  ./run.pid
    else
        echo "启动容器"
        docker start $processId
    fi
}

stop(){
    processId=$(cat ./run.pid)
    echo $processId
    #kill -9 $processId
    docker stop $processId
}
# 删除镜像
rmImage(){
    processId=$(cat ./run.pid)
    if  [ ! -n "$processId" ] ;then
       echo "当前镜像不存在容器,直接杀死"
    else
       docker rm -f $processId
    fi      
    imageName="$opt_repository";
    echo "删除镜像:$imageName"
    docker rmi $imageName;
}

#获取参数
while [ -n "$1" ]
do
        case "$1" in
                -n|--name) opt_name=$2; shift 2;;
                -a|--args) opt_args=$2; shift 2;;
                -r|--repository) opt_repository=$2; shift 2;;
                -o|--operate) opt_operate=$2; shift 2;;
                --) break ;;
                *) echo $1,$2,$show_usage; break ;;
        esac
done
if [[ -z $opt_name  || -z $opt_args || -z $opt_repository || -z $opt_operate ]]; then
        echo $opt_operate
        echo $show_usage
        echo "opt_name: $opt_name ,  opt_args: $opt_args , opt_repository: $opt_repository , opt_operate: $opt_operate"
        exit 0
else
    echo "opt_name: $opt_name  , opt_args: $opt_args , opt_repository: $opt_repository , opt_operate: $opt_operate"
    case $opt_operate in 
      start)
       
       start
       echo "启动完成！PID：$(cat ./run.pid)"
      ;;
      stop)
       stop
       echo "关闭完成!"
      ;;
      update)
       rmImage
       rm -f  ./run.pid
       start
       #dockerImage="$opt_repository $opt_tag"
       #echo $dockerImage
       #echo "更新完成!"
      ;;

   # exit 0
    esac

fi