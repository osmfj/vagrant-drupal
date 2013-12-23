Exec { path => [ "/bin/", "/sbin/" , "/usr/bin/", "/usr/sbin/" ] }

stage { 'pkg' : before => Stage['main'] }
stage { 'pre' : before => Stage['pkg'] }

define drupal_drush_add ($target = $title){
  exec { "install-drush-${target}":
    cwd => "/opt/drupal7/sites/all/modules",
    command => "/bin/tar xvzf /vagrant/files/drupal/modules/${target}.tar.gz",
    creates => "/opt/drupal7/sites/all/modules/${target}",
    require => File["/opt/drupal7/sites/all/modules"],
    before => File["link-drush-bin"]
  }

  file { "/usr/local/bin/drush":
    ensure => "/opt/drupal7/sites/all/modules/${target}/drush",
    alias  => "link-drush-bin",
  }
}

define drupal_module_add ($moduleName = $title ) {
  exec { "install_module_${moduleName}":
    cwd => "/opt/drupal7/sites/all/modules",
    command => "tar xzvf /vagrant/files/drupal/modules/${moduleName}-*.tar.gz",
    creates => "/opt/drupal7/sites/all/modules/${moduleName}",
    subscribe => Exec["untar-drupal-dist"],
    require => File["/opt/drupal7/sites/all/modules"],
    refreshonly => true,
  }
}

define drupal_library_add ($libName = $title ) {
  exec { "install_library_${libName}":
    cwd => "/opt/drupal7/sites/all/libraries",
    command => "tar xzvf /vagrant/files/drupal/libraries/${libName}.tar.gz",
    creates => "/opt/drupal7/sites/all/libraries/${libName}",
    subscribe => File["/opt/drupal7/sites/all/libraries"],
    refreshonly => true,
  }
}

define drupal_theme_add ($themeName = $title ) {
  exec { "install_module_${themeName}":
    cwd => "/opt/drupal7/sites/all/themes",
    command => "tar xzvf /vagrant/files/drupal/themes/${themeName}-*.tar.gz",
    creates => "/opt/drupal7/sites/all/themes/${themeName}",
    subscribe => Exec["untar-drupal-dist"],
    require => File["/opt/drupal7/sites/all/themes"],
    refreshonly => true,
  }
}

define mysql_database_restore ($dataName = $title, $dbname ) {
  exec { "restore-mysql-database-${dataName}":
    cwd => "/home/vagrant",
    command => "mysql ${dbname} < /vagrant/files/${dataName}.sql",
    subscribe => File["/home/vagrant/.my.cnf"],
    refreshonly => true,
  }
}

class repo {
  file {
      '/home/vagrant/.gnupg/':
          ensure => "directory",
          owner  => "vagrant",
          group  => "vagrant",
          mode   => 700
      }
  include apt
  
#  apt::conf {
#    'apt-cacher':
#      content => 'Acquire::http::Proxy "http://192.168.123.1:3142";',
#	ensure => present,
 #}

  apt::ppa {
    'miurahr':
      ensure   => present,
      key      => 'FFB4B2A2',
      ppa      => 'openresty'
  }
  apt::sources_list {"groonga":
      ensure  => present,
      content => 'deb http://packages.groonga.org/ubuntu/ precise universe',
  }

  apt::key {"45499429":
      content  => "-----BEGIN PGP PUBLIC KEY BLOCK-----
Version: GnuPG v1.4.12 (GNU/Linux)

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
09GjfEljeEnXotmlXjJTZPLg
=r2Wo
-----END PGP PUBLIC KEY BLOCK-----",
  }

}

class osm_nginx {
    file {
      '/etc/nginx/sites-available/drupal':
        ensure => file,
        owner => root,
        group => root,
        subscribe => Exec["untar-drupal-dist"],
        source => '/vagrant/files/drupal-nginx.conf';
      '/etc/nginx/sites-enabled/drupal':
        ensure => 'link',
        require => Service["php5-fpm"],
        notify  => Service["nginx"], 
        target => '/etc/nginx/sites-available/drupal';
    }

  service {
    "nginx":
      name  => nginx,
      ensure => running,
      subscribe => File['/etc/nginx/sites-enabled/drupal'],
      enable => true
  }
}

class osm_drupal {

  $version = "7.24"

  $dependency = [
    "php5-fpm","php5-gd","php5-mysql","exim4-daemon-light",
    "php5-dev","mysql-server-mroonga","nginx"]

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

  file {"/opt/drupal7/sites/all/modules":
    ensure => directory,
    subscribe => Exec["untar-drupal-dist"]
  }

  file {"/opt/drupal7/sites/all/themes":
    ensure => directory,
    subscribe => Exec["untar-drupal-dist"]
  }

  file {"/opt/drupal7/sites/all/libraries":
    ensure => directory,
    subscribe => Exec["untar-drupal-dist"]
  }

  file { "/opt/drupal-$version.tar.gz":
    source => "/vagrant/files/drupal/drupal-$version.tar.gz",
    alias  => "drupal-dist-tgz",
    before => Exec["untar-drupal-dist"]
  }

  exec { "tar xf drupal-$version.tar.gz":
        cwd       => "/opt",
        creates   => "/opt/drupal-7.24",
        alias     => "untar-drupal-dist",
        subscribe => File["drupal-dist-tgz"]
  }

  file { '/opt/drupal7':
    ensure => link,
    target => "/opt/drupal-$version",
    subscribe => Exec["untar-drupal-dist"]
    }

  drupal_drush_add{"drush-6.2.0": }

# basic modules
  drupal_module_add{"libraries": }
  drupal_module_add{"boost": }
  drupal_module_add{"cck": }
  drupal_module_add{"ctools": }
  drupal_module_add{"views": }
  drupal_module_add{"date": }
  drupal_module_add{"entity": }
  drupal_module_add{"i18n": }
  drupal_module_add{"jquery_update": }
  drupal_module_add{"token": }
  drupal_module_add{"variable": }

# administration/antispam
  drupal_module_add{"admin_menu": }
  drupal_module_add{"antispam": }
  drupal_module_add{"captcha": }
  drupal_module_add{"hidden_captcha": }
  drupal_module_add{"recaptcha": }
  drupal_module_add{"google_analytics": }
  drupal_module_add{"pathauto": }

# UI improvement
  drupal_module_add{"ckeditor": }
  drupal_module_add{"dhtml_menu": }
  drupal_module_add{"diff": }
  drupal_module_add{"message": }

# Q&A forum
  drupal_module_add{"rate": }
  drupal_module_add{"votingapi": }

# GEO
  drupal_module_add{"geofield": }
  drupal_module_add{"geophp": }
  drupal_module_add{"leaflet": }
  drupal_module_add{"openlayers": }
  drupal_module_add{"proj4js": }
  drupal_module_add{"panels": }

# SignOn
  drupal_module_add{"fbconnect": }
  drupal_module_add{"oauth": }
  drupal_module_add{"httprl": }
  drupal_module_add{"profile2": }
  drupal_module_add{"twitter": }


# Search development
  drupal_module_add{"search_api": }
  drupal_module_add{"site_map": }

# library
  drupal_library_add{"leaflet-0.7.1":}
  drupal_library_add{"facebook-php-sdk-3.2.3":}

# themes
  drupal_theme_add{"touch":}
  drupal_theme_add{"bootstrap":}
}

class osm_mysql {
  include '::mysql::server'

#  mysql_user { 'drupal7@localhost':
#    ensure                   => 'present',
#    password_hash            => '*625404D288361E8652C884A0737B363B650A77CE',
#  }
#  mysql_database { 'drupal7':
#    ensure  => 'present',
#    charset => 'utf8',
#    collate => 'utf8_general_ci',
#  }
#  mysql_grant { 'drupal7@localhost/drupal7.*':
#    ensure     => 'present',
#    options    => ['GRANT'],
#    privileges => ['SELECT', 'INSERT', 'UPDATE', 'DELETE', 'CREATE', 'DROP',
#                   'INDEX', 'ALTER', 'LOCK TABLES', 'CREATE TEMPORARY TABLES'],
#    table      => 'drupal7.*',
#    user       => 'drupal7@localhost',
#  }
  mysql::db { 'drupal7':
      user     => 'drupal7',
      password => 'drupal7',
      host     => 'localhost',
      grant    => ['SELECT', 'INSERT', 'UPDATE', 'DELETE', 'CREATE', 'DROP',
                   'INDEX', 'ALTER', 'LOCK TABLES', 'CREATE TEMPORARY TABLES'],
  }

  file { "/home/vagrant/.my.cnf":
    ensure  => present,
    require => Mysql_database['drupal7'],
    content => '
[client]
host     = localhost
user     = drupal7
password = drupal7
socket   = /var/run/mysqld/mysqld.sock
',
  }
  mysql_database_restore {"drupal_data":
    dbname => 'drupal7',
  }
}

node default {
  class { 'repo': stage => pre }
  class { 'osm_drupal': }
  class { 'osm_nginx': }
  class { 'osm_mysql': }
}
