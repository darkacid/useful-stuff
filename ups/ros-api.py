#!/usr/bin/python

import routeros_api
import re
connection = routeros_api.RouterOsApiPool('192.168.1.165', username='', password='',plaintext_login=True)

api = connection.get_api()
# api.get_resource('/').call('tool/wol',{ 'mac': "a8:5e:45:e6:1e:6b",'interface':'br0' })

regex=[
    ("([0-9]+)s",1),
    ("([0-9]+)m",60),
    ("([0-9]+)h",3600),
    ("([0-9]+)d",86400),
    ("([0-9]+)w",604800)
]


list_queues = api.get_resource('/system/resource')


uptime_string=list_queues.get()[0]['uptime']

print(uptime_string)
time_res=0
for i,t in regex:
    if res:= re.search(i,uptime_string):
        time_res+=int(res.group(1))*t
    else:
        break

print(time_res)