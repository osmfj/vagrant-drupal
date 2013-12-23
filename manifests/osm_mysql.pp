class osm_mysql (
  $workuser = 'vagrant',
  $database = 'drupal7',
  $username = 'drupal7',
  $password = 'drupal7'
){

  $dependency = ["php5-mysql", "mysql-server-mroonga"]

  class { '::mysql::server':
    require => Exec['apt-get_update']
  }
  class { '::mysql::client':
    require => Exec['apt-get_update']
  }
  package {
    $dependency:
     ensure  => "installed",
     require => Exec['apt-get_update']
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

  file { '/vagrant/files/drupal-data.sql':
  audit => mtime,
  notify => Exec['restore-drupal-data']
 }

  exec { "restore-drupal-data":
      cwd      => "/home/${osm_mysql::workuser}",
      command  => "/bin/bash -c \"/usr/bin/mysql --user=${osm_mysql::username} --password=${osm_mysql::password} ${osm_mysql::database} < /vagrant/files/drupal-data.sql\"",
      subscribe => [Mysql_database["${osm_mysql::database}"], File["/home/vagrant/.my.cnf"]],
      refreshonly => true,
  }

}
