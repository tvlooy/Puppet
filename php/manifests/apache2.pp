define php::apache2 {
    case $name {
        5.3: {
            package { "mod-php5" :
                name    => "libapache2-mod-php5",
                ensure  => present,
                notify  => Service["apache2"],
            }
        }
        5.4: {
            if ! defined(Class["dotdeb"]) {
                class { 'dotdeb' : }
            }

            package { "mod-php5" :
                name    => "libapache2-mod-php5",
                ensure  => present,
                require => [
                    Class["dotdeb"],
                    Package["apache2"],
                ],
                notify  => Service["apache2"],
            }
        }
        default: {
            fail("This PHP version is not supported")
        }
    }

    php::ini { 'apache2' : }
}
