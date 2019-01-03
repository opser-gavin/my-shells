#!/usr/bin/python

from aliyunsdkcore import client
from aliyunsdkalidns.request.v20150109 import DescribeDomainRecordsRequest
from aliyunsdkalidns.request.v20150109 import UpdateDomainRecordRequest
from aliyunsdkalidns.request.v20150109 import AddDomainRecordRequest
from aliyunsdkalidns.request.v20150109 import DeleteDomainRecordRequest

AccessKeyID = "xxx"
AccessKeySecret = "xxx"

import json
clt = client.AcsClient(AccessKeyID, AccessKeySecret, 'cn-hangzhou')

listRequest = DescribeDomainRecordsRequest.DescribeDomainRecordsRequest()
domain = "t5b.net"
listRequest.set_DomainName(domain)
listRequest.set_accept_format('json')
listRequest.set_PageSize(100)
listResult = clt.do_action(listRequest)
listResult2 = json.loads(listResult)
listResult3 = listResult2['DomainRecords']['Record']
for i in range(listResult2['TotalCount']):
	print listResult3[i]['RR'],listResult3[i]['Value'],listResult3[i]['RecordId']
