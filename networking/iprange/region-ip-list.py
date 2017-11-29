#!/usr/bin/python
# -*- coding: utf8 -*-

import json
import urllib
import os

def safe_download(prefix, download_url):
    while not os.path.exists(prefix):
        print("Downloading {0}".format(download_url))
        urllib.urlretrieve(download_url, prefix)

def get_region_ip_ranges(region_name, ip_type):
    data = None

    prefix_dict = {
        'ipv4': {
            'prefixes': 'prefixes',
            'ip_prefix': 'ip_prefix'
        },
        'ipv6': {
            'prefixes': 'ipv6_prefixes',
            'ip_prefix': 'ipv6_prefix'
        }
    }


    with open('ip-ranges.json', 'r') as f:
        data = json.load(f)

    for item in data[prefix_dict[ip_type]['prefixes']]:
        if item['region'] in [ region_name ]:

            if item.has_key(prefix_dict[ip_type]['ip_prefix']):
                print item[prefix_dict[ip_type]['ip_prefix']]

def get_region_list():
    data = None

    with open('ip-ranges.json', 'r') as f:
        data = json.load(f)

    region_dict = {}
    for item in data['prefixes']:
        region_dict[item['region']] = True

    #for key in region_dict.keys():
    #    print key

    return region_dict.keys()

    
def get_select_item(msg, item_list):

    max_pos = len(item_list)

    while True:
        select_id = raw_input("{0}: ".format(msg))

        if select_id.isdigit() and (int(select_id) >= 0 and int(select_id)<max_pos):
            break
        else:
            print("Invalid ID : {0} , Valid Range (0 - {1})".format(select_id, max_pos-1))
            continue

    return int(select_id)

if __name__ == '__main__':
    
    safe_download('ip-ranges.json', 'https://ip-ranges.amazonaws.com/ip-ranges.json')

    region_list = get_region_list()

    #print region_list

    print "=== Current  AWS Region list ==="

    #for item in region_list:

    length=len(region_list)
    for pos in xrange(0, length):
        print("{0}) {1}".format(pos, region_list[pos]))

    select_id = get_select_item('Select your region id (0~{0}): '.format(length), region_list)
    
    ip_types=['ipv4', 'ipv6']
    length=len(ip_types)
    for pos in xrange(0, length):
        print("{0}) {1}".format(pos, ip_types[pos]))
    ip_type_id = get_select_item('Select ip type '.format(length), ip_types)

    print("{0} - {1} {2} ip ranges".format(select_id, region_list[select_id], ip_types[ip_type_id]))

    get_region_ip_ranges(region_list[select_id], ip_types[ip_type_id])
