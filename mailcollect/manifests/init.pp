class mailcollect {
    $packages = [ "postfix", "postfix-pcre", "roundcube-core", "dovecot-imapd" ]

    package { $packages :
        ensure => present,
        require => [
            Package["mysql-server"],
            Package['php5-cli'],
        ],
    }

    service { "postfix" :
        ensure => running,
        require => Package[$packages],
    }

    service { "dovecot" :
        ensure => running,
        require => Package[$packages],
    }

    augeas { "postfix" :
        context => "/files/etc/postfix/main.cf",
        changes => [
            'clear virtual_alias_domains',
            'set virtual_alias_maps pcre:/etc/postfix/virtual_forwardings.pcre',
            'set virtual_mailbox_domains pcre:/etc/postfix/virtual_domains.pcre',
            'set home_mailbox Maildir/',
        ],
        require => Package[$packages],
        notify  => Service["postfix"],
    }

    exec { "postfix-virtual-config" :
        command => 'echo "/@.*/ vagrant" > /etc/postfix/virtual_forwardings.pcre ; echo "/^.*/ OK" > /etc/postfix/virtual_domains.pcre',
        require => Package[$packages],
        notify  => Service["postfix"],
    }

    case $params::http_server {
        apache2: {
            # Enable roundcube at /roundcube
            exec { "enable-roundcube" :
                command => 'sed -i "s/#    Alias \/roundcube/Alias \/roundcube/" /etc/apache2/conf.d/roundcube',
                require => [
                    Package[$packages],
                    Package["apache2"]
                ],
                notify  => Service["apache2"],
            }
        }
        default: {
            info("No roundcube support for this http server yet")
        }
    }

    # Webserver runs as user vagrant
    exec { "roundcube-permissions" :
        command => 'chgrp vagrant /etc/roundcube/main.inc.php ; chgrp vagrant /etc/roundcube/debian-db.php',
        require => [
            Package[$packages],
            Package["apache2"]
        ],
        notify  => Service[$params::http_server],
    }

    # Roundcube config changes
    exec { 'roundcube-config-host' :
        command => 'sed -i "s/\'default_host\'] = \'\'/\'default_host\'] = \'localhost\'/" /etc/roundcube/main.inc.php',
        require => Package[$packages],
    }
    exec { 'roundcube-config-from' :
        command => 'sed -i "s/\'from\', \'date\'/\'from\', \'to\', \'date\'/" /etc/roundcube/main.inc.php',
        require => Package[$packages],
    }
    exec { 'roundcube-config-images' :
        command => 'sed -i "s/\'show_images\'] = 0/\'show_images\'] = 2/" /etc/roundcube/main.inc.php',
        require => Package[$packages],
    }
    exec { 'roundcube-config-folders' :
        command => 'sed -i "s/\'create_default_folders\'] = FALSE/\'create_default_folders\'] = TRUE/" /etc/roundcube/main.inc.php',
        require => Package[$packages],
    }
    exec { 'roundcube-default-user' :
        command => 'sudo sed -i "s#=> \'rcmloginuser#=> \'rcmdloginuser\', \'value\' => \'vagrant#" /var/lib/roundcube/program/include/rcube_template.php',
        require => Package[$packages],
    }
    exec { 'roundcube-default-pass' :
        command => 'sudo sed -i "s#=> \'rcmloginpwd#=> \'rcmdloginpwd\', \'value\' => \'vagrant#" /var/lib/roundcube/program/include/rcube_template.php',
        require => Package[$packages],
    }

    # Setup maildir
    exec { 'vagrant-maildir' :
        command => 'mkdir -p /home/vagrant/Maildir/{cur,new,tmp}',
        require => Package[$packages],
    }
    exec { 'maildir-permissions' :
        command => 'chown -R vagrant:vagrant /home/vagrant/Maildir',
        require => [
            Package[$packages],
            Exec["vagrant-maildir"],
        ],
    }
}
