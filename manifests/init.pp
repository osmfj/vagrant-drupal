import 'repo'
import 'osm_drupal'
import 'osm_nginx'
import 'osm_mysql'

stage { 'pkg' : before => Stage['main'] }
stage { 'pre' : before => Stage['pkg'] }

class my_repo inherits repo {
#  apt::conf { 'apt-cacher':
#      content => 'Acquire::http::Proxy "http://192.168.123.1:3142";',
#      ensure => present,
#  }
}

node default {
  class { 'my_repo': stage => pre }
  class { 'osm_drupal': }
  class { 'osm_nginx': }
  class { 'osm_mysql': }
}
