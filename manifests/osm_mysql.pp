class osm_mysql {
  include '::mysql::server'

define mysql_database_restore ($dataName = $title, $dbname, $trigger ) {
  exec { "restore-mysql-database-${dataName}":
    cwd => "/home/vagrant",
    command => "/usr/bin/mysql ${dbname} < /vagrant/files/${dataName}.sql",
    subscribe => $trigger,
    refreshonly => true,
  }
}

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
    dbname    => 'drupal7',
    trigger => File["/home/vagrant/.my.cnf"],
  }
}
