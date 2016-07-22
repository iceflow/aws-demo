#!/bin/bash


#create stream
￼aws kinesis create-stream --stream-name Foo --shard-count 1

aws kinesis describe-stream
#aws kinesis describe-stream --stream-name words
#aws kinesis describe-stream --stream-name words --output text
#aws kinesis describe-stream --stream-name words --output text
aws kinesis describe-stream --stream-name words --output json

#Put record
aws kinesis put-record --stream-name Foo --partition-key 123 --data testdata

# Retriev record
aws kinesis get-shard-iterator --shard-id shardId-000000000000 --shard-iterator- type TRIM_HORIZON --stream-name Foo

# get-records
aws kinesis get-records --shard-iterator AAAAAAAAAAHSywljv0zEgPX4NyK
dZ5wryMzP9yALs8NeKbUjp1IxtZs1Sp+KEd9I6AJ9ZG4lNR1EMi+9Md/nHvtLyxpf
hEzYvkTZ4D9DQVz/mBYWRO6OTZRKnW9gd+efGN2aHFdkH1rJl4BL9Wyrk+ghYG22D2T1Da2EyN
SH1+LAbK33gQweTJADBdyMwlo5r6PqcP2dzhg=
