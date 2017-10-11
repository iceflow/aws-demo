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
