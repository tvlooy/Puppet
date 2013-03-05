class apache2 {
    package { "apache2" :
        name   => "apache2-mpm-prefork",
        ensure => present,
    }

    service { "apache2" :
        ensure  => running,
        require => Package["apache2"],
    }

    # Change user
    exec { "UserChange" :
        command => "sed -i 's/APACHE_RUN_USER=www-data/APACHE_RUN_USER=vagrant/' /etc/apache2/envvars",
        onlyif  => "grep -c 'APACHE_RUN_USER=www-data' /etc/apache2/envvars",
        require => Package["apache2"],
        notify  => Service["apache2"],
    }

    # Change group
    exec { "GroupChange" :
        command => "sed -i 's/APACHE_RUN_GROUP=www-data/APACHE_RUN_GROUP=vagrant/' /etc/apache2/envvars",
        onlyif  => "grep -c 'APACHE_RUN_GROUP=www-data' /etc/apache2/envvars",
        require => Package["apache2"],
        notify  => Service["apache2"],
    }

    # Change log files and logrotate permissions
    exec { "logfile_permissions" :
        command => "chmod -R a+rX /var/log/apache2",
        require => Package["apache2"],
    }
    exec { "logrotate_permissions" :
        command => "sed -i 's/640/660/' /etc/logrotate.d/apache2",
        require => Package["apache2"],
    }

    # Disable default site
    exec { "a2dissite default" :
        require => Package['apache2'],
        notify  => Service["apache2"],
    }
}
