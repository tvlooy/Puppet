class nginx {
    case $params::php_version {
        5.4: {
            if ! defined(Class["dotdeb"]) {
                class { 'dotdeb' : }
            }
        }
        default: {
            fail("This PHP version is not supported")
        }
    }

    package { "nginx" :
        name    => "nginx-full",
        ensure  => present,
        require => Class["dotdeb"],
    }

    service { "nginx" :
        ensure  => running,
        require => Package["nginx"],
    }

    # Change user
#    exec { "UserChange" :
#        command => "sed -i 's/APACHE_RUN_USER=www-data/APACHE_RUN_USER=vagrant/' /etc/apache2/envvars",
#        onlyif  => "grep -c 'APACHE_RUN_USER=www-data' /etc/apache2/envvars",
#        require => Package["apache2"],
#        notify  => Service["apache2"],
#    }

    # Change group
#    exec { "GroupChange" :
#        command => "sed -i 's/APACHE_RUN_GROUP=www-data/APACHE_RUN_GROUP=vagrant/' /etc/apache2/envvars",
#        onlyif  => "grep -c 'APACHE_RUN_GROUP=www-data' /etc/apache2/envvars",
#        require => Package["apache2"],
#        notify  => Service["apache2"],
#    }

    # Change log files and logrotate permissions
#    exec { "logfile_permissions" :
#        command => "chmod -R a+rX /var/log/apache2",
#        require => Package["apache2"],
#    }
#    exec { "logrotate_permissions" :
#        command => "sed -i 's/640/660/' /etc/logrotate.d/apache2",
#        require => Package["apache2"],
#    }

    # Disable default site
    file { '/etc/nginx/sites-enabled/default':
        ensure => absent,
        require => Package["nginx"],
        notify  => Service["nginx"],
    }
}
