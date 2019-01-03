#!/usr/bin/python

import os
import oss2


auth = oss2.Auth('xxx','xxx')
bucket = oss2.Bucket(auth,'oss-cn-beijing.aliyuncs.com','www-idouya-net')

path = 'test'

for fpath,dirs,fs in os.walk(path):
    for f in fs:
	print(f) 
        file = os.path.join(fpath,f)
	print(file)
	file2 = os.path.join('secdir',file)
	print(file2)
#        bucket.put_object_from_file(file2,file)

#file2为OSS上的文件路径名，file为本地文件路径名
