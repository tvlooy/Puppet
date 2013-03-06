class tools {
    $packages = [ "htop", "strace", "sysstat", "git", "nano" ]

    package { $packages :
        ensure => present,
    }
}
