% PROJECT SERVICE LDAP
% PARVEEN
% 2019/06/05

# PROJECT INFO

My project is make one empresa in europa but also have user in asia.

Empresa with different user and user access control.

Here i used different docker to make different ldap server and database of ldap.

Also we are going to use as clients interface and how is work connection etc.

we start from basic information and knowledge about opeldap


# BASIC INFORMATION

* LDAP
* LDAP WORK
* SLAPD.CONF
* LDIF
* SCHEMA
* BDB AND HDB
* REFERRAL
* OVERLAY CHAIN

# LDAP

LDAP stands for Lightweight Directory Access Protocol


# Where we use ldap

* Machine Authentication
* User Authentication
* User/System Groups
* Address book
* Organization Representation
* Telephony Information Store
* E-mail address look ups
* Application Configuration store



# LDAP WORK

LDAP utilizes a client-server model. 

One or more LDAP servers contain the data making up the directory information tree (DIT)

![serverclientFigure](aux/serverClient.png)


# SLAPD CONF

This directory can contain pretty much anything you want to put in it. 

You can connect it to the global LDAP directory service, or run a service all by yourself.



# LDIF

The LDAP Data Interchange Format (LDIF) is a standard plain text data interchange format for representing LDAP (Lightweight Directory Access Protocol) directory content and update requests.

# BDB AND HDB  

The bdb backend to slapd is the recommended primary backend for a normal slapd database. It uses the Oracle Berkeley DB (BDB) package to store data. It makes extensive use of indexing and caching to speed data access.

hdb is a variant of the bdb backend that uses a hierarchical database layout which supports subtree renames. It is otherwise identical to the bdb behavior, and all the same configuration options apply.

# REFERRAL

An alias contains the DN of another object, where as a referral contains one or more URLs of objects.

# OVERLAY CHAIN

What is chaining? 

It indicates the capability of a DSA(directory system agent) to follow referrals on behalf of the client, so that distributed systems are viewed as a single virtual DSA by clients that are otherwise unable to "chase" (i.e. follow) referrals by themselves.

# STRUCTURE OF MY LDIF

**Here i show how is my structure of ldif file all data hbd beacuse of more function we can use**

* start with Distinguished Name(suffix) **dc=edt,dc=org**

* make organization in this data **o=europa,dc=edt,dc=org**

* now make organization unit in my case **ou=usuaris,o=europa,dc=edt,dc=org**

* add new organization unit in my case **ou=group,o=europa,dc=edt,dc=org**

* add new organization unit in my case **ou=usermod,o=europa,dc=edt,dc=org**

* add new organization unit in my case **ou=maquines,o=europa,dc=edt,dc=org**

* now make new organization for another subordinate in my case **o=asia,dc=edt,dc=org**


# sub tree server

**after this all data will be make another place or docker**

* now make organization unit in my case **ou=usuaris,o=asia,dc=edt,dc=org**

* add new organization unit in my case **ou=group,o=asia,dc=edt,dc=org**

* add new organization unit in my case **ou=usermod,o=asia,dc=edt,dc=org**


* add new organization unit in my case **ou=maquines,o=asia,dc=edt,dc=org**


# FIGURE 

![dataStructureFigure](aux/data_ldap.png)





# Schema Specification

**To save data in a readable format we need some rules.These rules called schema in ldap**

Different schema make esay to read and write also make fuctionable data inldif very important to know different type of like photo,dn,cn,binary file etc.

# Here one simple exemple make by mi

```
# schema add photo and pdf:
#          foto, pdf
# parveen
# Objecte  Auxiliary  (derivat de TOP)
#
attributetype (1.1.2.1.1 NAME 'xfoto'
  DESC 'foto del user jpeg'
  SYNTAX 1.3.6.1.4.1.1466.115.121.1.28)

attributetype (1.1.2.1.2 NAME 'xpdf'
  DESC 'pdf file'
  SYNTAX  1.3.6.1.4.1.1466.115.121.1.5
  SINGLE-VALUE)

objectclass (1.1.2.2.1 NAME 'xuser'
  DESC 'user add foto and pdf'
  SUP TOP
  AUXILIARY
  MUST ( xfoto $ xpdf )
 )
```
**docker ldap_schema add photo and pdf**


# Scripts

**Here i make one useful scripts .This scripts change format /etc/passwd to ldif file**

we can use use this scripts to add all of localuser and group in ldap server.

# my scripts

```
#! /bin/bash
# description add authomatic all user
rm -rf group.ldif
rm -rf user.ldif
python group_make_ldif.py groupfile.txt group.ldif
python user_make_ldif.py user_file.txt user.ldif
```






# Replication

**ldap server backup save called replication**

OpenLDAP now supports a wide variety of replication topologies, these terms have been deprecated in favor of provider and consumer: A provider replicates directory updates to consumers; consumers receive replication updates from providers. Unlike the rigidly defined master/slave relationships, provider/consumer roles are quite fluid: replication updates received in a consumer can be further propagated by that consumer to other servers, so a consumer can also act simultaneously as a provider. Also, a consumer need not be an actual LDAP server; it may be just an LDAP client.

but today ldap user ldap provider and consumer server which can we use both as main server and for backup.

# Understand by figure

![providerAndConsumerFigure](aux/provider_consumer.png)


# This is my modifyldif

```
dn: cn=Pere Pou,ou=usuaris,dc=edt,dc=org
changetype: modify
add: description
description: add by provider
```

**But you can change anythings in master or consumer**


# provider

* overlay syncprov
* syncprov-checkpoint 50 10
* syncprov-sessionlog 100


# consumer

**addtion conf. in consumer**

```
syncrepl rid=001
  provider=ldap://ldap_p
  type=refreshOnly
  interval=00:00:00:10
  searchbase="dc=edt,dc=org"
  binddn="cn=Manager,dc=edt,dc=org"
  credentials=jupiter
updateref ldap://ldap_p
```


# Subordinate 

**Subordinate knowledge information may be provided to delegate a subtree. Subordinate knowledge information is maintained in the directory as a special referral object at the delegate point. The referral object acts as a delegation point, gluing two services together. This mechanism allows for hierarchical directory services to be constructed.**


**NOTE:- This posible if one data str. tell you where we can find information about this DSA (another DIT) this is called referral**


**But we use this referral to server collect all information and send to client**  

# Understand by figure

![ldapMasterFigure](aux/sub_master.png)



# LDAP TLS basic 

**Transport Layer Security**

**Client connect to ldap_sub_master and ldap_sub by using tls (ca certificat) or start tls.**

**In above connection between ldap_sub_master and ldap_sub we tls**



# LDAP PAM

**here docker ldap_pam  connect as client to ldap_schema(server) and valid to user to login mount of home if not exists then make new home directroy by using pam configuration**


# GRAHICAL VIEW

* php
* httpd

# PHP

**Here we start docker php client and use localhost httpd server to see photo and pdf file of user**




# Ldap httpd

**Here we use client docker httpd connect to docker ldap_schema and check user authication** 

# THANKYOU 

![](aux/end_photo1.png)

 
