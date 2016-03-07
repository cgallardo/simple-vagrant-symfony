Exec { path => ['/usr/local/bin', '/opt/local/bin', '/usr/bin', '/usr/sbin', '/bin', '/sbin'] }


class system-update {

  exec { 'apt-get update':
    command => 'apt-get update',
  }

  file { '/etc/environment':
    ensure => present,
  }

  file_line { 'update locales for environment':
    path  => '/etc/environment',
    line  => 'LC_ALL=C',
  }
}

class dev-packages {

  include gcc
  include wget

  $devPackages = [ "vim", "curl", "git", "rubygems", "openjdk-7-jdk", "libaugeas-ruby" ]
  package { $devPackages:
    ensure => "installed",
    require => Exec['apt-get update'],
  }

  exec { 'install phpunit':
    command => '/usr/bin/wget -O /usr/local/bin/phpunit https://phar.phpunit.de/phpunit.phar',
    creates => '/usr/local/bin/phpunit',
  }

  exec { 'pchmod phpunit':
    command => '/bin/chmod +x /usr/local/bin/phpunit',
    require => Exec['install phpunit'],
  }
}

class nginx-setup {

  include nginx

  package { "python-software-properties":
    ensure => present,
  }

  file { '/etc/nginx/sites-available/default':
    owner  => root,
    group  => root,
    ensure => file,
    mode   => 644,
    source => '/vagrant/files/nginx/default',
    require => Package["nginx"],
  }

  file { "/etc/nginx/sites-enabled/default":
    notify => Service["nginx"],
    ensure => link,
    target => "/etc/nginx/sites-available/default",
    require => Package["nginx"],
  }
}

class php-setup {

  $php = ["php5-fpm", "php5-cli", "php5-dev", "php5-gd", "php5-curl", "php-apc", "php5-mcrypt", "php5-xdebug", "php5-sqlite", "php5-mysql", "php5-memcache", "php5-intl", "php5-tidy", "php5-imap", "php5-imagick"]

  exec { 'add-apt-repository ppa:ondrej/php5':
    command => '/usr/bin/add-apt-repository ppa:ondrej/php5',
    require => Package["python-software-properties"],
  }

  exec { 'apt-get update for ondrej/php5':
    command => '/usr/bin/apt-get update',
    before => Package[$php],
    require => Exec['add-apt-repository ppa:ondrej/php5'],
  }

  package { $php:
    notify => Service['php5-fpm'],
    ensure => latest,
  }

  package { "apache2.2-bin":
    notify => Service['nginx'],
    ensure => purged,
    require => Package[$php],
  }

  package { "imagemagick":
    ensure => present,
    require => Package[$php],
  }

  package { "libmagickwand-dev":
    ensure => present,
    require => Package["imagemagick"],
  }

  package { "phpmyadmin":
    ensure => purged,
    require => Package[$php],
  }

  exec { 'pecl install mongo':
    notify => Service["php5-fpm"],
    command => '/usr/bin/pecl install --force mongo',
    logoutput => "on_failure",
    require => Package[$php],
    before => [File['/etc/php5/cli/php.ini'], File['/etc/php5/fpm/php.ini'], File['/etc/php5/fpm/php-fpm.conf'], File['/etc/php5/fpm/pool.d/www.conf']],
    unless => "/usr/bin/php -m | grep mongo",
  }

  file { '/etc/php5/cli/php.ini':
    owner  => root,
    group  => root,
    ensure => file,
    mode   => 644,
    source => '/vagrant/files/php/cli/php.ini',
    require => Package[$php],
  }

  file { '/etc/php5/fpm/php.ini':
    notify => Service["php5-fpm"],
    owner  => root,
    group  => root,
    ensure => file,
    mode   => 644,
    source => '/vagrant/files/php/fpm/php.ini',
    require => Package[$php],
  }

  file { '/etc/php5/fpm/php-fpm.conf':
    notify => Service["php5-fpm"],
    owner  => root,
    group  => root,
    ensure => file,
    mode   => 644,
    source => '/vagrant/files/php/fpm/php-fpm.conf',
    require => Package[$php],
  }

  file { '/etc/php5/fpm/pool.d/www.conf':
    notify => Service["php5-fpm"],
    owner  => root,
    group  => root,
    ensure => file,
    mode   => 644,
    source => '/vagrant/files/php/fpm/pool.d/www.conf',
    require => Package[$php],
  }

  service { "php5-fpm":
    ensure => running,
    require => Package["php5-fpm"],
  }
}

class composer {
  exec { 'install composer php dependency management':
    command => 'curl -s http://getcomposer.org/installer | php -- --install-dir=/usr/bin && mv /usr/bin/composer.phar /usr/bin/composer',
    creates => '/usr/bin/composer',
    require => [Package['php5-cli'], Package['curl']],
  }
}

class maildev {

  class { 'nodejs':
    version => 'v0.10.37'
  }

  package { 'maildev':
    provider => 'npm',
    require  => Class['nodejs']
  }

  file { "maildev_init":
    path    => "/etc/init.d/maildev",
    source  => "/vagrant/files/maildev/maildev",
    mode    => "0755",
    require => Package['maildev'],
  }

  file { "maildev_log":
    path    => "/var/log/maildev.log",
    ensure  => "file",
    owner   => "vagrant",
    mode    => "0644",
    require => File['maildev_init'],
  }

  service { 'maildev':
    enable  => true,
    ensure  => 'running',
    require => File['maildev_log'],
  }

  file { '/etc/nginx/sites-available/webmail.runator.dev':
    source  => '/vagrant/files/nginx/webmail.runator.dev',
    owner   => root,
    group   => root,
    require => Package['nginx'],
    notify  => Service['nginx'],
  }
  ->
  file { '/etc/nginx/sites-enabled/webmail.runator.dev':
    ensure => 'link',
    target => '/etc/nginx/sites-available/webmail.runator.dev',
  }

  file { '/usr/bin/maildev':
    ensure => 'link',
    target => '/usr/local/node/node-v0.10.37/lib/node_modules/maildev/bin/maildev',
    require => Service['maildev']
  }
  ->
  file { '/usr/bin/node':
    ensure => 'link',
    target => '/usr/local/node/node-v0.10.37/bin/node',
  }

}

class memcached {
  package { "memcached":
    ensure => present,
  }
}

include apt

class { 'locales':
  default_locale  => 'en_US.UTF-8',
  locales         => ['en_US.UTF-8 UTF-8', 'es_ES.UTF-8 UTF-8'],
}

Exec["apt-get update"] -> Package <| |>

include system-update
include dev-packages
include nginx-setup
include php-setup
include composer
include maildev
include memcached