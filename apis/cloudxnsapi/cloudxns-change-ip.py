#!/usr/bin/env python
#-*- coding:utf-8 -*-

import os
import sys
import time
from cloudxns.api import *
try:
    import json
except ImportError:
    import simplejson as json
if __name__ == '__main__':


    newip = os.popen("curl -s http://myip.ipip.net |awk '{print $2}' |awk -F'IP：' '{print $NF}'")
    newip = newip.read()
#    print 'CloudXNS API Version: ', Api.vsersion()
    api_key = 'xxx'
    secret_key = 'xxx'
    api = Api(api_key=api_key, secret_key=secret_key)
#    result = api.ddns('vpn1.ixinali.com',ip=sys.argv[1])
    result = api.ddns('vpn1.ixinali.com',ip=newip)
    localtime = time.strftime("%Y-%m-%d %H:%M:%S", time.localtime())
    print "%s --- %s --- %s" % (localtime,result,newip)
