class jetty-solr ($sitenames) {

  $packages = ["unzip", "openjdk-7-jdk","jetty","libjetty-extra"]

  package {
    $packages:
     ensure  => "installed",
     require => Exec['apt-get_update']
  }

  file {"/home/vagrant/solr-4.6.0":
    require => Exec["/home/vagrant/solr-4.6.0"]
  }

  exec {"/home/vagrant/solr-4.6.0":
    cwd     => "/home/vagrant",
    command => "/bin/tar xf /vagrant/files/solr-4.6.0.tgz",
    creates => "/home/vagrant/solr-4.6.0"
  }

  file {"/opt/solr":
    ensure => directory,
    before => Exec["unzip-solr-war"]
  }

  exec {"unzip-solr-war":
    cwd     => "/opt/solr",
    command => "/usr/bin/unzip /home/vagrant/solr-4.6.0/dist/solr-4.6.0.war",
    require => [File["/opt/solr", "/home/vagrant/solr-4.6.0"],Package["unzip"]],
    creates => ["/opt/solr/admin.html", "/opt/solr/META-INF",
                "/opt/solr/WEB-INF","/opt/solr/css","/opt/solr/js",
                "/opt/solr/img"]
  }

  file {"/usr/share/jetty/lib/ext":
    ensure => directory,
    require => Package["libjetty-extra"]
  }

  define locate_solr_jar ($jarName = $title) {
    file {"/usr/share/jetty/lib/ext/${jarName}":
      ensure  => present,
      source => "/home/vagrant/solr-4.6.0/example/lib/ext//${jarName}",
      require => File["/opt/solr"]
    }
  }

  locate_solr_jar{"jcl-over-slf4j-1.6.6.jar": }
  locate_solr_jar{"log4j-1.2.16.jar": }
  locate_solr_jar{"slf4j-log4j12-1.6.6.jar": }
  locate_solr_jar{"jul-to-slf4j-1.6.6.jar": }
  locate_solr_jar{"slf4j-api-1.6.6.jar": }

  file {"/usr/share/jetty/webapps":
    ensure => directory,
    require => Package["jetty"]
  }

  file {"/usr/share/jetty/webapps/solr":
    ensure => link,
    source => "/opt/solr",
    require => [Package["jetty"],File["/opt/solr","/usr/share/jetty/webapps"]]
  }

  file {"/etc/default/jetty":
    ensure  => present,
    content => template('/vagrant/templates/jetty.erb'),
    require => Package['jetty'],
    notify  => Service["jetty"]
  }

  service {"jetty":
    name   => jetty,
    ensure => running,
    subscribe => File["/etc/default/jetty"],
    enable => true,
  }

  file {"/opt/solr/solr.xml":
    ensure  => present,
    content => template('/vagrant/templates/solr_xml.erb'),
    require => File["/opt/solr"]
  }
}
