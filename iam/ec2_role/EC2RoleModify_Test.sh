#!/bin/bash -x

global_new_role_test()
{
	PROFILE=global

	# 新增角色定义
	aws --profile $PROFILE iam create-role --role-name BastionRole --assume-role-policy-document file://BastionRole-Trust-Policy.json
	# 新增角色内建规则
	aws --profile $PROFILE iam attach-role-policy --role-name BastionRole --policy-arn arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess
	# 新增实例配置文件
	aws --profile $PROFILE iam create-instance-profile --instance-profile-name BastionRole-Instance-Profile
	# 实例配置文件和角色绑定
	aws --profile $PROFILE iam add-role-to-instance-profile --role-name BastionRole --instance-profile-name BastionRole-Instance-Profile
	# 实例配置文件和实例绑定
	aws --profile $PROFILE ec2 associate-iam-instance-profile --instance-id i-f5a28508 --iam-instance-profile Name=BastionRole-Instance-Profile

}


bjs_new_role_test()
{
	PROFILE=bjs

	aws --profile $PROFILE iam create-role --role-name BastionRole --assume-role-policy-document file://BastionRole-BJS-Trust-Policy.json

	aws --profile $PROFILE iam attach-role-policy --role-name BastionRole --policy-arn arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess
	aws --profile $PROFILE iam create-instance-profile --instance-profile-name BastionRole-Instance-Profile
	aws --profile $PROFILE iam add-role-to-instance-profile --role-name BastionRole --instance-profile-name BastionRole-Instance-Profile

	aws --profile $PROFILE ec2 associate-iam-instance-profile --instance-id i-79dc1741 --iam-instance-profile Name=BastionRole-Instance-Profile

}

replace_role_test()
{
	PROFILE=default
	ID=i-79dc1741x
	YOUR_PLACEMENT_INSTANCE_PROFILE=YourReplacementRole-Instance-Profile

	# 获取当前实例绑定的IAM profile ID
	# 演示过滤和输出条件书写
	# aws --profile $PROFILE ec2 describe-iam-instance-profile-associations --filters "Name=instance-id,Values=$ID" --query 'IamInstanceProfileAssociations[*].{InstanceId:InstanceId,AssociationId:AssociationId}' --output table
	# 获取目标替换EC2当前使用的IAM 实例配置文件ID
	ASSOCIATION_ID=$(aws --profile $PROFILE ec2 describe-iam-instance-profile-associations --filters "Name=instance-id,Values=$ID" --query 'IamInstanceProfileAssociations[*].[AssociationId]' --output text)

	if [ "_${ASSOCIATION_ID}" != "_" ]; then
		aws --profile $PROFILE ec2 replace-iam-instance-profile-association --association-id ${ASSOCIATION_ID} --iam-instance-profile Name=${YOUR_PLACEMENT_INSTANCE_PROFILE}
	else
		echo "Missing ASSOCIATION_ID for ID: $ID"
	fi


}

## Uncomment to enable test unit

# 1. AWS全球区域测试, 新增新的角色并绑定到未绑定角色的Amazon EC2实例
# global_new_role_test

# 2. AWS中国北京区域测试, 新增新的角色并绑定到未绑定角色的Amazon EC2实例
# bjs_new_role_test

# 3. AWS中国北京区域测试，使用的角色替换已经绑定的Amazon EC2上的角色
# replace_role_test

exit  0
