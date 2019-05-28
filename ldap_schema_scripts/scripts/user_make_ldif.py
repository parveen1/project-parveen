#! /usr/bin/python
# -*- coding: utf-8 -*-
# Author:- Parveen
# Description:- a scripts to user make local user file into ldif file data
# Note:- This scripts only work if user file corrcet. 
import sys

# open file which we need 
user_file = open(sys.argv[1],'r')
user_ldif = open(sys.argv[2],'a')

#run file line by line
for line in user_file :
        #read and save all all of field we need
	login = line.split(':')[0]
	uid = line.split(':')[2]
	gid = line.split(':')[3]
	home = line.split(':')[5]
	shell = line.split(':')[6]
        #save line for ldif
	add_line = 'dn: uid=%s,ou=usuaris,o=europa,dc=edt,dc=org\n' \
				'objectclass: posixAccount\n' \
				'objectclass: inetOrgPerson\n' \
				'cn: %s\n' \
				'sn: %s\n' \
				'ou: %s\n' \
				'uid: %s\n' \
				'uidNumber: %s\n' \
				'gidNumber: %s\n' \
				'loginShell: %s' \
'homeDirectory: %s\n\n' % (login,login,login,'grup name',login,uid,gid,shell,home)
	#write add data into ldif file
        user_ldif.write(add_line)

#close both file
user_file.close()
user_ldif.close()
