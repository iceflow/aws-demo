#!/bin/bash

STREAM_NAME=words2
SHARD_NUM=1


aws kinesis create-stream --stream-name ${STREAM_NAME} --shard-count ${SHARD_NUM}
