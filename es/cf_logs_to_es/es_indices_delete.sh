#!/bin/bash -x

ES_CONF="es.conf"
. ${ES_CONF}

curl -XDELETE "$ES/cf-logs-2017-02-25"
