class osm_mysql (
  $workuser = 'ubuntu',  #for aws,  pleaes change it for local vm to 'vagrant'
  $database = 'drupal7',
  $username = 'drupal7',
  $password = 'drupal7'
){

  $dependency = ["php5-mysql"]

  class { '::mysql::server':
    root_password => 'drupal7',
    require => Exec['apt-get_update']
  }
  class { '::mysql::client':
    require => Exec['apt-get_update']
  }
  package {
    $dependency:
     ensure  => "installed",
     require => Exec['apt-get_update'],
     notify  => Service['php5-fpm']
  }

  mysql::db { $osm_mysql::database:
      user     => $osm_mysql::username,
      password => $osm_mysql::password,
      host     => 'localhost',
      grant    => ['SELECT', 'INSERT', 'UPDATE', 'DELETE', 'CREATE', 'DROP',
                   'INDEX', 'ALTER', 'LOCK TABLES', 'CREATE TEMPORARY TABLES'],
  }

  file { "/home/${osm_mysql::workuser}/.my.cnf":
    ensure  => present,
    require => Mysql_database[$osm_mysql::database],
    content => "
[client]
host     = localhost
user     = $osm_mysql::username
password = $osm_mysql::password
socket   = /var/run/mysqld/mysqld.sock
",
  }

  file { '/vagrant/files/drupal-data.sql.bz2':
  audit => mtime,
  notify => Exec['restore-drupal-data']
 }

  $mysql_command = "/usr/bin/mysql --user=${osm_mysql::username} --password=${osm_mysql::password} ${osm_mysql::database}"

  exec { "restore-drupal-data":
      cwd      => "/home/${osm_mysql::workuser}",
      command  => "/bin/bash -c \"bzcat /vagrant/files/drupal-data.sql.bz2 | $osm_mysql::mysql_command\"",
      subscribe => [Mysql_database["${osm_mysql::database}"], File["/home/${osm_mysql::workuser}/.my.cnf"]],
      refreshonly => true,
  }
}
