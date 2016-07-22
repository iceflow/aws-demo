#!/bin/bash

STREAM_NAME=testagent
SHARD_ID="shardId-000000000001"
#SHARD_ITERATOR_TYPE=AT_SEQUENCE_NUMBER
#SHARD_ITERATOR_TYPE=AFTER_SEQUENCE_NUMBER
SHARD_ITERATOR_TYPE=TRIM_HORIZON
#SHARD_ITERATOR_TYPE=LATEST
SEQ_NUM=49553543296329598497721613491305174295016473474872901634

#    AT_SEQUENCE_NUMBER - Start reading exactly from the position denoted by a specific sequence number.
#    AFTER_SEQUENCE_NUMBER - Start reading right after the position denoted by a specific sequence number.
#    TRIM_HORIZON - Start reading at the last untrimmed record in the shard in the system, which is the oldest data record in the shard.
#    LATEST - Start reading just after the most recent record in the shard, so that you always read the most recent data in the shard.



SHARD_ITERATOR=

get_records()
{
	aws kinesis get-records --shard-iterator ${SHARD_ITERATOR} --output json > result

	cat result

	SHARD_ITERATOR=$(cat result | grep NextShardIterator | awk -F'"' '{print $4}')
}

echo "== Before get-records"
aws kinesis describe-stream --stream-name ${STREAM_NAME} --output json

if [ ${SHARD_ITERATOR_TYPE} == "TRIM_HORIZON" -o ${SHARD_ITERATOR_TYPE} == "LATEST" ]; then
	SHARD_ITERATOR=$(aws kinesis get-shard-iterator --shard-id ${SHARD_ID} --shard-iterator-type ${SHARD_ITERATOR_TYPE} --stream-name ${STREAM_NAME} --query 'ShardIterator' --output text)
else
	SHARD_ITERATOR=$(aws kinesis get-shard-iterator --shard-id ${SHARD_ID} --shard-iterator-type ${SHARD_ITERATOR_TYPE} --starting-sequence-number ${SEQ_NUM} --stream-name ${STREAM_NAME} --query 'ShardIterator' --output text)
fi

while [ 1 ]; do
	get_records

	#echo "Next Iterator: ${SHARD_ITERATOR}"

	sleep 5
done

echo "== After get-records"
aws kinesis describe-stream --stream-name ${STREAM_NAME} --output json
