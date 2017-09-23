#!/bin/bash

# http://docs.aws.amazon.com/vm-import/latest/userguide/vmimport-image-import.html#import-image-prereqs


# BJS aws -> aws-cn
aws iam create-role --role-name vmimport --assume-role-policy-document file://trust-policy.json
aws iam put-role-policy --role-name vmimport --policy-name vmimport --policy-document file://role-policy.json
aws ec2 import-image --description "Test" --license-type BYOL --disk-containers file://containers.json

aws ec2 describe-import-image-tasks --import-task-id import-ami-fgjbyw0g

#aws ec2 import-image --cli-input-json "{\"Description\": \"ERP linux vhd\",\"DiskContainers\": [ { \"Description\": \"First CLI task\", \"UserBucket\": { \"S3Bucket\":\"leo-vm-import\", \"S3Key\" : \"TestCentOS-disk1.vmdk\" } } ]}"


#A client error (AuthFailure) occurred when calling the ImportImage operation: This request has been administratively disabled.

#处理方案： 使用旧的ec2-import-instance 附上BJS上已经测试过可用的脚本

#前提条件: S3可以上传，简单说 80,443要开

#导入vmdk创建instance
#ec2-import-instance -O AKIAPPV4EBOS32***** -W uZsBTaMNjovoEqslsejqf8xGs8********R -t m3.xlarge -f vmdk -a x86_64 -p Linux -b leopublic -o AKIAPPV4EBOS32***** -w uZsBTaMNjovoEqslsejqf8xGs8********R --region cn-north-1 SLES11_SP3_FakeKernel-disk1.vmdk
#
#显示状态
#ec2-describe-conversion-tasks -O AKIAPPV4EBOS32***** -W uZsBTaMNjovoEqslsejqf8xGs8********R --region cn-north-1 
