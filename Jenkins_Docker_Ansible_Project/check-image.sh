#!/bin/sh
#Script to check image status
#if image is running already this script will kill it

docker ps | grep apache

if [ $? = 0 ];then
  docker stop apache && docker rm apache
else
  echo "apache container is not running"
fi
