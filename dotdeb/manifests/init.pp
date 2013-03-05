class dotdeb {
    file { '/etc/apt/sources.list.d/dotdeb.list':
        ensure => 'present',
        owner => 'root',
        group => 'root',
        mode => '0600',
        content => template('dotdeb/dotdeb.list.erb')
    }

    exec { 'dotdeb-apt-key':
        command => "/usr/bin/wget -q -O - http://www.dotdeb.org/dotdeb.gpg | sudo apt-key add -",
        unless => 'apt-key list | grep dotdeb',
        require => File['/etc/apt/sources.list.d/dotdeb.list'],
        notify => Exec['update-apt'],
    }

    exec { 'update-apt':
        command => '/usr/bin/apt-get update',
        require => Exec['dotdeb-apt-key'],
        refreshonly => true,
    }
}
