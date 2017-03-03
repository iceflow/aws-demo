#!/usr/bin/env python
# -*- coding: utf-8 -*-

import geoip2.database
import pprint
import uuid

def get_geo_location(host_ip):
    reader = geoip2.database.Reader('/data/webaccess-analysis/kinesis-kcl/weblog/GeoLite2-City.mmdb') # FIXME:

    location = ""
    try:
        response = reader.city(host_ip)
        location = "{lat}, {lon}".format(lat=response.location.latitude, lon=response.location.longitude)
    except Exception as e:
        sys.stderr.write("get_geo_localtion({host}). Exception was {e}\n".format(host=host_ip, e=e))

    return location

if __name__ == '__main__':
    #print get_geo_location('128.101.101.101')
    #print get_geo_location('172.16.200.8')
    print get_geo_location('1.163.138.169')
