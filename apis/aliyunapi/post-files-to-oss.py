#!/usr/bin/python
#coding=utf8
import os
import oss2
import sys
from colorama import init, Fore, Back, Style
import shutil

init(autoreset=True)

if len(sys.argv) < 3:
    print(Fore.RED + "位置参数不够~~")
else:
    if sys.argv[1] == "post":
        print(Fore.RED + "\t执行前请确认：")
        print(Fore.RED + """\t1.确认OSS的Bucket准确
            2.确认Bucket的目录路径准确""")

        auth = oss2.Auth('xxx','xxx')
        bucket = oss2.Bucket(auth,'oss-ap-southeast-1.aliyuncs.com','game-sources-myanmargame-net')

        init(autoreset=True)
        path = sys.argv[2]
        oss_path = 'IOS_Resources'

        try:
            os.rename(path,oss_path)
            shutil.rmtree(oss_path+'/.svn')
        except OSError,e:
            print(Fore.GREEN + ".svn没发现.")

        oss_secdir = ''

        for fpath,dirs,fs in os.walk(oss_path):
            for f in fs:
                file = os.path.join(fpath,f)
                file2 = os.path.join(oss_secdir,file)
                print(Fore.YELLOW + "本地文件路径：%s , OSS路径：%s" % (file,file2))
                bucket.put_object_from_file(file2,file)
        os.rename(oss_path,path)
    else:
        print(Fore.RED + "HELP")
# file2为OSS上的文件路径名，file为本地文件路径名
