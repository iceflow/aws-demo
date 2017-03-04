#!/bin/bash -x
#ES=search-weblog-domain-5-fcx4knelxu7dokwfy5okh3rdmy.us-east-1.es.amazonaws.com
ES_CONF="es.conf"
. ${ES_CONF}

#Fields: date time x-edge-location sc-bytes c-ip cs-method cs(Host) cs-uri-stem sc-status cs(Referer) cs(User-Agent) cs-uri-query cs(Cookie) x-edge-result-type x-edge-request-id x-host-header cs-protocol cs-bytes time-taken x-forwarded-for ssl-protocol ssl-cipher x-edge-response-result-type cs-protocol-version

curl -XPUT http://$ES/cf-logs-2017-02-25 -d '
{
  "mappings": {
    "log": {
      "properties": {
        "@timestamp": { "type": "date", "format": "yyyy-MM-dd:HH:mm:ss" },
        "x-edge-location": { "type": "string" },
        "sc-bytes": { "type": "integer" },
        "c-ip": { "type": "string" },
        "location": { "type": "geo_point" },
        "cs-method": { "type": "string" },
        "cs-host": { "type": "string" },
        "cs-uri-stem": { "type": "string" },
        "sc-status": { "type": "string" },
        "cs-feferer": { "type": "string" },
        "cs-user-agent": { "type": "string" },
        "cs-uri-query": { "type": "string" },
        "cs-cookie": { "type": "string" },
        "x-edge-result-type": { "type": "string" },
        "x-edge-request-id": { "type": "string" },
        "x-host-header": { "type": "string" },
        "cs-protocol": { "type": "string" },
        "cs-bytes" : { "type" : "integer" },
        "time-taken": { "type": "float" },
        "x-forwarded-for": { "type": "string" },
        "ssl-protocol": { "type": "string" },
        "ssl-cipher": { "type": "string" },
        "x-edge-response-result-type": { "type": "string" },
        "cs-protocol-version": { "type": "string" }
      }
    }
  }
}'

exit 0

curl -XPUT http://$ES/shakespeare -d '
{
 "mappings" : {
  "_default_" : {
   "properties" : {
    "speaker" : {"type": "string", "index" : "not_analyzed" },
    "play_name" : {"type": "string", "index" : "not_analyzed" },
    "line_id" : { "type" : "integer" },
    "speech_number" : { "type" : "integer" }
   }
  }
 }
}
';

curl -XPUT http://$ES/account -d '
{
 "mappings" : {
  "_default_" : {
   "properties" : {
    "firstname" : {"type": "string", "index" : "not_analyzed" },
    "lastname" : {"type": "string", "index" : "not_analyzed" },
    "gender" : {"type": "string", "index" : "not_analyzed" },
    "address" : {"type": "string", "index" : "not_analyzed" },
    "employer" : {"type": "string", "index" : "not_analyzed" },
    "email" : {"type": "string", "index" : "not_analyzed" },
    "city" : {"type": "string"},
    "state" : {"type": "string"},
    "account_number" : { "type" : "integer" },
    "balance" : { "type" : "integer" },
    "age" : { "type" : "integer" }
   }
  }
 }
}
';

curl -XPUT http://$ES/logstash-2015.05.18 -d '
{
  "mappings": {
    "log": {
      "properties": {
        "geo": {
          "properties": {
            "coordinates": {
              "type": "geo_point"
            }
          }
        }
      }
    }
  }
}
';

curl -XPUT http://$ES/logstash-2015.05.18 -d '
{
  "mappings": {
    "log": {
      "properties": {
        "geo": {
          "properties": {
            "coordinates": {
              "type": "geo_point"
            }
          }
        }
      }
    }
  }
}
';

curl -XPUT http://$ES/logstash-2015.05.20 -d '
{
  "mappings": {
    "log": {
      "properties": {
        "geo": {
          "properties": {
            "coordinates": {
              "type": "geo_point"
            }
          }
        }
      }
    }
  }
}
';

curl -XPOST "$ES/bank/account/_bulk" --data-binary @accounts.json
curl -XPOST "$ES/shakespeare/_bulk" --data-binary @shakespeare.json
curl -XPOST "$ES/_bulk" --data-binary @logs.jsonl


curl -XGet "$ES/_cat/indices?v"
