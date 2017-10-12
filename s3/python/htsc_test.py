#!/usr/bin/python
# -*- coding: utf8 -*-

import sys
from pprint import pprint
import boto3
import requests

from s3_demo import *

if __name__ == '__main__':
    profile_name='default'

    session = boto3.Session(profile_name=profile_name)
    s3 = session.resource('s3')

    arr=[
        "htsc-ebc/DavidPellerin_EBC250 How to Cultivate an Innovation-Driven Culture.pptx",
        "htsc-ebc/DevOps_ProServe_HuataiSecuritiesFINAL.pptx",
        "htsc-ebc/EricWazorko_Finra_Huatai Briefing.pptx",
        "htsc-ebc/PeterWilliams_AWS FSI - Huatai Securities.pptx"
    ]


    expiration_time=604800

    for item in arr: 
        para = {
            'bucket_name': 'leoaws',
            'key_name': item,
            'expiration_seconds': expiration_time
        }

        res = generate_presigned_url(s3, para)
        print "item: %s url: %s"%(item, res)
