#!/usr/bin/env python
# -*- coding: utf-8 -*-

'''
import geoip2.webservice

client = geoip2.webservice.Client(118237, '99GGbapOav1Z')


response = client.insights('128.101.101.101')
'''


import geoip2.database
import pprint

def get_geo_location(host_ip):
    reader = geoip2.database.Reader('/data/aws-demo/es/GeoLite2-City.mmdb')
    response = reader.city(host_ip)

    return ("{lat}, {lon}".format(lat=response.location.latitude, lon=response.location.longitude))


print get_geo_location('128.101.101.101')
