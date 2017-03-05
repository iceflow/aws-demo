#!/bin/bash -x


./es_indices_delete.sh
./es.sh

./cf_logs_to_es.py search-weblog-domain-5-fcx4knelxu7dokwfy5okh3rdmy.us-east-1.es.amazonaws.com aws-cdn.logs 
