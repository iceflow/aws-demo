#!/bin/bash

# Check src / dst bucket key file

SRC=ctripcorp-nephele-file-eu
DST=ctripcorp-nephele-file-ireland
P=joyou@ctrip

echo "SRC"

aws --profile $P s3 ls s3://$SRC/$1

echo "DST"
aws --profile $P s3 ls s3://$DST/$1


exit 0
