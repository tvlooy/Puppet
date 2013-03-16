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
    exec { "NginxUserChange" :
        command => "sed -i 's/user www-data/user vagrant/' /etc/nginx/nginx.conf",
        onlyif  => "grep -c 'user www-data' /etc/nginx/nginx.conf",
        require => Package["nginx"],
        notify  => Service["nginx"],
    }

    # Disable default site
    file { '/etc/nginx/sites-enabled/default':
        ensure => absent,
        require => Package["nginx"],
        notify  => Service["nginx"],
    }
}
