#!/usr/bin/python
# -*- coding: utf8 -*-

import redis
import sys
import gzip
import json
import random
import boto3
from redis_client import *

from pprint import pprint

QUEUE_ENDPOINT='https://eu-west-1.queue.amazonaws.com/888250974927/s3-copy-list'
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
    #print "send_msg_to_sql:({0}..Number[{1}].".format(qurl, len(body))
    #print response

    return True

''' Load object to redis'''
def load_origin_object_list(filename, redis_client):
    print "load_origin_object_list(%s)"%filename

    # "ctripcorp-nephele-file-eu","fd/tg/g3/M08/E6/51/CggYG1Y26zCAfj-uAAFPZF8NV_g821.jpg","85860","2017-08-09T07:07:56.000Z","d0655f3673af1ca741b11b29865be8e1","STANDARD","false",""

    update_succes_number = 0
    update_fail_number = 0

    with gzip.open(filename, 'rb') as f:
        for line in f.readlines():
            sections = line.split(',')

            if len(sections) < 6:
                continue

            key=sections[1].split('"')[1]
            value={
                'size': int(sections[2].split('"')[1]),
                'etag': sections[4].split('"')[1]
            }


            #pprint(key)
            #pprint(value)

            r = redis_client.set(key, json.dumps(value))

            if r is True:
                update_succes_number+=1
            else:
                update_fail_number+=1
            
    res = {
        'update_succes_number': update_succes_number,
        'update_fail_number': update_fail_number
    }

    return res

def check_file_existence_with_redis(filename, dst_bucket, redis_client):
    msg = "check_file_existence_with_redis(%s) "%filename
    print msg,

    sys.stdout.flush()

    # "ctripcorp-nephele-file-eu","fd/tg/g3/M08/E6/51/CggYG1Y26zCAfj-uAAFPZF8NV_g821.jpg","85860","2017-08-09T07:07:56.000Z","d0655f3673af1ca741b11b29865be8e1","STANDARD","false",""

    copied_done_number = 0
    need_copy_number = 0

    msg_body=[]

    with gzip.open(filename, 'rb') as f:
        for line in f.readlines():
            sections = line.split(',')

            if len(sections) < 6:
                continue

            src_bucket=sections[0].split('"')[1]
            key=sections[1].split('"')[1]
            value={
                'size': int(sections[2].split('"')[1]),
                'etag': sections[4].split('"')[1]
            }

            #pprint(key)
            #pprint(value)
            r = redis_client.get_by_key(key)

            #pprint(r)
        
            copy_needed=False
            if r is None:
                #print('{0} NOT existed'.format(key))
                need_copy_number+=1
                copy_needed=True
            else:
                res = json.loads(r)

                if value['size'] != res['size']:
                    #print('{0} existed but not same size {1}/{2}'.format(key, value['size'], res['size']))
                    need_copy_number+=1
                    copy_needed=True
                elif value['etag'] != res['etag']:
                    #print('{0} existed but not same etag {1}/{2}'.format(key, value['etag'], res['etag']))
                    need_copy_number+=1
                    copy_needed=True
                else:
                    #print('{0} COPIED DONE'.format(key))
                    copied_done_number+=1
                    copy_needed=False
                    continue

            if copy_needed:
                msg_body.append({'src_bucket':src_bucket, 'key':key, 'dst_bucket':dst_bucket})
                if len(msg_body) == MESSAGE_BODY_NUM:
                    qurl='{0}-{1}'.format(QUEUE_ENDPOINT, random.randint(1, QUEUE_NUM))
                    send_msg_to_sqs(qurl, msg_body)
                    msg_body=[]


    if len(msg_body) > 0:
        qurl='{0}-{1}'.format(QUEUE_ENDPOINT, random.randint(1, QUEUE_NUM))
        send_msg_to_sqs(qurl, msg_body)
            
    res = {
        'copied_done_number': copied_done_number,
        'need_copy_number': need_copy_number
    }

    return res

if __name__ == '__main__':
    argc = len(sys.argv)

    #print argc, sys.argv

    # Initial client
    r = RedisClient()
    r.get_client()

    if argc > 1:
        if 'load_origin_object_list' == sys.argv[1]:
            res = load_origin_object_list(sys.argv[2], r)
            pprint(res)
        elif 'check_file_existence_with_redis' == sys.argv[1]:
            r=check_file_existence_with_redis(sys.argv[3], sys.argv[2], r)

            #print r

            #if r['need_copy_number'] > 0:
                #print("     need_copy_number[%d]"%r['need_copy_number'])
            if 'need_copy_number' in r:
                print("     need_copy_number[%d]"%r['need_copy_number'])
