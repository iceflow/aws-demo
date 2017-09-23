#!/usr/bin/python
# -*- coding: utf8 -*-


from pprint import pprint
import sys,os
import random
import json
import gzip
import random

from inventory_files_to_sqs import *

import boto3

s3 = boto3.resource('s3')
client = boto3.client('sqs')

QUEUE_ENDPOINT='https://eu-west-1.queue.amazonaws.com/888250974927/s3-copy-list'
DST_BUCKET='ireland-leo-test'


def s3_copy(src_bucket, dst_bucket, key):
    """
    Return Value:
    True:  Copy succesful
    False: Copy failed
    """
    copy_source = {
        'Bucket': src_bucket,
        'Key': key
    }

    try:
        res = s3.meta.client.copy(copy_source, dst_bucket, key)
    except Exception,data:
        print "s3_copy error:", data
        return False

    return True


def check_queue(qurl, dead_queue):
    print('check_queue(%s, %s)'%(qurl, dead_queue))
    #return {'number':0}

    response = client.receive_message(
        QueueUrl=qurl,
        MaxNumberOfMessages=10,
        WaitTimeSeconds=1
    )

    #pprint(response)

    if 'Messages' not in response:
        return {'number':0}

    if not isinstance(response['Messages'], list):
        return {'number':0, 'reason':'Messages is not list'}

    ret={}
    ret['number']=0
    for item in response['Messages']:
        if 'ReceiptHandle' not in item or 'Body' not in item:
            continue

        ReceiptHandle=item['ReceiptHandle']
        body=json.loads(item['Body'])

        #pprintf(body)

        success=True

        for action in body:
            src_bucket=action['src_bucket']
            key=action['key']
            dst_bucket=action['dst_bucket']

            if s3_copy(src_bucket, dst_bucket, key):
                print('s3_copy({0}, {1}, {2} ok'.format(src_bucket, dst_bucket, key))
            else:
                print('s3_copy({0}, {1}, {2} failed'.format(src_bucket, dst_bucket, key))
                # Just send the failed part to dead queue to verify, and make the job never failed
                #success=False
                send_msg_to_sqs(dead_queue, action)
                success=True
                break


        if success is True:
            response = client.delete_message(
                QueueUrl=qurl,
                ReceiptHandle=ReceiptHandle
            )

        ret['number']+=len(body)

    return ret


if __name__ == '__main__':
    #parse_inventory_file('inventory_files_test/a.csv.gz', 'ireland-leo-test')
    #parse_inventory_file('inventory_files_test/a.csv.gz', 'ireland-leo-test')

    #res=s3_copy('ctripcorp-nephele-file-eu', 'ireland-leo-test', 'fd/tg/g3/M08/E6/51/CggYGlZk_KeAOfnsAAOPrrGOCUA450.jpg1')
    #print "xxx",res

    qurl_endpoint=sys.argv[1]
    q_number=int(sys.argv[2])
    dead_queue=sys.argv[3]

    #response=check_queue('{0}-{1}'.format(qurl_endpoint, q_number), dead_queue)
    #pprint(response)
    #sys.exit(0)

    # Random start point and infinite loop to avoid hot spot scan
    check_point=random.randint(1, q_number)
    while True:
        if check_point > q_number:
            check_point=1
        response = check_queue('{0}-{1}'.format(qurl_endpoint, check_point), dead_queue)

        print("Process {} files".format(response['number']))
        check_point+=1
        
    sys.exit(0)
