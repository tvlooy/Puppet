define mysql::import-data {
    file { "import-data.sh":
        path => "/tmp/import-data.sh",
        source => "puppet:///modules/mysql/import-data.sh",
        ensure => file,
        mode => 0644,
        owner => vagrant,
        group => vagrant,
    }

    exec { "install db" :
        path => "/bin:/usr/bin",
        command => "bash /tmp/import-data.sh ${params::dbuser} ${params::dbpass} ${params::dbname} ${params::sqldump}",
        require => [
            File["import-data.sh"],
            Service["mysql"],
        ],
    }
}
