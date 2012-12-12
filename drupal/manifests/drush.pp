class drupal::drush {
    file { "drush-install.sh":
        path => "/tmp/drush-install.sh",
        source => "puppet:///modules/drupal/drush-install.sh",
        ensure => file,
        mode => 0644,
        owner => vagrant,
        group => vagrant,
    }
    exec { "install drush" :
        require => File["drush-install.sh"],
        path => "/bin:/usr/bin",
        command => "sudo sh /tmp/drush-install.sh",
        unless => "/bin/which drush",
    }
}
