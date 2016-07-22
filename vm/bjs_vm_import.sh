#!/bin/bash

# ref:  http://docs.aws.amazon.com/AWSEC2/latest/CommandLineReference/ApiReference-cmd-ImportInstance.html


ACCESS_KEY_ID=xxxxxx
SECRET_ACCESS_KEY=xxxxxx
INSTANCE_TYPE=c3.xlarge
BUCKET_NAME=xxx-vm-import  # S3上可以先创建 xxx-vm-import 存储桶，用于上传镜像数据零时存储，上传完毕后，内容可以删除
REGION_NAME=cn-north-1
FILE_FORMAT=vmdk           # VMDK | RAW | VHD
ARCHITECTURE=x86_64        # i386 | x86_64
PLATFORM=linux             # linux, windows
VM_DISK_NAME=SLES11_SP3_FakeKernel-disk1.vmdk    # 需要导入的vmware镜像，

# 导入vmware镜像
ec2-import-instance -O ${ACCESS_KEY_ID} -W ${SECRET_ACCESS_KEY} -t ${INSTANCE_TYPE} -f ${FILE_FORMAT} -a ${ARCHITECTURE}  -p ${PLATFORM} -b ${BUCKET_NAME}  -o ${ACCESS_KEY_ID} -w ${SECRET_ACCESS_KEY} --region ${REGION_NAME}  ${VM_DISK_NAME}

# 显示转换状态
ec2-describe-conversion-tasks -O ${ACCESS_KEY_ID} -W ${SECRET_ACCESS_KEY}  --region ${REGION_NAME}
