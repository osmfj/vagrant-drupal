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

  package { "nginx": 
       ensure => latest,
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
