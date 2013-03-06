class default_lamp {
    class { 'tools' : }

    class { 'apache2' : }
    apache2::vhost { $params::host :
        documentroot => $params::documentroot,
        overrides    => 'All',
        aliases      => "www.$params::host",
    }
    apache2::mod { 'rewrite' : }

    class { 'mysql' : }
    mysql::import-data { $params::sqldump : }
    mysql::pma { $params::http_server : }

    class { 'php' : }
    php::apache2 { $params::php_version : }
    php::mod { 'php5-xdebug' : }

    class { 'mailcollect' : }
}
