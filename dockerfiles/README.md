# dockerfile-centos6.10-sshd

Building & Running
	# docker build  -t mycentos6.10:sshd-123456 .
run:
	# docker run -d -P --name test-sshd mycentos6.10:sshd-123456
	
	6d04e0519384d4f8e2f6608903b5e257ca84897a7b35955607b8279bca45b1c9
	
	# docker port test-sshd 22  
	
	0.0.0.0:1024
	
	# ssh root@172.17.0.4 -p 1024
	