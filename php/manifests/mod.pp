define php::mod {
    package { $name :
        ensure  => present,
        notify  => Service[$params::php_server],
        require => Package['php5-cli'],
    }
}