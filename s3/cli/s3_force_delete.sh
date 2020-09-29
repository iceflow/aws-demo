#!/bin/bash

PROFILE=${1:-default}
BUCKETS=$2
DEBUG=false

for B in $BUCKETS; do
	echo -n "Delete objects in $B..."
	aws --profile $PROFILE s3 rm --recursive s3://$B > /dev/null 2>&1
	echo "Done"
	echo "Beging to delete bucket ..."
	aws --profile $PROFILE s3 rb s3://$B
	echo "done"
done
