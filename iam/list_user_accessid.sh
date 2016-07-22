#!/bin/bash

USERS=`aws iam list-users --query 'Users[].UserName' --output text`
CHECK_KEY=$1

for U in $USERS; do
	aws iam list-access-keys --user-name $U --query 'AccessKeyMetadata[*].[UserName,AccessKeyId]' --output text
done

exit 0
