#! /usr/bin/python
# -*- coding: utf-8 -*-
# Author:- Parveen
# Description:- a scripts to make local group to insert into ldap data
# Note:- This scripts only work if group file correct file corrcet and also not exists before this group in ldap data 

import sys

#start line by in file group

filegroup = open(sys.argv[1],'r')
group_ldif = open(sys.argv[2],'a')

for line in filegroup :
	gname = line.split(':')[0]
	gid = line.split(':')[2]
	user_list = line.split(':')[3]
	
	add_line = 'dn: cn=%s,ou=group,o=europa,dc=edt,dc=org \n' \
	'cn: %s\n' \
	'gidNumber: %s\n' \
	'description:  %s\n' \
	'objectclass: posixGroup\n' % (gname,gname,gid,'add new group')
	
	user_list = user_list.split(',')
	
	for user in user_list :
		if user != '\n' :
			add_line += 'memberUid: %s\n' % (user)
		else:
			add_line += '\n'
	group_ldif.write(add_line)

filegroup.close()
group_ldif.close()
