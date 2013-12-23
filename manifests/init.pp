import 'repo'
import 'osm_drupal'
import 'osm_nginx'
import 'osm_mysql'
import 'osm_drupal_modules'

class my_repo inherits repo {

## If you want to use apt-cacher package cache on host for vagrant performance,
## uncomment follows:

#  apt::conf { 'apt-cacher':
#      content => 'Acquire::http::Proxy "http://192.168.123.1:3142";',
#      ensure => present,
#  }

####

}

class osm_package {
  $dependency = [
    "php5-fpm","php5-gd"]

  package {
    $dependency:
     ensure  => "installed",
  }

  service {
    "php5-fpm":
      name      => php5-fpm,
      ensure    => running,
      require   => Package["php5-fpm"],
      enable    => true
  }
}

node default {
  class { 'my_repo':}
  class { 'osm_package':}
  class { 'osm_drupal':
    version  => '7.24',
    dest     => '/opt/drupal7'
  }
  class { 'osm_drupal_modules':}
  class { 'osm_nginx':}
  class { 'osm_mysql':
    workuser => 'vagrant',
    database => 'drupal7',
    username => 'drupal7',
    password => 'drupal7'
  }
}
