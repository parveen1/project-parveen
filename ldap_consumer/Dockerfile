# Version: 0.0.1
# parveen hisix2
# ldapserver base edt.org dataDB
# -------------------------------------
FROM fedora:27
LABEL author="Parveen hisix2"
LABEL description="ldapserver edt.org cn dataDB"
RUN dnf -y install procps openldap-clients openldap-servers nmap telnet
RUN mkdir /opt/docker
COPY * /opt/docker/
RUN chmod +x /opt/docker/install.sh /opt/docker/startup.sh
WORKDIR /opt/docker
EXPOSE 389
CMD ["/opt/docker/startup.sh"]


