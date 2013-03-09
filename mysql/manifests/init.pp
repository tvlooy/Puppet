class mysql {
    package { "mysql-server" :
        ensure => present,
    }

    service { "mysql" :
        ensure => running,
        require => Package["mysql-server"],
    }

    exec { 'create-db':
        unless => "/usr/bin/mysql -u${params::dbuser} -p${params::dbpass} ${params::dbname}",
        command => "/usr/bin/mysql -e \"create database ${params::dbname}; grant all on ${params::dbname}.* to ${params::dbuser}@localhost identified by '${params::dbpass}';\"",
        require => Service["mysql"],
    }

    php::mod { 'php5-mysql' : }
    php::mod { 'php-mdb2-driver-mysql' : }
}
