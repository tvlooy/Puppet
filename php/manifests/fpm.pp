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

    php::ini { 'fpm' : }
}
