#!/bin/bash

STREAM_NAME=testagent

put_record()
{
	DATA=$1
	aws kinesis put-record --stream-name ${STREAM_NAME} --partition-key $DATA --data $DATA
}


put_record A1
put_record A2
