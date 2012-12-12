class mysql::dbimport {
    file { "db-import.sh":
        path => "/tmp/db-import.sh",
        source => "puppet:///modules/mysql/db-import.sh",
        ensure => file,
        mode => 0644,
        owner => vagrant,
        group => vagrant,
    }
    exec { "install db" :
        require => File["db-import.sh"],
        path => "/bin:/usr/bin",
        command => "sudo sh /tmp/db-import.sh ${params::dbuser} ${params::dbpass} ${params::dbname}",
    }
}
