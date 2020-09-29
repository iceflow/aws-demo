#!/bin/bash


rm -fr cmd
mkdir cmd

pushd cmd
R=cn-northwest-1
aws ec2 describe-snapshots --query 'Snapshots[].[SnapshotId]' --output text --region $R | awk '{print "aws --region "R" ec2 delete-snapshot --snapshot-id "$1}' R=$R > cmd.sh
R=cn-north-1
aws ec2 describe-snapshots --query 'Snapshots[].[SnapshotId]' --output text --region $R | awk '{print "aws --region "R" ec2 delete-snapshot --snapshot-id "$1}' R=$R >> cmd.sh

split -l 100 cmd.sh

rm -v cmd.sh

for S in *; do
	echo "== Processing $S ===="
    /bin/bash $S > /dev/null 2>&1 &
done

popd
