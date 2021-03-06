class osm_drupal ($version = "7.32", $dest = "/opt/drupal7") {

  $packages = ["php5-cli", "php5-gd", "php5-curl", "php5-mcrypt"]

  package {
    $packages:
     ensure  => "installed",
     require => Exec['apt-get_update']
  }

define drush_add ($target = $title){
  exec { "install-drush-${target}":
    cwd => "${osm_drupal::dest}/sites/all/modules",
    command => "/bin/tar xvzf /vagrant/files/drupal/modules/${target}.tar.gz",
    creates => "${osm_drupal::dest}/sites/all/modules/drush",
    require => File["${osm_drupal::dest}/sites/all/modules"],
    before => File["link-drush-bin"]
  }

  file { "/usr/local/bin/drush":
    ensure => "${osm_drupal::dest}/sites/all/modules/drush/drush",
    alias  => "link-drush-bin",
  }

  file {"${osm_drupal::dest}/sites/all/modules/drush/lib":
    ensure => directory,
    require => Exec["install-drush-${target}"],
    before => Exec["install_drush_lib_Console_Table"]
  }

  exec {"install_drush_lib_Console_Table":
    cwd => "${osm_drupal::dest}/sites/all/modules/drush/lib/",
    subscribe => File["/usr/local/bin/drush"],
    command => "/bin/tar xvzf /vagrant/files/drupal/Console_Table-*.tgz",
    creates => "${osm_drupal::dest}/sites/all/modules/drush/lib/Console-Table",
  }

}

define module_add ($moduleName = $title ) {
  exec { "install_module_${moduleName}":
    cwd => "${osm_drupal::dest}/sites/all/modules",
    command => "/bin/tar xzvf /vagrant/files/drupal/modules/${moduleName}-*.tar.gz",
    creates => "${osm_drupal::dest}/sites/all/modules/${moduleName}",
    subscribe => Exec["untar-drupal-dist"],
    require => File["${osm_drupal::dest}/sites/all/modules"],
    refreshonly => true,
  }
  file { "${osm_drupal::dest}/sites/all/modules/${moduleName}":
    require => Exec["install_module_${moduleName}"]
  }
}

define library_add ($libName = $title ) {
  exec { "install_library_${libName}":
    cwd => "${osm_drupal::dest}/sites/all/libraries",
    command => "/bin/tar xzvf /vagrant/files/drupal/libraries/${libName}-*.tar.gz",
    creates => "${osm_drupal::dest}/sites/all/libraries/${libName}",
    subscribe => File["${osm_drupal::dest}/sites/all/libraries"],
    refreshonly => true,
  }
  file { "${osm_drupal::dest}/sites/all/libraries/${libName}":
    require => Exec["install_library_${libName}"]
  }
}

define theme_add ($themeName = $title ) {
  exec { "install_module_${themeName}":
    cwd => "${osm_drupal::dest}/sites/all/themes",
    command => "/bin/tar xzvf /vagrant/files/drupal/themes/${themeName}-*.tar.gz",
    creates => "${osm_drupal::dest}/sites/all/themes/${themeName}",
    subscribe => Exec["untar-drupal-dist"],
    require => File["${osm_drupal::dest}/sites/all/themes"],
    refreshonly => true,
  }
  file { "${osm_drupal::dest}/sites/all/themes/${themeName}":
    require => Exec["install_module_${themeName}"]
  }
}
  file {"${osm_drupal::dest}/sites/all/modules":
    ensure => directory,
    subscribe => Exec["untar-drupal-dist"]
  }

  file {"${osm_drupal::dest}/sites/all/themes":
    ensure => directory,
    subscribe => Exec["untar-drupal-dist"]
  }

  file {"${osm_drupal::dest}/sites/all/libraries":
    ensure => directory,
    subscribe => Exec["untar-drupal-dist"]
  }

  file { "/opt/drupal-$version.tar.gz":
    source => "/vagrant/files/drupal/drupal-$version.tar.gz",
    alias  => "drupal-dist-tgz",
    before => Exec["untar-drupal-dist"]
  }

  file { "${osm_drupal::dest}/sites/default":
    ensure => directory,
    subscribe => Exec["untar-drupal-dist"]
  }

  $workdirs = ["${osm_drupal::dest}/sites/default/files",
               "${osm_drupal::dest}/sites/default/files/languages",
               "${osm_drupal::dest}/sites/default/files/picutures",
               "${osm_drupal::dest}/cache",
               "${osm_drupal::dest}/cache/normal"]
  file { $workdirs:
    ensure => directory,
    owner => www-data,
    group => www-data,
    mode => 755,
    subscribe => File["${osm_drupal::dest}/sites/default"]
  }

  define add_config ($conffile = $title) {
    file {"${osm_drupal::dest}/sites/default/${conffile}":
      ensure => file,
      source => "/vagrant/files/${conffile}",
      subscribe => File["${osm_drupal::dest}/sites/default"]
    }
  }

  add_config{"settings.php":}
  add_config{"dbconfig.php":}
  add_config{"baseurl.php":}

  exec { "untar-drupal-$version":
        cwd       => "/opt",
        command   => "/bin/tar xf drupal-$version.tar.gz",
        creates   => "/opt/drupal-$version",
        alias     => "untar-drupal-dist",
        subscribe => File["drupal-dist-tgz"]
  }

  file { "make-drupal-link":
    path   => $osm_drupal::dest,
    ensure => link,
    target => "/opt/drupal-$version",
    subscribe => Exec["untar-drupal-dist"]
    }

  define hotfix ($patchName = $title, $type='modules', $target) {
    exec {"drupal-hostfix-${patchName}":
      cwd       => "${osm_drupal::dest}/sites/all/${type}/${target}",
      command   => "/usr/bin/patch -p1 -N -s -i /vagrant/files/${patchName}",
      onlyif    => "/usr/bin/patch -p1 -N -i /vagrant/files/${patchName} --dry-run",
      subscribe => File["${osm_drupal::dest}/sites/all/${type}/${target}"]
    }
  }
}

