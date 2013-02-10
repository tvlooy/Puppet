class lamp {
    class { 'lamp::setup' : }
    class { 'lamp::sql' : }
    class { 'lamp::web' : }
    class { 'postfix' :
        require => Class["lamp::web"],
    }
}
