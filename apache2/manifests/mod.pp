define apache2::mod {
    exec { "a2enmod $name" :
        require => Package["apache2"],
        notify  => Service["apache2"],
    }
}