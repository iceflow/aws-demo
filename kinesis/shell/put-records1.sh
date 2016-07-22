#!/bin/bash

STREAM_NAME=words2

put_record()
{
	DATA=$1
	aws kinesis put-record --stream-name ${STREAM_NAME} --partition-key $DATA --data $DATA
}


put_record A3
put_record A4
