class osm_mysql (
  $workuser = 'vagrant',
  $database = 'drupal7',
  $username = 'drupal7',
  $password = 'drupal7'
){
  class { '::mysql::server':
    require => Exec['apt-get_update']
  }
  class { '::mysql::client':
    require => Exec['apt-get_update']
  }

  define mysql_database_restore ($dataName = $title,
                                 $dbname, $dbuser, $dbpass, $trigger ) {
    exec { "restore-mysql-database-${dataName}":
      cwd      => "/home/${osm_mysql::workuser}",
      user     => $osm_mysql::workuser,
      group    => $osm_mysql::workuser,
      command  => "/usr/bin/mysql --user=${dbuser} --password=${dbpass} ${dbname} < /vagrant/files/${dataName}.sql",
      subscribe => $trigger,
      refreshonly => true,
    }
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
  mysql_database_restore {"drupal_data":
    dbname  => $osm_mysql::database,
    dbuser  => $osm_mysql::username,
    dbpass  => $osm_mysql::password,
    trigger => File["/home/${osm_mysql::workuser}/.my.cnf"],
  }
}
