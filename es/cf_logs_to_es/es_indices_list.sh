#!/bin/bash -x

ES_CONF="es.conf"
. ${ES_CONF}

curl -XGet "$ES/_cat/indices?v"
