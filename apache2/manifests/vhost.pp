define apache2::vhost (
    $documentroot = '/vagrant',
    $aliases = '',
    $overrides = 'None',
    $port = '80',
    $log_level = 'warn',
    $prio = '00',
    $vhostconf = 'apache2/vhost.conf.erb'
) {
    file { "/etc/apache2/sites-available/${prio}-${name}.conf" :
        ensure => present,
        content => template("${vhostconf}"),
        require => Package["apache2"],
    }

    exec { "a2ensite ${prio}-${name}.conf" :
        require => File["/etc/apache2/sites-available/${prio}-${name}.conf"],
        notify  => Service["apache2"],
    }
}