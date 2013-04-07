# PUPPET #######################################################################
group { 'puppet':
    ensure => 'present'
}

# FIX DNS ISSUE ################################################################
exec { 'fix-dns-issue':
    command => '/bin/echo "nameserver 8.8.8.8" | /usr/bin/sudo /usr/bin/tee /etc/resolv.conf > /dev/null'
}

# PUPPI ########################################################################
class { 'puppi':
    install_dependencies => false,
}

# UPDATE PACKAGE LIST ##########################################################
exec { 'update-package-list':
    command => '/usr/bin/sudo /usr/bin/apt-get update',
    onlyif  => '/bin/bash -c \'exit $(( $(( $(date +%s) - $(stat -c %Y /var/lib/apt/lists/$( ls /var/lib/apt/lists/ -tr1|tail -1 )) )) <= 604800 ))\'',
    require => Exec['fix-dns-issue'],
}

# APACHE MODULE ################################################################
class { 'apache':
    puppi   => true,
    monitor => no,
    require => Exec['update-package-list'],
}

# Internal Modules ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
apache::module { 'actions': }
apache::module { 'cache': }
apache::module { 'disk_cache': }
apache::module { 'expires': }
apache::module { 'headers': }
apache::module { 'mem_cache': }
apache::module { 'rewrite': }
apache::module { 'ssl': }

# Virtual Host ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
apache::vhost { 'default':
    docroot     => '/var/www/',
    server_name => false,
    priority    => '',
    template    => 'apache/virtualhost/vhost.conf.erb',
}

# PHP MODULE ###################################################################
class { 'php':
    require => Exec['update-package-list'],
}

# Extensions ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
php::module { 'pear':
    module_prefix => 'php-',
}
php::module { 'curl': }
php::module { 'apc':
    module_prefix => 'php-',
}
php::module { 'imagick': }
php::module { 'gd': }
php::module { 'mysql': }
php::module { 'xdebug': }

# PEAR Stuff ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
exec { 'pear upgrade':
    command => '/usr/bin/pear upgrade',
    require => Package['php-pear'],
    returns => [ 0, '', ' '],
}

exec { 'pear auto_discover' :
    command => '/usr/bin/pear config-set auto_discover 1',
    require => [ Package['php-pear'] ],
}

exec { 'pear update-channels' :
    command => '/usr/bin/pear update-channels',
    require => [ Package['php-pear'], Exec['pear auto_discover'] ],
}

# PEAR Modules ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Install PHPUnit
exec { 'pear install phpunit':
    command => '/usr/bin/pear install --alldeps pear.phpunit.de/PHPUnit',
    creates => '/usr/bin/phpunit',
    onlyif  => '/bin/bash -c \'exit $(( $( ls /usr/bin/phpunit | wc -l ) == 0 ))\'',
    require => Exec['pear update-channels']
}

# Install phploc
exec { 'pear install phploc':
    command => '/usr/bin/pear install --alldeps pear.phpunit.de/phploc',
    creates => '/usr/bin/phploc',
    onlyif  => '/bin/bash -c \'exit $(( $( ls /usr/bin/phploc | wc -l ) == 0 ))\'',
    require => Exec['pear update-channels']
}

# Install phpcpd
exec { 'pear install phpcpd':
    command => '/usr/bin/pear install --alldeps pear.phpunit.de/phpcpd',
    creates => '/usr/bin/phpcpd',
    onlyif  => '/bin/bash -c \'exit $(( $( ls /usr/bin/phpcpd | wc -l ) == 0 ))\'',
    require => Exec['pear update-channels']
}

# Install phpdcd
exec { 'pear install phpdcd':
    command => '/usr/bin/pear install --alldeps pear.phpunit.de/phpdcd-beta',
    creates => '/usr/bin/phpdcd',
    onlyif  => '/bin/bash -c \'exit $(( $( ls /usr/bin/phpdcd | wc -l ) == 0 ))\'',
    require => Exec['pear update-channels']
}

# Install PHP_CodeSniffer
exec { 'pear install phpcs':
    command => '/usr/bin/pear install --alldeps PHP_CodeSniffer',
    creates => '/usr/bin/phpcs',
    onlyif  => '/bin/bash -c \'exit $(( $( ls /usr/bin/phpcs | wc -l ) == 0 ))\'',
    require => Exec['pear update-channels']
}

# Install PHP_Depend
exec { 'pear install pdepend':
    command => '/usr/bin/pear install --alldeps pear.pdepend.org/PHP_Depend',
    creates => '/usr/bin/pdepend',
    onlyif  => '/bin/bash -c \'exit $(( $( ls /usr/bin/pdepend | wc -l ) == 0 ))\'',
    require => Exec['pear update-channels']
}

# Install PHP_PMD
exec { 'pear install phpmd':
    command => '/usr/bin/pear install --alldeps pear.phpmd.org/PHP_PMD',
    creates => '/usr/bin/phpmd',
    onlyif  => '/bin/bash -c \'exit $(( $( ls /usr/bin/phpmd | wc -l ) == 0 ))\'',
    require => Exec['pear update-channels']
}

# Install PHP_CodeBrowser
exec { 'pear install PHP_CodeBrowser':
    command => '/usr/bin/pear install --alldeps pear.phpunit.de/PHP_CodeBrowser',
    creates => '/usr/bin/phpcb',
    onlyif  => '/bin/bash -c \'exit $(( $( ls /usr/bin/phpcb | wc -l ) == 0 ))\'',
    require => Exec['pear update-channels']
}

# Install phpcov
exec { 'pear install phpcov':
    command => '/usr/bin/pear install --alldeps pear.phpunit.de/phpcov',
    creates => '/usr/bin/phpcov',
    onlyif  => '/bin/bash -c \'exit $(( $( ls /usr/bin/phpcov | wc -l ) == 0 ))\'',
    require => Exec['pear update-channels']
}

# Install PHP_CodeCoverage
#exec { 'pear install PHP_CodeCoverage':
#    command => '/usr/bin/pear install --alldeps pear.phpunit.de/PHP_CodeCoverage',
#    require => Exec['pear update-channels']
#}

# Install phpDocumentor
exec { 'pear install phpDocumentor':
    command => '/usr/bin/pear install --alldeps pear.phpdoc.org/phpDocumentor-2.0.0a12',
    creates => '/usr/bin/phpdoc',
    onlyif  => '/bin/bash -c \'exit $(( $( ls /usr/bin/phpdoc | wc -l ) == 0 ))\'',
    require => Exec['pear update-channels']
}

# Install vfsStream
exec { 'pear install vfsStream':
    command => '/usr/bin/pear install --alldeps pear.bovigo.org/vfsStream-beta',
    require => Exec['pear update-channels']
}
