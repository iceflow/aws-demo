#!/usr/bin/python
# -*- coding: utf8 -*-

import redis

class RedisClient(object):
    def __init__(self):
        self._client = None

    def get_client(self):
        if self._client is None or kwargs:
            self._client = redis.StrictRedis(host='localhost', port=6379, db=0)
        return self._client

    def set(self, key, value):
        if self._client is None:
            return None

        return self._client.set(key, value)

    def get_by_key(self, key):
        if self._client is None:
            return None

        return self._client.get(key)



if __name__ == '__main__':
    r=RedisClient()

    r.get_client()


    res = r.set('aa', 1)
    print res

    res = r.get_by_key('aa')
    print res
    res = r.get_by_key('aaa')
    print res




