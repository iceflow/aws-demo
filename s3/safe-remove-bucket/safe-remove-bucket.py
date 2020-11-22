#!/usr/bin/env python

profile_name = 'chinakb'
BUCKET = 'reinvent'

import boto3

session = boto3.Session(profile_name=profile_name)
s3 = session.resource('s3')

bucket = s3.Bucket(BUCKET)
bucket.object_versions.delete()

# if you want to delete the now-empty bucket as well, uncomment this line:
bucket.delete()
