#!/bin/sh
wget http://ftp.drupal.org/files/projects/drush-7.x-5.8.tar.gz
tar xzvf drush-7.x-5.8.tar.gz -C /opt
ln -s /opt/drush/drush /usr/local/bin
chmod 777 /opt/drush/lib
rm -f drush-7.x-5.8.tar.gz
