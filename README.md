# Project parveen Servei LDAP


### Tecnologies: LDAP, Docker, TLS

Implementar un servei LDAP usant containers Docker i crear models de tot tipus de
funcionalitats: producer, consumer, subarbres, etc. Usar una base de dades àmplia i integrar-hi
contingut binari amb imatges, documents i certificats digitals.

**i just start collect information about producer and consumer**

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

● Implementar Overlays.
● Tràfic segure amb TLS/SSL i STARTTLS (Entitat CA propia).
Clients LDAP:
● Implementació d’autenticació d’usuari amb LDAP: login / PAM.
● Autenticació d’usuaris en un servidor Web.


### Altres tasques:

● Exportar les bases de dades a altres formats com per exemple text pla, sql i sobretot:
json.
● Tuning de la BD en calent.
● Explotació de les dades de monitor.
