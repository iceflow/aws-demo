#!/usr/bin/python
# -*- coding: utf8 -*-


from pprint import pprint
import sys,os
import random
import json
import gzip
import random


import boto3

session = boto3.Session(
    region_name='cn-north-1',
    aws_access_key_id='xxxxxxxxxxxxxx',
    aws_secret_access_key='xxxxxxxxxxxxxxxxxxxxxx'
)


sns = session.resource('sns')
sns_client = session.client('sns')


A=sns.create_topic(Name='abc').arn
#print(A)

#res = sns_client.list_topics()
#pprint(res)

#message={"create-time":"2019-04-23-15-59-04","synctoken":"1556035144","md5":"b7a7f68fad03bfe97ae401a6a126192e","url":"https://ip-ranges.amazonaws.com/ip-ranges.json"}
message={"create-time":"2019-04-23-15-59-04","synctoken":"1556035144","md5":"xxxxxxxxxx","url":"https://ip-ranges.amazonaws.com/ip-ranges.json"}

data={'default': json.dumps(message)}



print(json.dumps(data))



res = sns_client.publish(
    TopicArn='arn:aws-cn:sns:cn-north-1:048912060910:AmazonIpSpaceChanged',
    Message=json.dumps(data),
    MessageStructure='json'
)

pprint(res)
