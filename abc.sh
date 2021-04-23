#!/bin/bash

package=$1
cmd=$2
date=`date '+%Y%m%d-%H%M'`
deploy_path="/home/dingning/deploy"
path="/data/bigdata/zllis"
bak_path="/data/backup/"

echo "$date"
if [ x"$cmd" = "x"  ];then
  if [ "$package" = "jar" ];then
    jar=$(ls $deploy_path | grep jar)
    echo "$jar"
    if [ x"$jar" = "x" ]; then
      echo "未上传生产后端jar包，请先上传再部署" > /home/dingning/ops/results
      exit 1
    else
      cd $path
      mkdir $bak_path/$date
      mv *.jar  $bak_path/$date
      mv $deploy_path/*.jar ./
      pid=$(ps -ef | grep "java" | grep "prod" | grep -v 'grep' | grep -v "$0" | awk '{print $2}')
      echo $pid
      kill -9 $pid
      sleep 3
      nohup java -jar pets-api-0.0.1-SNAPSHOT.jar --spring.profiles.active=prod >/data/bigdata/logs/zllis/zllis.log 2>&1 &
      echo "生产后端部署完成" > /home/dingning/ops/results
      cd $bak_path
      ls -rt|head -1|xargs rm -rf
    fi

  elif [ "$package" = "zip" ];then
    zip=$(ls $deploy_path | grep zip)
    if [ x"$zip" = "x" ]; then
      echo "未上传生产前端zip包，请先上传再部署" > /home/dingning/ops/results
      exit 1
    else
      cd $path
      rm -rf buildbak/
      mv build/ buildbak/
      mv $deploy_path/*.zip ./
      name=$(ls|grep zip)
      echo "$name"
      unzip $name
      rm -rf $name
      echo "生产前端部署完成" > /home/dingning/ops/results
    fi
  else
  echo "未知问题，请检查" > /home/dingning/ops/results
  fi
else
  cd $path
  rm *.jar -rf
  cp $bak_path/$package/*.jar ./
  pid=$(ps -ef | grep "java" | grep "prod" | grep -v 'grep' | grep -v "$0" | awk '{print $2}')
  echo $pid
  kill -9 $pid
  sleep 3
  nohup java -jar pets-api-0.0.1-SNAPSHOT.jar --spring.profiles.active=prod >/data/bigdata/logs/zllis/zllis.log 2>&1 &
  echo "生产后端回滚完成" > /home/dingning/ops/results
fi
