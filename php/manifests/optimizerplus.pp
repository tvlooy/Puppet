define php::optimizerplus {
    $packages = [ "php5-dev", "php-pear" ]

    package { $packages :
        ensure => present,
    }

    exec { 'remove-apc' :
        command => "php5dismod apc",
        onlyif  => "test -f /etc/php5/conf.d/20-apc.ini",
    }

    exec { 'pecl-optimizerplus' :
        command => "pecl install ZendOptimizerPlus-beta",
        require => [
            Exec['remove-apc'],
            Package[$packages],
        ],
    }

    file { "/etc/php5/mods-available/optimizerplus.ini" :
        ensure  => present,
        content => template("php/optimizerplus.ini.erb"),
        require => Exec["pecl-optimizerplus"],
    }

    exec { 'enable-optimizerplus' :
       command => "php5enmod optimizerplus",
       require => File["/etc/php5/mods-available/optimizerplus.ini"],
       notify  => Service[$params::php_server],
    }
}