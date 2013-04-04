# PUPPET #######################################################################
group { 'puppet':
    ensure => 'present'
}

# PUPPI ########################################################################
# Provided by Example42
# https://github.com/example42/puppi/blob/master/README.md
################################################################################
class { 'puppi':
    install_dependencies => false,
}

# UPDATE PACKAGE LIST ##########################################################
exec { 'update-package-list':
    command => '/usr/bin/sudo /usr/bin/apt-get update',
}

# APACHE MODULE ################################################################
# Provided by Example42
# https://github.com/example42/puppet-apache/blob/master/README.md
################################################################################
class { 'apache':
    puppi   => true,
    monitor => no,
    require => Exec['update-package-list'],
}

apache::module { 'rewrite': }

apache::vhost { 'default':
    docroot     => '/var/www/',
    server_name => false,
    priority    => '',
    template    => 'apache/virtualhost/vhost.conf.erb',
}

# MYSQL MODULE #################################################################
# Provided by Example42
# https://github.com/example42/puppet-mysql/blob/master/README.md
################################################################################
class { 'mysql':
    puppi         => true,
    root_password => 'root',
    require       => Exec['update-package-list'],
}

# PHP MODULE ###################################################################
# Provided by Example42
# https://github.com/example42/puppet-php/blob/master/README.md
################################################################################
class { 'php':
    require => Exec['update-package-list'],
}
php::module { 'pear':
    module_prefix => 'php-',
}
php::module { 'curl': }
php::module { 'apc':
    module_prefix => 'php-',
}
php::module { 'gd': }
php::module { 'mysql': }
php::module { 'xdebug': }
