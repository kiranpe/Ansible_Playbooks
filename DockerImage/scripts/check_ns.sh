#!/bin/bash

#Written by kiran to check ns exist or not

kubectl get ns | grep com-att-oce-test 

if [ $? = 0 ];then
echo "ns already present.."
else
kubectl create ns com-att-oce-test
fi
