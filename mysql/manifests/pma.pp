define mysql::pma {
    package { "phpmyadmin" :
        ensure  => present,
        require => Package['php5-cli'],
    }

    case $name {
        apache2: {
            # Enable PMA at /phpmyadmin
            exec { "enable-pma" :
                command => "echo 'Include /etc/phpmyadmin/apache.conf' >> /etc/apache2/apache2.conf",
                unless => "/bin/grep -c 'Include /etc/phpmyadmin/apache.conf' /etc/apache2/apache2.conf",
                require => [
                    Package["phpmyadmin"],
                    Package["apache2"],
                ],
                notify  => Service["apache2"],
            }
        }
        default: {
            info("No PMA support for this http server yet")
        }
    }
}
