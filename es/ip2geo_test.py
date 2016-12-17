#!/usr/bin/env python
# -*- coding: utf-8 -*-

'''
import geoip2.webservice

client = geoip2.webservice.Client(118237, '99GGbapOav1Z')


response = client.insights('128.101.101.101')
'''


import geoip2.database
import pprint
reader = geoip2.database.Reader('/data/aws-demo/es/GeoLite2-City.mmdb')
response = reader.city('128.101.101.101')

print response
