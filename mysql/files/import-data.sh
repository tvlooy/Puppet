#!/bin/sh
if [ $# -lt 4 ]; then
    exit
fi

dbuser=$1
dbpass=$2
dbname=$3
sqldump=$4

if [ -f /vagrant/$sqldump ]; then
    tables=$(mysql -sN -u$dbuser -p$dbpass -e "select count(*) from information_schema.tables where table_schema = \"$dbname\"")
    if [ "$tables" -eq "0" ]; then
        zcat /vagrant/$sqldump | mysql -u$dbuser -p$dbpass $dbname
    fi
fi