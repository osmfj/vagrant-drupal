class osm_mysql (
  $workuser = 'vagrant',
  $database = 'drupal7',
  $username = 'drupal7',
  $password = 'drupal7'
){

  $dependency = ["php5-mysql", "mysql-server-mroonga"]

  class { '::mysql::server':
    require => Exec['apt-get_update'],
    override_options => {
      'mysqld' => {
        'mroonga_default_parser' => 'TokenMecab'
      }
    }
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

  file { '/vagrant/files/drupal-data.sql':
  audit => mtime,
  notify => Exec['restore-drupal-data']
 }

  $mysql_command = "/usr/bin/mysql --user=${osm_mysql::username} --password=${osm_mysql::password} ${osm_mysql::database}"

  exec { "restore-drupal-data":
      cwd      => "/home/${osm_mysql::workuser}",
      command  => "/bin/bash -c \"$osm_mysql::mysql_command < /vagrant/files/drupal-data.sql\"",
      subscribe => [Mysql_database["${osm_mysql::database}"], File["/home/vagrant/.my.cnf"]],
      refreshonly => true,
  }

  define mroonga-query ($tableName=$title) {
    exec {"alter-mroonga-${tableName}":
      cwd      => "/home/${osm_mysql::workuser}",
      command  => "/bin/echo \"ALTER TABLE ${tableName} ENGINE=mroonga COMMENT='engine \"innodb\"' DEFAULT CHARSET utf8;\" | ${osm_mysql::mysql_command} --force",
      unless => "/bin/echo 'SHOW CREATE TABLE ${tableName};' | ${osm_mysql::mysql_command} | grep -i -c 'mroonga'",
      require   => Package["mysql-server-mroonga"],
      subscribe => Exec["restore-drupal-data"],
    }
  }

  # mroonga-query {"field_data_body":}
  # mroonga-query {"field_data_comment":}
}
