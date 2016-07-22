#!/usr/bin/env python

import boto
import boto.s3.connection

from credential import *

conn = boto.connect_s3(
		host = 's3.cn-north-1.amazonaws.com.cn',
        aws_access_key_id = access_key,
        aws_secret_access_key = secret_key
        )

'''
        host = 'objects.dreamhost.com',
        #is_secure=False,               # uncomment if you are not using ssl
        calling_format = boto.s3.connection.OrdinaryCallingFormat(),
'''


bucket = conn.get_bucket('leopublic')

l = bucket.list()
print l

print "-----"

keys=bucket.get_all_keys(maxkeys=0)
print keys

print "-----"
#conn = boto.connect_s3()
rs = conn.get_all_buckets()
for r in rs:
	print r
