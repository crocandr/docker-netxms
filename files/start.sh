#!/bin/bash

# default parameters

if [ ! -z $DB_Driver ]
then
  DBDriver=$DB_DRIVER
else
  DBDriver="mysql.ddr"
fi

if [ ! -z $DB_Server ]
then
  DBServer=$DB_Server
else
  DBServer="dbsrv"
fi

if [ ! -z $DB_Name ]
then
  DBName=$DB_Name
else
  DBName="netxms"
fi

if [ ! -z $DB_User ]
then
  DBLogin=$DB_User
else
  DBLogin="netxms"
fi

if [ ! -z $DB_Pass ]
then
  DBPassword=$DB_Pass
else
  DBPassword="secret"
fi


# configure netxms
sed -i "s@.*DBDriver =.*@DBDriver = $DBDriver@g" /etc/netxmsd.conf
sed -i "s@.*DBServer =.*@DBServer = $DBServer@g" /etc/netxmsd.conf
sed -i "s@.*DBName =.*@DBName = $DBName@g" /etc/netxmsd.conf
sed -i "s@.*DBLogin =.*@DBLogin = $DBLogin@g" /etc/netxmsd.conf
sed -i "s@.*DBPassword =.*@DBPassword = $DBPassword@g" /etc/netxmsd.conf

# configure agent
sed "s@.*MasterServers = .*@MasterServers = 127.0.0.1@g" /etc/nxagentd.conf | uniq > /etc/nxagentd.conf

# lib fix
cp -rf /usr/local/lib/* /lib/x86_64-linux-gnu/

# start
nxagentd -d
sleep 2
netxmsd -d

#
/bin/bash
