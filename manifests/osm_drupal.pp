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
    command => "/bin/tar xzvf /vagrant/files/drupal/modules/${moduleName}-*.tar.gz",
    creates => "/opt/drupal7/sites/all/modules/${moduleName}",
    subscribe => Exec["untar-drupal-dist"],
    require => File["/opt/drupal7/sites/all/modules"],
    refreshonly => true,
  }
}

define drupal_library_add ($libName = $title ) {
  exec { "install_library_${libName}":
    cwd => "/opt/drupal7/sites/all/libraries",
    command => "/bin/tar xzvf /vagrant/files/drupal/libraries/${libName}.tar.gz",
    creates => "/opt/drupal7/sites/all/libraries/${libName}",
    subscribe => File["/opt/drupal7/sites/all/libraries"],
    refreshonly => true,
  }
}

define drupal_theme_add ($themeName = $title ) {
  exec { "install_module_${themeName}":
    cwd => "/opt/drupal7/sites/all/themes",
    command => "/bin/tar xzvf /vagrant/files/drupal/themes/${themeName}-*.tar.gz",
    creates => "/opt/drupal7/sites/all/themes/${themeName}",
    subscribe => Exec["untar-drupal-dist"],
    require => File["/opt/drupal7/sites/all/themes"],
    refreshonly => true,
  }
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

  exec { "untar-drupal-$version":
        cwd       => "/opt",
        command   => "/bin/tar xf drupal-$version.tar.gz",
        creates   => "/opt/drupal-$version",
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

