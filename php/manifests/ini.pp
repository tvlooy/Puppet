define php::ini {
    $timezone = "Europe/Brussels"

    $php_changes = [
        'set PHP/error_reporting "E_ALL | E_STRICT"',
        'set PHP/display_errors On',
        'set PHP/display_startup_errors On',
        'set PHP/html_errors On',
        'set PHP/short_open_tag Off',
        "set Date/date.timezone ${timezone}",
        'set PHP/memory_limit 128M',
        'set PHP/post_max_size 128M',
        'set PHP/upload_max_filesize 120M',
    ]

    case $name {
        cli: {
            augeas { "php5-$name" :
                context => "/files/etc/php5/cli/php.ini",
                changes => $php_changes,
                require => Package["php5-cli"],
            }
        }
        apache2: {
            augeas { "php5-$name" :
                context => "/files/etc/php5/apache2/php.ini",
                changes => $php_changes,
                require => Package["mod-php5"],
                notify  => Service["apache2"],
            }
        }
        fpm: {
            augeas { "php5-$name" :
                context => "/files/etc/php5/fpm/php.ini",
                changes => $php_changes,
                require => Package["php5-fpm"],
                notify  => Service[$params::http_server],
            }
        }
        default: {
            fail("This SAPI is not supported")
        }
    }
}
