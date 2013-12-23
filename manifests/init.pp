import 'repo'
import 'osm_drupal'
import 'osm_nginx'
import 'osm_mysql'

class my_repo inherits repo {

## If you want to use apt-cacher package cache on host for vagrant performance,
## uncomment follows:

#  apt::conf { 'apt-cacher':
#      content => 'Acquire::http::Proxy "http://192.168.123.1:3142";',
#      ensure => present,
#  }

####

}

node default {
  class { 'my_repo':}
  class { 'osm_drupal':
    version  => '7.24',
    dest     => '/opt/drupal7'
  }
  class { 'osm_nginx':}
  class { 'osm_mysql':
    workuser => 'vagrant',
    database => 'drupal7',
    username => 'drupal7',
    password => 'drupal7'
  }
}
