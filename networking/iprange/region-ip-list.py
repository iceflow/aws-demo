


import json

data = None

with open('ip-ranges.json', 'r') as f:
    data = json.load(f)


for item in data['prefixes']:
    if item['region'] in [ 'cn-north-1' ]:
        if item.has_key('ip_prefix'):
            print item['ip_prefix']

