define mysql::import-data {
    exec { "install db" :
        command => "/bin/zcat /vagrant/${params::sqldump} | /usr/bin/mysql -u${params::dbuser} -p${params::dbpass} ${params::dbname}",
        onlyif => "test `/usr/bin/mysql -sN -uroot -e \"select count(*) from information_schema.tables where table_schema = \\\"${params::dbname}\\\"\"` -eq 0",
        require => Exec["create-db"],
    }
}
