class php {
    case $params::php_version {
        5.3: {
            package { "php5-cli" :
                ensure  => present,
            }

            $apc = 'php-apc'
        }
        5.4: {
            if ! defined(Class["dotdeb"]) {
                class { 'dotdeb' : }
            }

            package { "php5-cli" :
                ensure  => present,
                require => Class["dotdeb"],
            }

            $apc = 'php5-apc'
        }
        default: {
            fail("This PHP version is not supported")
        }
    }

    php::mod { 'php5-gd' : }
    php::mod { 'php5-curl' : }
    php::mod { $apc : }

    php::ini { 'cli' : }
}
