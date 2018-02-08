#!/usr/bin/python
# -*- coding: utf8 -*-

import sys
from pprint import pprint
import boto3
import requests

def generate_presigned_url(s3_handler, para):
    url = s3_handler.meta.client.generate_presigned_url(
        ClientMethod='get_object',
        ExpiresIn=para['expiration_seconds'],
        Params={
            'Bucket': para['bucket_name'],
            'Key': para['key_name']
        }
    )

    return url

def restore_all_glacier(bucket_name):
    s3 = boto3.resource('s3')
    bucket = s3.Bucket(bucket_name)
    for obj_sum in bucket.objects.all():
        obj = s3.Object(obj_sum.bucket_name, obj_sum.key)
        print(obj)
        print(obj.storage_class)
        if obj.storage_class == 'GLACIER':
            # Try to restore the object if the storage class is glacier and
            # the object does not have a completed or ongoing restoration
            # request.
            if obj.restore is None:
                print('Submitting restoration request: %s' % obj.key)
                obj.restore_object()
            # Print out objects whose restoration is on-going
            elif 'ongoing-request="true"' in obj.restore:
                print('Restoration in-progress: %s' % obj.key)
            # Print out objects whose restoration is complete
            elif 'ongoing-request="false"' in obj.restore:
                print('Restoration complete: %s' % obj.key)
    
if __name__ == '__main__':
    argc = len(sys.argv)

    if argc == 0:
        sys.exit(0)

    if argc > 2:
        if 'generate_presigned_url' == sys.argv[1]:
            profile_name=sys.argv[2]
            session = boto3.Session(profile_name=profile_name)
            s3 = session.resource('s3')

            para = {
                'bucket_name': sys.argv[3],
                'key_name': sys.argv[4],
                'expiration_seconds': int(sys.argv[5])
            }

            res = generate_presigned_url(s3, para)
            pprint(res)
        elif 'restore_all_glacier' == sys.argv[1]:
            restore_all_glacier(sys.argv[2])
