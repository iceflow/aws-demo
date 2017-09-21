#!/usr/bin/python
# -*- coding: utf8 -*-


from pprint import pprint
import sys,os
import random
import json
import gzip
import random

import boto3

s3 = boto3.resource('s3')
client = boto3.client('sqs')

QUEUE_ENDPOINT='https://eu-west-1.queue.amazonaws.com/888250974927/s3-copy-list'
DST_BUCKET='ireland-leo-test'

def check_queue_status(qurl):
    #print('check_queue_status(%s)'%(qurl))
    #return {'number':0}

    response = client.get_queue_attributes(
        QueueUrl=qurl,
        AttributeNames=[
            'All'
        ]
    )

    #pprint(response)
    #{u'Attributes': {'ApproximateNumberOfMessages': '1',


    if 'Attributes' in response:
        if 'ApproximateNumberOfMessages' in response['Attributes']:
            message_number=int(response['Attributes']['ApproximateNumberOfMessages'])
            if message_number>0:
                print('%04d : %s'%(message_number, qurl))
                

    return


if __name__ == '__main__':
    qurl_endpoint=sys.argv[1]
    q_number=int(sys.argv[2])

    for pos in xrange(q_number):
        response = check_queue_status('{0}-{1}'.format(qurl_endpoint, pos+1))
        
    sys.exit(0)
