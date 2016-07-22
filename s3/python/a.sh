#!/bin/bash


declare int N


H=matest.cuivkfbunaay.rds.cn-north-1.amazonaws.com.cn
#H=ddddd.cuivkfbunaay.rds.cn-north-1.amazonaws.com.cn 

N=1

while [ 1 ]; do
	echo $N
dig matest.cuivkfbunaay.rds.cn-north-1.amazonaws.com.cn | grep ec2 | grep -v CNAME | awk '{print $5}'
mysql -h$H -pleochen81 -e "select task_id,subject from test.tasks";
#mysql -h$H -pleochen81


	sleep 1
	let N=N+1
done
