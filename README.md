# Project parveen Servei LDAP

my project is about to explaine some basic and adv. function openldap.i am going to explaine step by step different function of ldap.

Here i used different docker to make different ldap server and database of ldap.

Also we are going to use as clients how is work connection etc.

we start from basic information and knowledge about opeldap......thanks

**LDAP stands for Lightweight Directory Access Protocol**
**when to use ldap**

* Machine Authentication
* User Authentication
* User/System Groups
* Address book
* Organization Representation
* Asset Tracking
* Telephony Information Store
* User resource management
* E-mail address lookups
* Application Configuration store
* PBX Configuration store

**ldap workk**

LDAP utilizes a client-server model. One or more LDAP servers contain the data making up the directory information tree (DIT)

**slapd conf**

slapd(8) is an LDAP directory server that runs on many different platforms. You can use it to provide a directory service of your very own. Your directory can contain pretty much anything you want to put in it. You can connect it to the global LDAP directory service, or run a service all by yourself.

### Data for ldif

**Here i show how is my structure of ldif file all data hbd beacuse of more function we can use**

* start with Distinguished Name **dc=edt,dc=org**

* make organization in this data **o=europa,dc=edt,dc=org**

* now make organization unit in my case **ou=usuaris,o=europa,dc=edt,dc=org**

* add new organization unit in my case **ou=group,o=europa,dc=edt,dc=org**

* add new organization unit in my case **ou=usermod,o=europa,dc=edt,dc=org**


* add new organization unit in my case **ou=maquines,o=europa,dc=edt,dc=org**

* now make new organization for another subordinate in my case **o=asia,dc=edt,dc=org**

**after this all data will be make another place or docker**

* now make organization unit in my case **ou=usuaris,o=asia,dc=edt,dc=org**

* add new organization unit in my case **ou=group,o=asia,dc=edt,dc=org**

* add new organization unit in my case **ou=usermod,o=asia,dc=edt,dc=org**


* add new organization unit in my case **ou=maquines,o=asia,dc=edt,dc=org**

![end](aux/data_ldap.png)


### Schema Specification

**To save data in a readable format in ldap we called schema(this is reason so we can )**

different schema make esay to read and write also make fuctionable data in
 ldif very important to know different type of like photo,dn,cn,binary file etc.

here one simple exemple make by mi

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

```
docker run --rm --name ldap_schema -h ldap_schema --network project -d parveen1992/ldap_schema
```

**after that check by php ldap to how looks like**

```
http://localhost:80/phpldapamin/
```

```
docker run --rm --name ldap_php -h ldap_php --net project -p 2080:80 -it parveen1992/ldap_php /bin/bash
```

**avd. serch in ldap**

```
ldapsearch -x -LLL -h localhost -D "cn=user01,ou=usermod,o=europa,dc=edt,dc=org" -w user01 "(cn=pere pou)"
```

**my localhost page**

```
<h1> hello everyone </h1>

welcome to my page

page for everyone

<br>

<a href="http://localhost:2080/phpldapadmin">see phot data binnary</a>

<br>

<a href="http://localhost:3080">login</a>

```

### Scripts

**here i make some useful scripts /etc/passwd to ldif file**

make groop file

```
python group_make_ldif.py groupfile.txt group.ldif
``` 
make user file

```
python user_make_ldif.py user_file.txt user.ldif

```


**some try form outside**

```
[root@i03 scripts]# ldapadd -h 172.18.0.2 -D "cn=Manager,dc=edt,dc=org" -w jupiter -f group.ldif 
adding new entry "cn=grouplocal01,ou=group,o=europa,dc=edt,dc=org "

adding new entry "cn=grouplocal02,ou=group,o=europa,dc=edt,dc=org "

adding new entry "cn=grouplocal03,ou=group,o=europa,dc=edt,dc=org "

```

my scripts

```
#! /bin/bash
# description add authomatic all user
rm -rf group.ldif
rm -rf user.ldif

python group_make_ldif.py groupfile.txt group.ldif

python user_make_ldif.py user_file.txt user.ldif

# insisde from network or docker(from out must use ip address)
ldapadd -h ldap_schema -D "cn=Manager,dc=edt,dc=org" -w jupiter -f group.ldif
ldapadd -h ldap_schema -D "cn=Manager,dc=edt,dc=org" -w jupiter -f user.ldif

```



### Replication

**ldap server backup save called replication**

OpenLDAP now supports a wide variety of replication topologies, these terms have been deprecated in favor of provider and consumer: A provider replicates directory updates to consumers; consumers receive replication updates from providers. Unlike the rigidly defined master/slave relationships, provider/consumer roles are quite fluid: replication updates received in a consumer can be further propagated by that consumer to other servers, so a consumer can also act simultaneously as a provider. Also, a consumer need not be an actual LDAP server; it may be just an LDAP client.

but today ldap user ldap provider and consumer server which can we use both as main server and for backup.


![end](aux/provider_consumer.png)


here is all configutaion of this server all if you like also use my docker

make new network

```
docker network crete project
```

now start both docker one by one

```
docker run --rm --name ldap_p -h ldap_p --net project -it  parveen1992/ldap_provider /bin/bash
```

```
docker run --rm --name ldap_c -h ldap_c --net project -it  parveen1992/ldap_consumer /bin/bash
```

**This is my modify.ldif**

```
dn: cn=Pere Pou,ou=usuaris,dc=edt,dc=org
changetype: modify
add: description
description: add by provider
```

**not posible to modify**

```

ldapmodify -vx -h ldap_c -D "cn=user02,ou=usermod,o=europa,dc=edt,dc=org" -w user01 -f modify.ldif
```

**But you can change anythings in master or consumer**

```
ldapmodify -vx -h ldap_p -D "cn=Manager,dc=edt,dc=org" -w jupiter -f modify.ldif

ldapmodify -vx -h ldap_c -D "cn=Manager,dc=edt,dc=org" -w jupiter -f modify.ldif

ldapmodify -vx -h ldap_c -D "cn=user01,ou=usermod,o=europa,dc=edt,dc=org" -w user01 -f modify.ldif
```

##### provider

**overlay syncprov**

Add in plugin for save all entres later update for consumer

**syncprov-checkpoint 50 10**

this means update ever 50 operction or 10 mintus

**syncprov-sessionlog 100**

user log in after 100

##### consumer

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


### Subordinate

**Subordinate knowledge information may be provided to delegate a subtree. Subordinate knowledge information is maintained in the directory as a special referral object at the delegate point. The referral object acts as a delegation point, gluing two services together. This mechanism allows for hierarchical directory services to be constructed.**


**NOTE:- if one data str. conf to where we can find iformation about this DSA (another DIT) this is called referral**


**But we use this referral to server collect all information and send to client**  


![end](aux/sub_master.png)

**docker ldapmaster**

```
docker run --rm --name ldap_sub_master -h ldap_sub_master --net project -d  parveen1992/ldap_sub_master
```

**docker ldap_sub**

```
docker run --rm --name ldap_sub -h ldap_sub --net project -d  parveen1992/ldap_sub
```

**search in both data**

```
ldapsearch -M -b "dc=subtree,dc=edt,dc=org" -x "(objectclass=referral)" '*' ref

[root@ldap_sub_master docker]# ldapsearch -M -LLL -b "o=asia,dc=edt,dc=org" -x "(objectclass=referral)" '*' ref
dn: o=asia,dc=edt,dc=org
objectClass: referral
objectClass: extensibleObject
o: asia
ref: ldap://ldap_sub/o=asia,dc=edt,dc=org

```

**referrels to find master to by usind sub**


**try in master**

```

[root@ldap_sub_master docker]# ldapsearch -x -LLL -D "cn=Manager,dc=edt,dc=org" -b "o=asia,dc=edt,dc=org" -w jupiter dn
dn: o=asia,dc=edt,dc=org

dn: ou=maquines,o=asia,dc=edt,dc=org

dn: ou=group,o=asia,dc=edt,dc=org

dn: ou=usermod,o=asia,dc=edt,dc=org

dn: ou=usuaris,o=asia,dc=edt,dc=org

dn: cn=Pere Pou,ou=usuaris,o=asia,dc=edt,dc=org

dn: cn=Admin System,ou=usuaris,o=asia,dc=edt,dc=org

dn: cn=user01,ou=usermod,o=asia,dc=edt,dc=org

dn: cn=group01,ou=group,o=asia,dc=edt,dc=org

dn: cn=group02,ou=group,o=asia,dc=edt,dc=org

```

```
[root@ldap_sub_master docker]# ldapsearch -x -LLL -D "cn=Manager,o=asia,dc=edt,dc=org" -b "o=asia,dc=edt,dc=org" -w jupiter dn
ldap_bind: Invalid credentials (49)

```


### Ldap httpd

** add modul mod_ldap **

conf. like this

```
[root@ldap_httpd docker]# cat ldap_httpd.conf 
<VirtualHost *:80>
        ServerAdmin webmaster@localhost
        ServerName ldap_httpd
	DocumentRoot /var/www/ldap
        <Directory /var/www/ldap>
                Options Indexes FollowSymLinks MultiViews
                AllowOverride None
                Order deny,allow
                Deny from All
               
		AuthType Basic
                AuthBasicProvider ldap
                AuthName "Test OPenLDAP login"
                AuthLDAPURL ldap://ldap_schema/ou=usuaris,o=europa,dc=edt,dc=org?uid
                AuthLDAPBindDN "cn=user01,ou=usermod,o=europa,dc=edt,dc=org"
                AuthLDAPBindPassword "user01"
                Require valid-user
                Satisfy any

        </Directory>
</VirtualHost>

```


**result of some connection try**

```
172.18.0.1 - - [14/May/2019:09:35:34 +0000] "GET / HTTP/1.1" 401 381 "-" "Mozilla/5.0 (X11; Fedora; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/67.0.3396.79 Safari/537.36"
172.18.0.1 - pere [14/May/2019:09:35:45 +0000] "GET / HTTP/1.1" 304 - "-" "Mozilla/5.0 (X11; Fedora; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/67.0.3396.79 Safari/537.36"
172.18.0.1 - pere [14/May/2019:09:35:45 +0000] "GET /favicon.ico HTTP/1.1" 404 209 "http://172.18.0.2/" "Mozilla/5.0 (X11; Fedora; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/67.0.3396.79 Safari/537.36"

```


**docker start and also connect able to ldap_schema**

```
docker run --rm --name ldap_httpd -h ldap_httpd --network project -p 3080:80 -it parveen1992/ldap_httpd /bin/bash

```


###  LDAP TLS

**docker connect to ldap_schema by using tls (ca certificat) or start tls means that can connect normal or if both client and erver have conf for tls then start tls**

**user old cert to my new data working great**
**must be use same and no project network beacuse of ip adress**

```
docker run --rm --name ldap.edt.org -h ldap.edt.org -it parveen1992/ldaps /bin/bash
```


### LDAP PAM

**here docker ldap_pam  connect to ldap_schema and valid to user to login mount of home if not exists then make new one by using pam conf.**

**pam docker as host**

```
docker run --rm --name host -h host --net project --privileged -it parveen1992/ldap_pam /bin/bash
```

**some try**

```
[root@host docker]# su - pere
Creating directory '/tmp/home/pere'.
reenter password for pam_mount:
[pere@host ~]$ pwd
/tmp/home/pere
[pere@host ~]$ ll
total 0
drwxr-xr-x. 2 pere group01 40 May 19 16:06 test
[pere@host ~]$ su - marta
pam_mount password:
Creating directory '/tmp/home/marta'.
[marta@host ~]$ ll
total 0
[marta@host ~]$ pwd
/tmp/home/marta

```








## After this only extra information for mi thankyou for join my page


![end](aux/end_photo1.png)

 
**########################################################################**


### Tecnologies: LDAP, Docker, TLS

Implementar un servei LDAP usant containers Docker i crear models de tot tipus de
funcionalitats: producer, consumer, subarbres, etc. Usar una base de dades àmplia i integrar-hi
contingut binari amb imatges, documents i certificats digitals.

**here i explane about provider and consumer**

```
18. Replication

Replicated directories are a fundamental requirement for delivering a resilient enterprise deployment.

OpenLDAP has various configuration options for creating a replicated directory. In previous releases, replication was discussed in terms of a master server and some number of slave servers. A master accepted directory updates from other clients, and a slave only accepted updates from a (single) master. The replication structure was rigidly defined and any particular database could only fulfill a single role, either master or slave.

As OpenLDAP now supports a wide variety of replication topologies, these terms have been deprecated in favor of provider and consumer: A provider replicates directory updates to consumers; consumers receive replication updates from providers. Unlike the rigidly defined master/slave relationships, provider/consumer roles are quite fluid: replication updates received in a consumer can be further propagated by that consumer to other servers, so a consumer can also act simultaneously as a provider. Also, a consumer need not be an actual LDAP server; it may be just an LDAP client.

The following sections will describe the replication technology and discuss the various replication options that are available.
```


**make one master server more than one computer**

```
18.3.3. N-Way Multi-Master

For the following example we will be using 3 Master nodes. Keeping in line with test050-syncrepl-multimaster of the OpenLDAP test suite, we will be configuring slapd(8) via cn=config

This sets up the config database:

     dn: cn=config
     objectClass: olcGlobal
     cn: config
     olcServerID: 1

     dn: olcDatabase={0}config,cn=config
     objectClass: olcDatabaseConfig
     olcDatabase: {0}config
     olcRootPW: secret

second and third servers will have a different olcServerID obviously:

     dn: cn=config
     objectClass: olcGlobal
     cn: config
     olcServerID: 2

     dn: olcDatabase={0}config,cn=config
     objectClass: olcDatabaseConfig
     olcDatabase: {0}config
     olcRootPW: secret

This sets up syncrepl as a provider (since these are all masters):

     dn: cn=module,cn=config
     objectClass: olcModuleList
     cn: module
     olcModulePath: /usr/local/libexec/openldap
     olcModuleLoad: syncprov.la

Now we setup the first Master Node (replace $URI1, $URI2 and $URI3 etc. with your actual ldap urls):

     dn: cn=config
     changetype: modify
     replace: olcServerID
     olcServerID: 1 $URI1
     olcServerID: 2 $URI2
     olcServerID: 3 $URI3

     dn: olcOverlay=syncprov,olcDatabase={0}config,cn=config
     changetype: add
     objectClass: olcOverlayConfig
     objectClass: olcSyncProvConfig
     olcOverlay: syncprov

     dn: olcDatabase={0}config,cn=config
     changetype: modify
     add: olcSyncRepl
     olcSyncRepl: rid=001 provider=$URI1 binddn="cn=config" bindmethod=simple
       credentials=secret searchbase="cn=config" type=refreshAndPersist
       retry="5 5 300 5" timeout=1
     olcSyncRepl: rid=002 provider=$URI2 binddn="cn=config" bindmethod=simple
       credentials=secret searchbase="cn=config" type=refreshAndPersist
       retry="5 5 300 5" timeout=1
     olcSyncRepl: rid=003 provider=$URI3 binddn="cn=config" bindmethod=simple
       credentials=secret searchbase="cn=config" type=refreshAndPersist
       retry="5 5 300 5" timeout=1
     -
     add: olcMirrorMode
     olcMirrorMode: TRUE

```

**some more information**


```
12.14. Sync Provider
12.14.1. Overview

This overlay implements the provider-side support for the LDAP Content Synchronization (RFC4533) as well as syncrepl replication support, including persistent search functionality.
12.14.2. Sync Provider Configuration

There is very little configuration needed for this overlay, in fact for many situations merely loading the overlay will suffice.

However, because the overlay creates a contextCSN attribute in the root entry of the database which is updated for every write operation performed against the database and only updated in memory, it is recommended to configure a checkpoint so that the contextCSN is written into the underlying database to minimize recovery time after an unclean shutdown:

       overlay syncprov
       syncprov-checkpoint 100 10

For every 100 operations or 10 minutes, which ever is sooner, the contextCSN will be checkpointed.

The four configuration directives available are syncprov-checkpoint, syncprov-sessionlog, syncprov-nopresent and syncprov-reloadhint which are covered in the man page discussing various other scenarios where this overlay can be used.

First we configure the overlay in the normal manner:

       include     /usr/local/etc/openldap/schema/core.schema
       include     /usr/local/etc/openldap/schema/cosine.schema
       include     /usr/local/etc/openldap/schema/nis.schema
       include     /usr/local/etc/openldap/schema/inetorgperson.schema

       pidfile     ./slapd.pid
       argsfile    ./slapd.args

       database    bdb
       suffix      "dc=suretecsystems,dc=com"
       rootdn      "cn=trans,dc=suretecsystems,dc=com"
       rootpw      secret
       directory   ./openldap-data

       index       objectClass eq

       overlay     translucent
       translucent_local carLicense

       uri         ldap://192.168.X.X:389
       lastmod     off
       acl-bind    binddn="cn=admin,dc=suretecsystems,dc=com" credentials="blahblah"

You will notice the overlay directive and a directive to say what attribute we want to be able to search against in the local database. We must also load the ldap backend which will connect to the remote directory server.

Now we take an example LDAP group:

       # itsupport, Groups, suretecsystems.com
       dn: cn=itsupport,ou=Groups,dc=suretecsystems,dc=com
       objectClass: posixGroup
       objectClass: sambaGroupMapping
       cn: itsupport
       gidNumber: 1000
       sambaSID: S-1-5-21-XXX
       sambaGroupType: 2
       displayName: itsupport
       memberUid: ghenry
       memberUid: joebloggs

and create an LDIF file we can use to add our data to the local database, using some pretty strange choices of new attributes for demonstration purposes:

       [ghenry@suretec test_configs]$ cat test-translucent-add.ldif
       dn: cn=itsupport,ou=Groups,dc=suretecsystems,dc=com
       businessCategory: frontend-override
       carLicense: LIVID
       employeeType: special
       departmentNumber: 9999999
       roomNumber: 41L-535

```


**some more information about subarbres**

```
17.1. Subordinate Knowledge Information

Subordinate knowledge information may be provided to delegate a subtree. Subordinate knowledge information is maintained in the directory as a special referral object at the delegate point. The referral object acts as a delegation point, gluing two services together. This mechanism allows for hierarchical directory services to be constructed.

A referral object has a structural object class of referral and has the same Distinguished Name as the delegated subtree. Generally, the referral object will also provide the auxiliary object class extensibleObject. This allows the entry to contain appropriate Relative Distinguished Name values. This is best demonstrated by example.

If the server a.example.net holds dc=example,dc=net and wished to delegate the subtree ou=subtree,dc=example,dc=net to another server b.example.net, the following named referral object would be added to a.example.net:

        dn: dc=subtree,dc=example,dc=net
        objectClass: referral
        objectClass: extensibleObject
        dc: subtree
        ref: ldap://b.example.net/dc=subtree,dc=example,dc=net

The server uses this information to generate referrals and search continuations to subordinate servers.

For those familiar with X.500, a named referral object is similar to an X.500 knowledge reference held in a subr DSE.

```

**overlays**

i understand all conf. to save log information (about need to teacher agains)

```
12. Overlays

Overlays are software components that provide hooks to functions analogous to those provided by backends, which can be stacked on top of the backend calls and as callbacks on top of backend responses to alter their behavior.

Overlays may be compiled statically into slapd, or when module support is enabled, they may be dynamically loaded. Most of the overlays are only allowed to be configured on individual databases.

Some can be stacked on the frontend as well, for global use. This means that they can be executed after a request is parsed and validated, but right before the appropriate database is selected. The main purpose is to affect operations regardless of the database they will be handled by, and, in some cases, to influence the selection of the database by massaging the request DN.

Essentially, overlays represent a means to:

    customize the behavior of existing backends without changing the backend code and without requiring one to write a new custom backend with complete functionality
    write functionality of general usefulness that can be applied to different backend types

When using slapd.conf(5), overlays that are configured before any other databases are considered global, as mentioned above. In fact they are implicitly stacked on top of the frontend database. They can also be explicitly configured as such:

        database frontend
        overlay <overlay name>

Overlays are usually documented by separate specific man pages in section 5; the naming convention is

        slapo-<overlay name>

All distributed core overlays have a man page. Feel free to contribute to any, if you think there is anything missing in describing the behavior of the component and the implications of all the related configuration directives.

Official overlays are located in

        servers/slapd/overlays/

That directory also contains the file slapover.txt, which describes the rationale of the overlay implementation, and may serve as a guideline for the development of custom overlays.

Contribware overlays are located in

        contrib/slapd-modules/<overlay name>/

along with other types of run-time loadable components; they are officially distributed, but not maintained by the project.

All the current overlays in OpenLDAP are listed and described in detail in the following sections.
```




**extra information also**

```
17.2. Superior Knowledge Information

Superior knowledge information may be specified using the referral directive. The value is a list of URIs referring to superior directory services. For servers without immediate superiors, such as for a.example.net in the example above, the server can be configured to use a directory service with global knowledge, such as the OpenLDAP Root Service (http://www.openldap.org/faq/index.cgi?file=393).

        referral        ldap://root.openldap.org/

However, as a.example.net is the immediate superior to b.example.net, b.example.net would be configured as follows:

        referral        ldap://a.example.net/

The server uses this information to generate referrals for operations acting upon entries not within or subordinate to any of the naming contexts held by the server.

For those familiar with X.500, this use of the ref attribute is similar to an X.500 knowledge reference held in a Supr DSE.
17.3. The ManageDsaIT Control

Adding, modifying, and deleting referral objects is generally done using ldapmodify(1) or similar tools which support the ManageDsaIT control. The ManageDsaIT control informs the server that you intend to manage the referral object as a regular entry. This keeps the server from sending a referral result for requests which interrogate or update referral objects.

The ManageDsaIT control should not be specified when managing regular entries.

The -M option of ldapmodify(1) (and other tools) enables ManageDsaIT. For example:

        ldapmodify -M -f referral.ldif -x -D "cn=Manager,dc=example,dc=net" -W

or with ldapsearch(1):

        ldapsearch -M -b "dc=example,dc=net" -x "(objectclass=referral)" '*' ref

Note: the ref attribute is operational and must be explicitly requested when desired in search results.

Note: the use of referrals to construct a Distributed Directory Service is extremely clumsy and not well supported by common clients. If an existing installation has already been built using referrals, the use of the chain overlay to hide the referrals will greatly improve the usability of the Directory system. A better approach would be to use explicitly defined local and proxy databases in subordinate configurations to provide a seamless view of the Distributed Directory.

Note: LDAP operations, even subtree searches, normally access only one database. That can be changed by gluing databases together with the subordinate/olcSubordinate keyword. Please see slapd.conf(5) and slapd-config(5). 
```

### Docker:

* Implementar per separat en un container de Docker cada un dels components: servidor,
backup, subarbre, clients, etc.
* Generar els dockerfiles pertinets amb contingut i documentació propia.
* Generació automàtica de les imatges a través de GitHub + DockerHub.
Servidor LDAP:
* Crear una base de dades LDAP amb usuaris, grups, màquines ( i fins i tot algun altre
concepte com aules o material).
* Implementar un script de càrrega automatitzada d’usuaris partint de /etc/passwd i
/etc/group (en python).
* Implementar un servidor LDAP i diversos servidors de rèplica (més d’un).
* Implementar subarbres (delegació de zona) usant almenys dos subarbres.
* Implementar formats de dades no textuals: fotos dels usuaris i documents PDF amb


## start make docker

make new network

```
docker network crete project
```

now start both docker one by one

```
docker run --rm --name ldap_p -h ldap_p --net project -d  parveen1992/provider
```

```
docker run --rm --name ldap_c -h ldap_c --net project -d  parveen1992/consumer
```

**This is my modify.ldif**

```
dn: cn=Pere Pou,ou=usuaris,dc=edt,dc=org
changetype: modify
add: description
description: add by provider
```


```
ldapmodify -vx -h ldap_c -D "cn=Manager,dc=edt,dc=org" -w jupiter -f modify.ldif
```

**But you can change anythings in master**

```
ldapmodify -vx -h ldap_p -D "cn=Manager,dc=edt,dc=org" -w jupiter -f modify.ldif
```


### start docker master and suburdinate

**docker ldapmaster**

```
docker run --rm --name ldap_sub_master -h ldap_sub_master --net project -d  parveen1992/ldap_sub_master
```

**docker ldap_sub**

```
docker run --rm --name ldap_sub -h ldap_sub --net project -d  parveen1992/ldap_sub
```

**search in both data**

```
ldapsearch -M -b "dc=subtree,dc=edt,dc=org" -x "(objectclass=referral)" '*' ref
```

**referrels to find master to by usind sub**



**docker ldap_schema add photo and pdf**

```
docker run --rm --name ldap_schema -h ldap_schema --network project -d parveen1992/ldap_schema 
```

**after that check by php ldap to how looks like**

```
http://ip-address:80/phpldapamin/

docker run --rm --name php -h php --net project -it parveen1992/ldap_php /bin/bash
```

### expedients o altres formats binaris.

* Implementar Overlays.
* Tràfic segure amb TLS/SSL i STARTTLS (Entitat CA propia).
Clients LDAP:
* Implementació d’autenticació d’usuari amb LDAP: login / PAM.
* Autenticació d’usuaris en un servidor Web.


### Altres tasques:

* Exportar les bases de dades a altres formats com per exemple text pla, sql i sobretot:
json.
* Tuning de la BD en calent.
* Explotació de les dades de monitor.
