class default_lamp {
    class { 'tools' : }

    class { 'apache2' : }
    apache2::vhost { $params::host :
        documentroot => $params::documentroot,
        overrides    => 'All',
        aliases      => "www.$params::documentroot",
    }
    apache2::mod { 'rewrite' : }
    apache2::php { $params::php_version : }

    class { 'mysql' : }
    mysql::import-data { $params::sqldump : }

    class { 'php': }
    php::mod { 'php5-xdebug' : }
}
