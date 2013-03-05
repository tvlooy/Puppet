class tools {
    $packages = [ "htop", "strace", "sysstat", "git" ]

    package { $packages :
        ensure => present,
    }
}
