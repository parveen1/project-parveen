#dnf -y update vi
#dnf -y install vim iputils iproute nmap  mlocate procps man-db
#dnf -y install openldap-servers openldap-clients openldap-devel
#dnf -y install httpd phpldapadmin php-xml

# ./startup.sh
# httpd -S
# docker exec -it phpldapadmin /bin/bash

# Configure
#vim /etc/phpldapadmin/config.php
#$servers->setValue('server','name','Local LDAP Server');
#$servers->setValue('server','host','172.18.0.2');
#$servers->setValue('server','base',array('dc=edt,dc=org'));
#$servers->setValue('login','auth_type','session');
# Nomes si es vol fer bind no anonymous
#  $servers->setValue('login','bind_id','cn=Manager,dc=example,dc=com');
#  $servers->setValue('login','bind_pass','secret');
#$servers->setValue('server','tls',false);

# Permetre accés remot al servei phpldapadmin
# modificar les directives per permetre accés remot
# posant-ho al 2.4 o al 2.2
#vim /etc/httpd/conf.d/phpldapadmin.conf
  
    # Apache 2.4
    #Require local
    Require all granted
    
    # Apache 2.2
    #Order Deny,Allow
    #Deny from all
    Allow from *

rm -rf /etc/phpldapadmin/config.php
rm -rf /etc/httpd/conf.d/phpldapadmin.conf
rm -rf /etc/httpd/conf/httpd.conf

cp /opt/docker/config.php /etc/phpldapadmin/config.ph
cp /opt/docker/phpldapadmin.conf /etc/httpd/conf.d/phpldapadmin.conf
cp /opt/docker/httpd.conf /etc/httpd/conf/httpd.conf
