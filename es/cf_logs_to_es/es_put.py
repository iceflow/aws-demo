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
    es = Elasticsearch([{'host': host, 'port':port}])


    # Put with specific index
    #_id = uuid.uuid1().get_hex()
    #es.create(index=index, doc_type=type, id=_id, body=doc)

    # Put with auto-generated index
    es.index(index=index, doc_type=type, body=doc)

    return

def bulk_data_to_es(host=None, body=None, port=80):

    if body is None:
        return

    es = Elasticsearch([{'host': host, 'port':port}])

    # Bulk action
    es.bulk(body=body)

    return

# read doc
#print es.get(index='test-index', doc_type='external', id=1)

# write doc

if __name__ == '__main__':
    data= {
        "authuser": "xxx",
        "host": "128.101.101.101",
        "datetime": "20/Dec/2016:03:53:19 +0000",
        "request": "GET / HTTP/1.1",
        "response": "200",
        "bytes": "99",
        "location": "44.9759, -93.2166",
        "agent": "ELB-HealthChecker/2.0"
      }



    #put_data_to_es('search-weblog-domain-5-fcx4knelxu7dokwfy5okh3rdmy.us-east-1.es.amazonaws.com', 'logstash', 'type1', data)

    body = '{"index":{"_index":"testbulk","_type":"log"}}\n{ "field1" : "value1" }'
    bulk_data_to_es('search-weblog-domain-5-fcx4knelxu7dokwfy5okh3rdmy.us-east-1.es.amazonaws.com', body)


