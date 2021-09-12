#!/bin/bash
#written by kiran
#This script is to build docker image and push it docker hub

#Change:1:Added health check
#Change:2:Added loop condition instead of sleep for container status

sudo docker build -t kiranp23/devopscasestudy:latest .

sudo docker run -p 7010:8080 --name casestudy -d kiranp23/devopscasestudy:latest

externalip=$(curl http://169.254.169.254/latest/meta-data/public-ipv4 2> /dev/null)

until $(curl -kIs http://${externalip}:7010 > /dev/null); do
    printf "\n"
    printf "Container is not up..Checking again..\n"
    sleep 5
done

echo "\n"
echo "Container is up and running..Doing Url health check..\n"
status=$(curl -kIs http://${externalip}:7010/casestudy/login.html | grep 200 | awk -F" " '{print $2}')
printf "Url Status is $status"
if [ $status = 200 ];then
echo "\n"
echo "image is good.. so pushing to docker hub and removing image from local and container also\n"
sudo docker push kiranp23/devopscasestudy:latest
sudo docker stop casestudy && sudo docker rm casestudy && sudo docker rmi kiranp23/devopscasestudy:latest
else
echo "\nimage is having issue... fix it\n"
fi
