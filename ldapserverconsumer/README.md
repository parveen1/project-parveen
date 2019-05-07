# ldapserver consumer


**This docker cannot posible to modify database edt.org**

**only posible to do update with docker provider**


### Docker start server detouch

**Frist crete xarxa project**

```
docker network create project
```
**now  we can start docker with server automatic**

```
docker run --rm --name ldap_c -h ldap_c --net project -d  parveen1992/consumer

```
