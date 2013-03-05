define apache2::php {
    case $name {
        5.3: {
            package { "libapache2-mod-php5" :
                ensure  => present,
                notify  => Service["apache2"],
            }
        }
        5.4: {
            class { 'dotdeb' : }
            package { "libapache2-mod-php5" :
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
}
