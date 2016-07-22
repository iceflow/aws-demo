aws ec2 import-image --cli-input-json "{\"Description\": \"ERP linux vhd\",\"DiskContainers\": [ { \"Description\": \"First CLI task\", \"UserBucket\": { \"S3Bucket\":\"aviagebucket/ERPtest\", \"S3Key\" : \"linux5.5_disk1.vhd\" } } ]}"

#A client error (AuthFailure) occurred when calling the ImportImage operation: This request has been administratively disabled.

#处理方案： 使用旧的ec2-import-instance 附上BJS上已经测试过可用的脚本

#前提条件: S3可以上传，简单说 80,443要开

#导入vmdk创建instance
ec2-import-instance -O AKIAPPV4EBOS32***** -W uZsBTaMNjovoEqslsejqf8xGs8********R -t m3.xlarge -f vmdk -a x86_64 -p Linux -b leopublic -o AKIAPPV4EBOS32***** -w uZsBTaMNjovoEqslsejqf8xGs8********R --region cn-north-1 SLES11_SP3_FakeKernel-disk1.vmdk

#显示状态
ec2-describe-conversion-tasks -O AKIAPPV4EBOS32***** -W uZsBTaMNjovoEqslsejqf8xGs8********R --region cn-north-1 
