#!/bin/sh
dbuser=$1
dbpass=$2
dbname=$3

if [ -f /vagrant/database.sql.gz ]; then
    tables=$(mysql -sN -u$dbuser -p$dbpass -e "select count(*) from information_schema.tables where table_schema = \"$dbname\"")
    if [ "$tables" -eq "0" ]; then
        zcat /vagrant/database.sql.gz | mysql -u$dbuser -p$dbpass $dbname
    fi
fi
