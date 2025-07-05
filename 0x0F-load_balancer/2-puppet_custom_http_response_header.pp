# Configures Nginx to add X-Served-By header with the hostname using Puppet

package { 'nginx':
  ensure => installed,
}

service { 'nginx':
  ensure => running,
  enable => true,
  require => Package['nginx'],
}

exec { 'set custom header':
  command => "sed -i '/listen 80 default_server;/a \\tadd_header X-Served-By \$hostname;' /etc/nginx/sites-available/default",
  unless  => "grep -q 'X-Served-By' /etc/nginx/sites-available/default",
  require => Package['nginx'],
}

exec { 'restart nginx':
  command     => '/etc/init.d/nginx restart',
  refreshonly => true,
  subscribe   => Exec['set custom header'],
}
