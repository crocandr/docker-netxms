FROM ubuntu:xenial

RUN apt-get update && apt-get install -y curl vim less libssh-dev libmysqld-dev libpq-dev build-essential net-tools
# Package
#RUN curl -L -o /opt/netxms.deb http://packages.netxms.org/netxms-release_1.1_all.deb && dpkg -i /opt/netxms.deb
# Source code
RUN curl -L -o /opt/netxms.tar.gz https://www.netxms.org/download/netxms-2.0.6.tar.gz && tar xzf /opt/netxms.tar.gz -C /opt
RUN cd /opt/netxms-* && ./configure --with-server --with-agent --with-mysql --with-sqlite --with-pgsql --with-ldap && make && make install && cp -f contrib/netxmsd.conf-dist /etc/netxmsd.conf && cp -f contrib/nxagentd.conf-dist /etc/nxagentd.conf

COPY files/start.sh /opt/start.sh
RUN chmod 755 /opt/start.sh

