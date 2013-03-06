class default_lemp {
    class { 'tools' : }

    class { 'nginx' : }
    nginx::vhost { $params::host :
        documentroot => $params::documentroot,
        aliases      => "www.$params::host",
    }

    class { 'mysql' : }
    mysql::import-data { $params::sqldump : }

    class { 'php' : }
    php::fpm { $params::php_version : }
    php::mod { 'php5-xdebug' : }
}
