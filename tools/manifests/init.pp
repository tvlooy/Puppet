class tools {
    $packages = [ "htop", "strace", "sysstat", "git", "nano" ]

    package { $packages :
        ensure => present,
    }

    exec { 'default directory' :
        command => "echo 'cd /vagrant/htdocs' >> /home/vagrant/.bashrc",
    }
}
