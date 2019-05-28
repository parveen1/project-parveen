#! /usr/bin/python
# -*- coding: utf-8 -*-
# Author:- Parveen
# Description:- a scripts to make local group to  into ldif type of group file
# Note:- This scripts only work if group file is correct .if any of group alread exists in ldap data than ldap don't edit thia group.

import sys

#frist of all save file name and open as we need

filegroup = open(sys.argv[1],'r')
group_ldif = open(sys.argv[2],'a')

#run groupfile line by line
for line in filegroup :
    #find and save field we need
	gname = line.split(':')[0]
	gid = line.split(':')[2]
	user_list = line.split(':')[3]
	
    #make line for save in ldif file
	add_line = 'dn: cn=%s,ou=group,o=europa,dc=edt,dc=org \n' \
	'cn: %s\n' \
	'gidNumber: %s\n' \
	'description:  %s\n' \
	'objectclass: posixGroup\n' % (gname,gname,gid,'add new group')
	
        # all users also need to save one by one
	user_list = user_list.split(',')
	
	for user in user_list :
                # if user not exists in line
		if user != '\n' :
			add_line += 'memberUid: %s\n' % (user)
		else:
			add_line += '\n'
        # In last add in lfid file
	group_ldif.write(add_line)

# close both file 
filegroup.close()
group_ldif.close()
