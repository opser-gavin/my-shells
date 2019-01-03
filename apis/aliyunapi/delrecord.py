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

delRequest = DeleteDomainRecordRequest.DeleteDomainRecordRequest()
delRequest.set_RecordId(sys.argv[1])
delResult = clt.do_action(delRequest)
#delResult2 = json.loads(delResult)
print delResult
