# NetXMS in docker

## Info

  - https://www.netxms.org/

## Build

You have to build only the NetXMS container if you need.

```
docker build -t croc/netxms .
```

This build runs a little bit longer than usual, because the docker going to build the netxms server from source.

## Run

The NetXMS container need some other containers:

  - DB - example: MySQL/MariadB
  - Web - for webUI

### DB with MariaDB

From official Mariadb container. URL: https://hub.docker.com/_/mariadb/

```
docker run -tid --name=netxms-db -v /srv/netxms/db:/var/lib/mysql -e MYSQL_ROOT_PASSWORD=supersecret -e MYSQL_DATABASE=netxms -e MYSQL_USER=netxms -e MYSQL_PASSWORD=secret mariadb
```

### NetXMS

```
docker run -tid --name=netxms --link netxms-db:dbsrv croc/netxms /opt/start.sh
```

After the first start, you have to init the DB with this command:
```
docker exec -ti netxms nxdbmgr init /opt/netxms-2.0.6/sql/dbinit_mysql.sql
docker restart netxms
```

### WebUI

From official Jetty container. URL: https://hub.docker.com/_/jetty/


You have to download NetXMS web war file to your docker host:
```
mkdir -p /srv/netxms/webapps
curl -L -o /srv/netxms/webapps/netxms.war https://www.netxms.org/download/webui/nxmc-2.0.6.war
```

Run jetty container:

```
docker run -tid --name=netxms-web -v /srv/netxms/webapps/:/var/lib/jetty/webapps -v /srv/netxms/webconfig:/home/jetty --link netxms:netxmssrv -p 8080:8080 jetty
```

On the login form, you have to change the `NetXMS server address` from the default to `netxmssrv` before you try log in!
This is a "bug", but I can't fix it (yet).

Default login is: admin / netxms


