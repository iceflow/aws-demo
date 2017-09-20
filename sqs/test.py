#!/usr/bin/python
# -*- coding: utf8 -*-

#http://boto3.readthedocs.io/en/latest/reference/services/sqs.html#SQS.Client.list_queues

import sys
import pprint
import boto3

client = boto3.client('sqs')

def list_test():
    response = client.list_queues(
        QueueNamePrefix='s3-copy-list-1'
    )

    pprint.pprint(response)

def send_test():
    response = client.send_message(
        QueueUrl='https://sqs.eu-west-1.amazonaws.com/888250974927/s3-copy-list-1',
        MessageBody='string'
    )

    pprint.pprint(response)


def recv_test():
    response = client.receive_message(
        QueueUrl='https://sqs.eu-west-1.amazonaws.com/888250974927/s3-copy-list-1',
        MaxNumberOfMessages=10
    )

    pprint.pprint(response)

if __name__ == '__main__':
    list_test()

    send_test()

    recv_test()

    sys.exit(0);

