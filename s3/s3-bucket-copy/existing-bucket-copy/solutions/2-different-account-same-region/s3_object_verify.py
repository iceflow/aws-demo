#!/usr/bin/python
# -*- coding: utf8 -*-

import redis
import sys
import gzip
from redis_client import *


from pprint import pprint

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

            r = redis_client.set(key, value)

            if r is True:
                update_succes_number+=1
            else:
                update_fail_number+=1
            

    res = {
        'update_succes_number': update_succes_number,
        'update_fail_number': update_fail_number
    }

    return res


def check_file_existence_with_redis():
    print "check_file_existence_with_redis"

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
            check_file_existence_with_redis()


