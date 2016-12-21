#!/usr/bin/env python
# -*- coding: utf-8 -*-

# http://elasticsearch-py.readthedocs.io/en/master/api.html

'''
import httplib, urllib
data={'name':'leo'}
params = urllib.urlencode(data)
headers = {"Content-type": "application/json", "Charset": "UTF-8"}
conn = httplib.HTTPConnection("search-weblog-domain-hp5lndxriluzpb74bwomzm7ci4.us-east-1.es.amazonaws.com")
conn.request("POST", "/test-index/external/3", params, headers)
response = conn.getresponse()
print response.status, response.reason
data = response.read()
print data
'''


import uuid
from elasticsearch import Elasticsearch


def put_data_to_es(host=None, index=None, type=None, doc=None, port=80):
    es = Elasticsearch([{'host': 'search-weblog-domain-hp5lndxriluzpb74bwomzm7ci4.us-east-1.es.amazonaws.com', 'port':80}])

    id = uuid.uuid1().get_hex()

    print id

    es.create(index=index, doc_type=type, id=id, body=doc)

    return

# read doc
#print es.get(index='test-index', doc_type='external', id=1)

# write doc

data= {
    "host": "128.101.101.101",
    "datetime": "20/Dec/2016:03:53:19 +0000",
    "request": "GET / HTTP/1.1",
    "response": "200",
    "bytes": "99",
    "location": "44.9759, -93.2166",
    "agent": "ELB-HealthChecker/2.0"
  }

put_data_to_es('search-weblog-domain-hp5lndxriluzpb74bwomzm7ci4.us-east-1.es.amazonaws.com', 'logstash-weblogs-2016-12-01', 'type1', data)
