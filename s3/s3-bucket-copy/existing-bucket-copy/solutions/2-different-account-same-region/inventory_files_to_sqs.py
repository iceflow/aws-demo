#!/usr/bin/python
# -*- coding: utf8 -*-

import sys,os
import random
import json
import gzip

import boto3

QUEUE_ENDPOINT='https://eu-west-1.queue.amazonaws.com/888250974927/s3-copy-list'
DST_BUCKET='ireland-leo-test'

# How many SQS to use
QUEUE_NUM=100
# How many objects in one message body
MESSAGE_BODY_NUM=100

client = boto3.client('sqs')

def send_msg_to_sqs(qurl, body=None):

    if body is None:
        return False

    response = client.send_message(
        QueueUrl=qurl,
        MessageBody=json.dumps(body)
    )
    print "send_msg_to_sql:({0}..Number[{1}].".format(qurl, len(body))
    #print response

    return True

def parse_inventory_file(inventory_file,dst_bucket):
#"ctripcorp-nephele-file-eu","fd/tg/g3/M08/EA/90/CggYGlY3YYeAW9evACVCV2KLuKo912.jpg","2441815","2017-08-05T16:14:22.000Z","16828abffcc6d8446b2e750ab38539d0","STANDARD","false",""

    msg_body=[]

    with gzip.open(inventory_file, 'rb') as f:
        for line in f.readlines():
            sections = line.split(',')

            if len(sections) < 7:
                return 1

            src_bucket = sections[0].split('"')[1]
            key = sections[1].split('"')[1]

            #print src_bucket,key,dst_bucket

            msg_body.append({'src_bucket':src_bucket, 'key':key, 'dst_bucket':dst_bucket})


            if len(msg_body) == MESSAGE_BODY_NUM:
                qurl='{0}-{1}'.format(QUEUE_ENDPOINT, random.randint(1, QUEUE_NUM))
                send_msg_to_sqs(qurl, msg_body)
                msg_body=[]

    if len(msg_body) > 0:
        qurl='{0}-{1}'.format(QUEUE_ENDPOINT, random.randint(1, QUEUE_NUM))
        send_msg_to_sqs(qurl, msg_body)

    return 0

if __name__ == '__main__':

    #parse_inventory_file('inventory_files_test/a.csv.gz', 'ireland-leo-test')
    #parse_inventory_file('inventory_files_test/a.csv.gz', 'ireland-leo-test')


    inventory_dir=sys.argv[1]
    dst_bucket=sys.argv[2]

    dirlist=os.listdir(inventory_dir)

    for f in dirlist:
        parse_inventory_file('{0}/{1}'.format(inventory_dir, f), dst_bucket)
        


    sys.exit(0)
