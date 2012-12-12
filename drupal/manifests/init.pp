class drupal {
    class { 'drupal::drush' : }
    class { 'drupal::settings' : }
    class { 'drupal::dbimport' :
        require => Class["lamp::sql"]
    }
}
