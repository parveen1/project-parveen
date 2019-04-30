# Project parveen Servei LDAP


### Tecnologies: LDAP, Docker, TLS

Implementar un servei LDAP usant containers Docker i crear models de tot tipus de
funcionalitats: producer, consumer, subarbres, etc. Usar una base de dades àmplia i integrar-hi
contingut binari amb imatges, documents i certificats digitals.

**i just start collect information about producer and consumer**


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
