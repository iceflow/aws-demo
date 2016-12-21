#!/bin/bash


ENDPOINT="search-weblog-domain-hp5lndxriluzpb74bwomzm7ci4.us-east-1.es.amazonaws.com"
INDEX="logstash-weblogs-2016-12-01"
TYPE="type1"

#curl -XPUT "http://${ENDPOINT}/${INDEX}/${TYPE}" -d '
#curl -XPUT "http://search-weblog-domain-hp5lndxriluzpb74bwomzm7ci4.us-east-1.es.amazonaws.com/logstash-weblogs-2016-12-01/type1/_bulk?pretty" --data-binary "@data.json"

curl -XPUT "http://search-weblog-domain-hp5lndxriluzpb74bwomzm7ci4.us-east-1.es.amazonaws.com/logstash-weblogs-2016-12-01/type1/new_id?pretty" -d '
 {
    "host": "128.101.101.101",
    "ident": null,
    "authuser": null,
    "datetime": "20/Dec/2016:03:53:19 +0000",
    "request": "GET / HTTP/1.1",
    "response": "200",
    "bytes": "99",
    "referer": null,
    "location": "44.9759, -93.2166",
    "agent": "ELB-HealthChecker/2.0"
  }'


exit 0

curl -XPUT "http://search-weblog-domain-hp5lndxriluzpb74bwomzm7ci4.us-east-1.es.amazonaws.com/test-index?pretty"

curl "http://${ENDPOINT}/_cat/indices?v"


curl -XPUT "http://${ENDPOINT}/test-index/external/1?pretty" -d '
{
  "name": "John Doe"
}'

curl -XPUT "http://${ENDPOINT}/test-index/external/1?pretty" -d '
{
  "name": "John Doe, 1"
}'
