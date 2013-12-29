class php5-fpm {

  $packages = ["php5-fpm"]

  package {
    $packages:
     ensure  => "installed",
     require => Exec['apt-get_update']
  }

  service {
    "php5-fpm":
      name      => php5-fpm,
      ensure    => running,
      require   => Package["php5-fpm"],
      enable    => true,
  }

}
