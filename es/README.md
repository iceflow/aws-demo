

https://www.elastic.co/guide


# API
https://www.elastic.co/guide/en/elasticsearch/reference/2.3/index.html



# Geo
https://www.maxmind.com/en/home

# Download Geo DB
http://dev.maxmind.com/geoip/geoip2/geolite2/


curl -XPUT 'http://http://search-weblog-domain-hp5lndxriluzpb74bwomzm7ci4.us-east-1.es.amazonaws.com/_template/logstash' -d '
{
     "template": "logstash-*",
     "mappings": {
          "type1": {
               "properties": {
                    "created_at": {
                         "type": "date",
                         "format": "yyyy-MM-dd HH:mm:ss"
                    },
                    "country": {
                         "type": "string"
                    },
                    "location": {
                         "type": "geo_point"
                    },
                    "download_speed": {
                         "type": "double"
                    }
               }
          }
     }
}'



https://geoip2.readthedocs.io/en/latest/
