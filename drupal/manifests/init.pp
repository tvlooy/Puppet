class drupal {
    file { '/vagrant/htdocs/sites/default/files' :
        ensure => directory,
        owner  => 'vagrant',
        group  => 'vagrant',
        mode   => '0775',
    }

    file { '/vagrant/htdocs/cache' :
        ensure => directory,
        owner  => 'vagrant',
        group  => 'vagrant',
        mode   => '0775',
    }

    file { '/vagrant/htdocs/sites/default/settings.php' :
        ensure => present,
        owner  => 'vagrant',
        group  => 'vagrant',
        source => '/vagrant/htdocs/sites/default/default.settings.php',
    }

    file { "/tmp/db_settings.inc" :
        ensure  => present,
        content => template("drupal/db_settings.inc.erb"),
        require => File["/vagrant/htdocs/sites/default/settings.php"],
    }

    exec { "db_settings" :
        command => 'cat /tmp/db_settings.inc >> /vagrant/htdocs/sites/default/settings.php ; rm /tmp/db_settings.inc',
        require => File["/tmp/db_settings.inc"],
    }

    exec { "add_puppet_banner" :
        command => 'sed -i "1a\\\n##### Managed by Puppet - Intracto Vagrant #####################################" /vagrant/htdocs/sites/default/settings.php',
        require => File['/vagrant/htdocs/sites/default/settings.php'],
    }

    exec { "get-drush" :
        command => 'curl http://ftp.drupal.org/files/projects/drush-7.x-5.8.tar.gz | tar xzvf - -C /opt',
        require => File["/tmp/db_settings.inc"],
        unless  => 'test -f /usr/local/bin/drush',
    }

    exec { "activate-drush" :
        command => 'ln -s /opt/drush/drush /usr/local/bin ; chmod -R 777 /opt/drush/lib',
        require => Exec["get-drush"],
        unless  => 'test -f /usr/local/bin/drush',
    }
}
