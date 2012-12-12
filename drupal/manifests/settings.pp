class drupal::settings {
    file { '/vagrant/htdocs/sites/default/files' :
        ensure => directory,
        owner  => 'vagrant',
        group  => 'vagrant',
        mode   => '0775',
    }

    file { '/vagrant/htdocs/cache' :
        ensure => directory,
        owner  => 'vagrant',
        group  => 'vagrant',
        mode   => '0775',
    }

    file { '/vagrant/htdocs/sites/default/settings.php' :
        ensure => present,
        owner  => 'vagrant',
        group  => 'vagrant',
        source => '/vagrant/htdocs/sites/default/default.settings.php',
    }

    exec { 'customize settings' :
        command => "/bin/cat <<-EOF >> /vagrant/htdocs/sites/default/settings.php
						\\\$databases = array (
							'default' =>
								array (
									'default' =>
										array (
											'database' => '${params::dbname}',
											'username' => '${params::dbuser}',
											'password' => '${params::dbpass}',
											'host' => '127.0.0.1',
											'port' => '',
											'driver' => 'mysql',
											'prefix' => '',
										),
								),
						);
						\\\$conf['cron_safe_threshold'] = '0';
						\\\$conf['error_level'] = 1;
						\\\$conf['preprocess_css'] = 0;
						\\\$conf['preprocess_js'] = 0;
						EOF",
        require => File['/vagrant/htdocs/sites/default/settings.php'],
        unless => "/bin/grep -c ${params::dbname} /vagrant/htdocs/sites/default/settings.php",
    }
}
