

aws es create-elasticsearch-domain --domain-name weblogs \
	--elasticsearch-version 2.3 \
	--elasticsearch-cluster-config  InstanceType=m3.medium.elasticsearch,InstanceCount=2 \
	--ebs-options EBSEnabled=true,VolumeType=standard,VolumeSize=100 \
	--access-policies '{"Version": "2012-10-17", "Statement": [{"Action": "es:*", "Principal":"*","Effect": "Allow", "Condition": {"IpAddress":{"aws:SourceIp":["192.0.2.0/32"]}}}]}'


aws es create-elasticsearch-domain --domain-name weblogs --elasticsearch-version 2.3 --elasticsearch-cluster-config  InstanceType=m3.large.elasticsearch,InstanceCount=6,ZoneAwarenessEnabled=true --ebs-options EBSEnabled=true,VolumeType=gp2,VolumeSize=100 --access-policies '{"Version": "2012-10-17", "Statement": [ { "Effect": "Allow", "Principal": {"AWS": "arn:aws:iam::555555555555:root" }, "Action":"es:*", "Resource": "arn:aws:es:us-east-1:555555555555:domain/logs/*" } ] }'


aws es create-elasticsearch-domain --domain-name weblogs --elasticsearch-version 2.3 --elasticsearch-cluster-config  InstanceType=m3.xlarge.elasticsearch,InstanceCount=10,DedicatedMasterEnabled=true,DedicatedMasterType=m3.medium.elasticsearch,DedicatedMasterCount=3 --ebs-options EBSEnabled=true,VolumeType=io1,VolumeSize=100,Iops=1000 --access-policies '{"Version": "2012-10-17", "Statement": [ { "Effect": "Allow", "Principal": { "AWS": "arn:aws:iam::555555555555:root" }, "Action": "es:*", "Resource": "arn:aws:es:us-east-1:555555555555:domain/mylogs/_search" } ] }' --snapshot-options AutomatedSnapshotStartHour=3





aws es list-domain-names

aws es describe-elasticsearch-domain --domain-name weblog-domain


aws es update-elasticsearch-domain-config --endpoint https://es.us-west-1.amazonaws.com --domain-name movies --access-policies '{"Version": "2012-10-17", "Statement": [{"Action": "es:ESHttp*","Principal":"*","Effect": "Allow", "Condition": {"IpAddress":{"aws:SourceIp":["192.0.2.0/32"]}}}]}'


# 
curl -XPUT search-weblog-domain-hp5lndxriluzpb74bwomzm7ci4.us-east-1.es.amazonaws.com -d '{"directors" : ["Tim Burton"],"genres" : ["Comedy","Sci-Fi"],"plot" : "The Earth is invaded by Martians with irresistible weapons and a cruel sense of humor.","title" : "Mars Attacks!","actors" : ["Jack Nicholson","Pierce Brosnan","Sarah Jessica Parker"],"year" : 1996}'

curl search-weblog-domain-hp5lndxriluzpb74bwomzm7ci4.us-east-1.es.amazonaws.com/


curl -XPUT search-weblog-domain-hp5lndxriluzpb74bwomzm7ci4.us-east-1.es.amazonaws.com/weblog-domain/access/1 -d '{"host":"192.168.1.1", "content":"test"}'
curl -XPUT search-weblog-domain-hp5lndxriluzpb74bwomzm7ci4.us-east-1.es.amazonaws.com/weblog-domain/access/2 -d '{"host":"192.168.1.2", "content":"test2"}'
#curl -XGET https://search-weblog-domain-hp5lndxriluzpb74bwomzm7ci4.us-east-1.es.amazonaws.com/_count



curl -XGET 'search-weblog-domain-hp5lndxriluzpb74bwomzm7ci4.us-east-1.es.amazonaws.com/weblogs/access/_search?pretty' -d'
{
    "query" : {
        "match" : {
            "ip" : "172.31.77.2"
        }
    }
}'



# Customer mapping
# LogFormat "%h %l %u %t \"%r\" %>s %b \"%{Referer}i\" \"%{User-Agent}i\"" combined
# “%{host} %{ident} %{authuser} [%{datetime}] \"%{request}\" %{response} %{bytes} %{referrer} %{agent}”
# 172.31.77.2 - - [27/Nov/2016:03:39:14 +0000] "GET / HTTP/1.1" 200 99 "-" "ELB-HealthChecker/2.0"
# Datatype
# https://www.elastic.co/guide/en/elasticsearch/reference/2.3/mapping-types.html
ENDPOINT="search-weblog-domain-hp5lndxriluzpb74bwomzm7ci4.us-east-1.es.amazonaws.com/"
curl -XPUT 'http://${ENDPOINT}/_template/logstash' -d '
{
     "template": "logstash-*",
     "mappings": {
          "type1": {
               "properties": {
					"host": {
                         "type": "string",
					},
					"ident": {
                         "type": "string",
					},
					"authuser": {
                         "type": "string",
					},
                    "datetime": {
                         "type": "date",
                         "format": "yyyy-MM-dd HH:mm:ss"
                    },
                    "request": {
                         "type": "string"
                    },
                    "response": {
                         "type": "integer"
                    },
                    "bytes": {
                         "type": "integer"
                    },
                    "referrer": {
                         "type": "string"
                    },
                    "agent": {
                         "type": "string"
                    },
                    "country": {
                         "type": "string"
                    },
                    "location": {
                         "type": "geo_point"
                    }
               }
          }
     }
}'
