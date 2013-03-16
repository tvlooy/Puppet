define php::fpm {
    case $name {
        5.4: {
            if ! defined(Class["dotdeb"]) {
                class { 'dotdeb' : }
            }

            package { "php5-fpm" :
                ensure  => present,
                require => Class["dotdeb"],
                notify  => Service[$params::http_server],
            }

            service { "php5-fpm" :
                ensure  => running,
                require => Package["php5-fpm"],
            }
        }
        default: {
            fail("This PHP version is not supported")
        }
    }
    
    # Change user
    exec { "FpmUserChange" :
        command => "sed -i 's/user = www-data/user = vagrant/' /etc/php5/fpm/pool.d/www.conf",
        onlyif  => "grep -c 'user = www-data' /etc/php5/fpm/pool.d/www.conf",
        require => Package["php5-fpm"],
        notify  => Service["php5-fpm"],
    }

    # Change group
    exec { "FpmGroupChange" :
        command => "sed -i 's/group = www-data/group = vagrant/' /etc/php5/fpm/pool.d/www.conf",
        onlyif  => "grep -c 'group = www-data' /etc/php5/fpm/pool.d/www.conf",
        require => Package["php5-fpm"],
        notify  => Service["php5-fpm"],
    }


    php::ini { 'fpm' : }
}
