#!/bin/bash


#{"src_bucket": "ctripcorp-nephele-file-eu", "dst_bucket": "ctripcorp-nephele-file-ireland", "key": "fd/tg/g3/M09/CF/62/CggYGlZhZQOAHVPdAA1srhvnH3w383.jpg"}


SRC=ctripcorp-nephele-file-eu
DST=ctripcorp-nephele-file-ireland
KEY=fd/tg/g3/M09/CF/62/CggYGlZhZQOAHVPdAA1srhvnH3w383.jpg

echo "aws --profile joyou@ctrip s3 cp s3://$SRC/$KEY s3://$DST/$KEY"

exit 0

aws --profile joyou@ctrip s3 ls s3://ctripcorp-nephele-file-eu/fd/tg/g3/M09/CF/62/CggYGlZhZQOAHVPdAA1srhvnH3w383.jpg
aws --profile joyou@ctrip s3 ls s3://ctripcorp-nephele-file-ireland/fd/tg/g3/M09/CF/62/CggYGlZhZQOAHVPdAA1srhvnH3w383.jpg

exit 0
