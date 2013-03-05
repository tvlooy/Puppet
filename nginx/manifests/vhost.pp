define nginx::vhost (
    $documentroot = '/vagrant',
    $aliases = '',
    $port = '80',
    $prio = '00',
    $vhostconf = 'nginx/vhost.conf.erb'
) {
    file { "/etc/nginx/sites-available/${prio}-${name}.conf" :
        ensure => present,
        content => template("${vhostconf}"),
        require => Package["nginx"],
    }

    file { "/etc/nginx/sites-enabled/${prio}-${name}.conf" :
       ensure => 'link',
       target => "/etc/nginx/sites-available/${prio}-${name}.conf",
       require => File["/etc/nginx/sites-available/${prio}-${name}.conf"],
       notify  => Service["nginx"],
    }
}