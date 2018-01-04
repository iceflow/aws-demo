#!/usr/bin/python
# -*- coding: utf8 -*-

# http://boto3.readthedocs.io/en/latest/reference/services/sqs.html#SQS.Client.list_queues
# http://boto3.readthedocs.io/en/latest/reference/services/sqs.html#queue

import sys
from pprint import pprint
import boto3
import json

#session = boto3.Session(profile_name='joyou@ctrip')
#client = session.client('sqs')
client = boto3.client('sqs')



def list_test():
    response = client.list_queues(
        QueueNamePrefix='https://cn-north-1.queue.amazonaws.com.cn/358620020600/s3sync-worker-dead1'
    )

    pprint(response)

def send_test():
    response = client.send_message(
        QueueUrl='https://sqs.eu-west-1.amazonaws.com/888250974927/s3-copy-list-1',
        MessageBody='string'
    )

    pprint(response)


def recv_test():
    response = client.receive_message(
        QueueUrl='https://eu-west-1.queue.amazonaws.com/888250974927/s3-copy-list-18',
        MaxNumberOfMessages=10
    )

    pprint(response)

def get_queue_attributes(queue_url=None):
    response = client.get_queue_attributes(
        QueueUrl=queue_url,
        AttributeNames=['All']
    )

    pprint(response)

    return(response)

def get_queue_attributes_arn(queue_url=None):
    response = client.get_queue_attributes(
        QueueUrl=queue_url,
        AttributeNames=['QueueArn']
    )

    pprint(response)

    return(response['Attributes']['QueueArn'])
    

def create_sqs(queue_name=None, enable_dead_letter=False, redrive_policy=None ):

    '''
    redrive_policy = {
        'deadLetterTargetArn': dead_letter_queue_arn,
        'maxReceiveCount': '3'
    }
    '''

    Attributes={}
    if enable_dead_letter:
        Attributes['RedrivePolicy'] = json.dumps(redrive_policy)
    
    Attributes['VisibilityTimeout']='60'
    Attributes['ReceiveMessageWaitTimeSeconds']='5'

    response = client.create_queue(
        QueueName=queue_name,
        Attributes=Attributes
    )

    pprint(response)

    return(response['QueueUrl'])

def test():
    dead_letter_queue_url = create_sqs('s3sync-worker-dead')
    dead_letter_queue_arn = get_queue_attributes_arn(dead_letter_queue_url)
    #dead_letter_queue_arn = 'arn:aws-cn:sqs:cn-north-1:358620020600:s3sync-worker-dead'
    #pprint(dead_letter_queue_arn)
    
    redrive_policy = {
        'deadLetterTargetArn': dead_letter_queue_arn,
        'maxReceiveCount': '3'
    }
    queue_url = create_sqs('s3sync-worker', enable_dead_letter=True, redrive_policy=redrive_policy)
    pprint(queue_url)
    
    

if __name__ == '__main__':
    test()
    #list_test()

#    send_test()

#    recv_test()

    sys.exit(0);

