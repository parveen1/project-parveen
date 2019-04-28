# Project parveen


**ldap servei**
Servei LDAP
Tecnologies: LDAP, Docker, TLS
Implementar un servei LDAP usant containers Docker i crear models de tot tipus de
funcionalitats: producer, consumer, subarbres, etc. Usar una base de dades àmplia i integrar-hi
contingut binari amb imatges, documents i certificats digitals.

**i just start collect information about producer and consumer**

Docker:
● Implementar per separat en un container de Docker cada un dels components: servidor,
backup, subarbre, clients, etc.
● Generar els dockerfiles pertinets amb contingut i documentació propia.
● Generació automàtica de les imatges a través de GitHub + DockerHub.
Servidor LDAP:
● Crear una base de dades LDAP amb usuaris, grups, màquines ( i fins i tot algun altre


concepte com aules o material).
● Implementar un script de càrrega automatitzada d’usuaris partint de /etc/passwd i
/etc/group (en python).
● Implementar un servidor LDAP i diversos servidors de rèplica (més d’un).
● Implementar subarbres (delegació de zona) usant almenys dos subarbres.
● Implementar formats de dades no textuals: fotos dels usuaris i documents PDF amb

expedients o altres formats binaris.
● Implementar Overlays.
● Tràfic segure amb TLS/SSL i STARTTLS (Entitat CA propia).
Clients LDAP:
● Implementació d’autenticació d’usuari amb LDAP: login / PAM.
● Autenticació d’usuaris en un servidor Web.


Altres tasques:
● Exportar les bases de dades a altres formats com per exemple text pla, sql i sobretot:
json.
● Tuning de la BD en calent.
● Explotació de les dades de monitor.
