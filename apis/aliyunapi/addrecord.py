#!/usr/bin/python

from aliyunsdkcore import client
from aliyunsdkalidns.request.v20150109 import DescribeDomainRecordsRequest
from aliyunsdkalidns.request.v20150109 import UpdateDomainRecordRequest
from aliyunsdkalidns.request.v20150109 import AddDomainRecordRequest
from aliyunsdkalidns.request.v20150109 import DeleteDomainRecordRequest

AccessKeyID = "xxx"
AccessKeySecret = "xxx"

import json
import sys
clt = client.AcsClient(AccessKeyID, AccessKeySecret, 'cn-hangzhou')

#addRequest = DescribeDomainRecordsRequest.DescribeDomainRecordsRequest()
addRequest = AddDomainRecordRequest.AddDomainRecordRequest()
addRequest.set_DomainName('t5b.net')
addRequest.set_accept_format('json')
addRequest.set_RR(sys.argv[1])
addRequest.set_Type('A')
addRequest.set_Value(sys.argv[2])
addResult = clt.do_action(addRequest)
addResult2 = json.loads(addResult)
print addResult2


