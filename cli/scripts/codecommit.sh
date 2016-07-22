#!/bin/bash



## CodeCommit
# 上传公钥到git服务器
aws iam upload-ssh-public-key --ssh-public-key-body file://codecommit_rsa.pub --user-name leodev
# 显示public keys
aws iam list-ssh-public-keys --user-name leodev --output json
# 删除指定用户指定public-key-id
aws iam delete-ssh-public-key --user-name leodev --ssh-public-key-id APKAJWIFUXGVRZXB5AZQ
