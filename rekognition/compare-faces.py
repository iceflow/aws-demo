#!/usr/bin/env python
# -*- coding: utf-8 -*-

import boto3
from pprint import *

#def create_volume_snapshot(volume, desc=None, tag_keyname=None, tag_value=None):

if __name__ == '__main__':
    profile_name="leo@nwcdleo.global"
    region="us-east-2"

    session = boto3.Session(profile_name=profile_name)
    client = session.client('rekognition', region_name=region)

    response = client.compare_faces(
        SourceImage={
            'S3Object': {
                'Bucket': 'leo-test-ohio',
                'Name': '原图裁剪.png'
            }
        },
        TargetImage={
            'S3Object': {
                'Bucket': 'leo-test-ohio',
                'Name': '凡凡临摹.jpeg'
            }
        }
    )

    print("Similarity: {}".format(response['FaceMatches'][0]['Similarity']))
    pprint(response)


