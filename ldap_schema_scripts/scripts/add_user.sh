#! /bin/bash
# Parveen 
# Group hsix2
# Date 2019-05-15
# Description:- add automatical all localhoat user and group
# In my case every time i check if any other name exixts if yes than delete this file.
rm -rf group.ldif
rm -rf user.ldif

# In file groupfile.txt file like /etc/group
# And user_file.txt like /etc/passwd
# And i make two different file of scripts in python change in format in elif
# Also need give name of this file line group.ldif and user.ldif

python group_make_ldif.py groupfile.txt group.ldif

python user_make_ldif.py user_file.txt user.ldif

# insisde from network or docker(from out must use ip address)
# ALso posible by slaadd as server
# but  in my case add more users as clients
ldapadd -h ldap_schema -D "cn=Manager,dc=edt,dc=org" -w jupiter -f group.ldif
ldapadd -h ldap_schema -D "cn=Manager,dc=edt,dc=org" -w jupiter -f user.ldif
