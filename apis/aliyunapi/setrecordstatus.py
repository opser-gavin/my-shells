#!/usr/bin/python

from aliyunsdkcore import client
from aliyunsdkalidns.request.v20150109 import DescribeDomainRecordsRequest
from aliyunsdkalidns.request.v20150109 import UpdateDomainRecordRequest
from aliyunsdkalidns.request.v20150109 import AddDomainRecordRequest
from aliyunsdkalidns.request.v20150109 import DeleteDomainRecordRequest
from aliyunsdkalidns.request.v20150109 import SetDomainRecordStatusRequest

AccessKeyID = "xxx"
AccessKeySecret = "xxx"

import json
import sys
clt = client.AcsClient(AccessKeyID, AccessKeySecret, 'cn-hangzhou')

setRequest = SetDomainRecordStatusRequest.SetDomainRecordStatusRequest()
setRequest.set_RecordId(sys.argv[1])
setRequest.set_Status(sys.argv[2])
setResult = clt.do_action(setRequest)
#setResult2 = json.loads(setResult)
print setResult


