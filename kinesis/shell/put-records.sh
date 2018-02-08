#!/bin/bash

#STREAM_NAME=testagent
STREAM_NAME=testStream

put_record()
{
	DATA=$1
	aws kinesis put-record --stream-name ${STREAM_NAME} --partition-key $DATA --data $DATA
}

while [ 1 ]; do
	put_record A1 > /dev/null 2>&1
#	put_record A2
done
