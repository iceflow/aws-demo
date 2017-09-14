#!/usr/bin/python
# -*- coding: utf8 -*-


from utils import *
import pprint

import datetime
import hmac
import hashlib
import json

if __name__ == '__main__':
    data = load_json_from_file("manifest.json")
    
    if 'files' in data:
        for f in data['files']:
            process(f)

    
    
