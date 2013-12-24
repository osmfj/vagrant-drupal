import 'repo'
import 'osm_drupal'
import 'osm_nginx'
import 'osm_mysql'
import 'php5-fpm'
import 'osm_drupal_modules'

class my_repo inherits repo {
  ## Use apt-cacher package cache on host
  #  apt::conf { 'apt-cacher': ensure => present,
  #      content => 'Acquire::http::Proxy "http://192.168.123.1:3142";'}

}

node default {
  class { 'my_repo':}
  class { 'osm_drupal': version  => '7.24', dest => '/opt/drupal7'}
  class { 'osm_drupal_modules':}
  class { 'osm_nginx':}
  class { 'osm_mysql': workuser => 'vagrant', database => 'drupal7',
                       username => 'drupal7', password => 'drupal7' }
  class { 'php5-fpm':}
}
