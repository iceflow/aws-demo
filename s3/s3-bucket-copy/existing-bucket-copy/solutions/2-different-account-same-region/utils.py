#!/usr/bin/python
# -*- coding: utf8 -*-

import pprint

import datetime
import hmac
import hashlib
import json

def load_json_from_file(filename):
    json_data = open(filename).read()
    data = json.loads(json_data)
    return data

### Test


def process(f):
    pprint.pprint(f, indent=2, width=4)


if __name__ == '__main__':
    data = load_json_from_file("manifest.json")
    
    if 'files' in data:
        for f in data['files']:
            process(f)

    
    
