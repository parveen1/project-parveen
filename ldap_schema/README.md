# ldapserver:18schema

## @edt ASIX M06-ASO Curs 2018-2019

Servidor ldap amb edt.org, totes les dades per cn
Schema de dades propi on definim atributs i objectes

## Futbolista

Usant el concepte 'futbolista' fem tres exemples d'objecte amb
futbol.schema i dades futbolistes.ldif

Attibuts:

 * xequip
 * xdorsal
 * xweb
 * xfoto
 * xlesionat

Objecte:

 * xfutbolista

### CasA

Objecte xfutbolista **derivat** de inetorgperson, **Structural**.

 * hereta els atributs de person 8cn, homePhone, etc)
 * implica que cn i sn són atributs obligatoris

### CasB

Objecte futbolista derivat de **TOP**, **Structural** i **Standalone**.

 * implica que cal un RDN que sigui clau per identificar el futbolista.
 * ja no disposa dels atributs cn, sn, homePhone, etc...
 * cal generar un nou atribut clau, com per xemple xfitxa 

### CasC

Objecte **Auxiliar** per usar conjuntament amb un altre objecte Structural

 * ja no cal (casB) el camp clau xfitxa, usarà com a RDN el del objecte structural associat





