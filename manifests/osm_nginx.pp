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
        require => Package["nginx"],
        subscribe => File["/etc/nginx/sites-available/drupal"],
        notify  => Service["nginx"], 
        target => '/etc/nginx/sites-available/drupal';
  }

  $packages = ["nginx"]

  package {
    $packages:
     ensure  => "installed",
     require => Exec['apt-get_update']
  }

  service {
    "nginx":
      name  => nginx,
      ensure => running,
      subscribe => File['/etc/nginx/sites-enabled/drupal'],
      enable => true
  }
}
