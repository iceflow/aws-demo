#!/bin/bash

P=$1

USERS=`aws --profile $P iam list-users --query 'Users[].UserName' --output text`
CHECK_KEY=$2

for U in $USERS; do
    ACCESSKEYIDS=`aws --profile $P iam list-access-keys --user-name $U --query 'AccessKeyMetadata[*].AccessKeyId' --output text`

	echo "Checking user $U..."

    if [ "_${ACCESSKEYIDS}" != "_" ]; then
        for KEY in ${ACCESSKEYIDS}; do
            if [ "$KEY" = "${CHECK_KEY}" ]; then
                echo "AccessKeyID[${CHECK_KEY}] matches user[$U]"
                exit 0
            fi
        done
    fi
done

echo "AccessKeyID[${CHECK_KEY}] doesn't match any users."

exit 0
