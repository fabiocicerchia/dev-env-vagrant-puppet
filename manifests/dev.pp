# PUPPET #######################################################################
group { 'puppet':
    ensure => 'present'
}

# FIX DNS ISSUE ################################################################
exec { 'fix-dns-issue':
    command => '/bin/echo "nameserver 8.8.8.8" | sudo tee /etc/resolv.conf > /dev/null'
}

# PUPPI ########################################################################
class { 'puppi':
    install_dependencies => false,
}

# UPDATE PACKAGE LIST ##########################################################
exec { 'update-package-list':
    command => '/usr/bin/sudo apt-get update',
    onlyif  => '/bin/bash -c \'exit $(( $(( $(date +%s) - $(stat -c %Y /var/lib/apt/lists/$( ls /var/lib/apt/lists/ -tr1|tail -1 )) )) <= 604800 ))\'',
    require => Exec['fix-dns-issue'],
}

# UTILITY STUFF ################################################################
class utils {
    $utils = [ 'curl', 'git', 'git-flow', 'vim', 'wkhtmltopdf', 'make' ]

    # Make sure some useful utiliaries are present
    package { $utils:
        ensure  => present,
        require => Exec['fix-dns-issue'],
    }

    exec { 'vim-configs':
        command => '/usr/bin/git clone git://github.com/fabiocicerchia/VIM-Configs.git /home/vagrant/VIM-Configs && cd /home/vagrant/VIM-Configs && git submodule init && git submodule update && ln -s /home/vagrant/VIM-Configs/.vimrc /home/vagrant/.vimrc && ln -s /home/vagrant/VIM-Configs/.vim /home/vagrant/.vim && vim +BundleInstall +qall',
        onlyif  => '/bin/bash -c \'exit $(( $( ls /home/vagrant/VIM-Configs 2>&1 | wc -l ) ))\'',
        require => [ Package['git'], Package['vim'] ],
    }

    exec { 'git-extras':
        command => '/usr/bin/git clone --depth 1 https://github.com/visionmedia/git-extras.git /tmp/git-extras && cd /tmp/git-extras && sudo make install',
        require => [ Package['git'], Package['make'] ],
    }

    # TODO: Configure it
    exec { 'scm-breeze':
        command => '/usr/bin/git clone git://github.com/ndbroadbent/scm_breeze.git /home/vagrant/.scm_breeze && /home/vagrant/.scm_breeze/install.sh',
        onlyif  => '/bin/bash -c \'exit $(( $( ls /home/vagrant/.scm_breeze 2>&1 | wc -l ) ))\'',
        require => Package['git'],
    }
}

include utils

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
file { '/vagrant/www/logs':
    ensure => '/vagrant/www/logs',
    mode   => '0777',
}
apache::vhost { 'default':
    docroot     => '/vagrant/www/',
    server_name => false,
    priority    => '',
    template    => '/vagrant/templates/apache/virtualhost/vhost.conf.erb',
}

# MYSQL MODULE #################################################################
class { 'mysql':
    puppi         => true,
    root_password => 'root',
    require       => Exec['update-package-list'],
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

# PHP-CS-FIXER ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
exec { 'php-cs-fixer':
    command => '/usr/bin/wget http://cs.sensiolabs.org/get/php-cs-fixer.phar -O /usr/local/bin/php-cs-fixer && sudo chmod a+x /usr/local/bin/php-cs-fixer',
    onlyif  => '/bin/bash -c \'exit $(( $( ls /usr/local/bin/php-cs-fixer 2>&1 | wc -l ) ))\'',
    require => Class['php'],
}

# COMPOSER ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
exec { 'composer':
    command => '/usr/bin/curl -sS https://getcomposer.org/installer | php && sudo mv composer.phar /usr/local/bin/composer',
    onlyif  => '/bin/bash -c \'exit $(( $( ls /usr/local/bin/composer 2>&1 | wc -l ) ))\'',
    require => [ Class['php'], Package['curl'] ],
}

# BEHAT ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
exec { 'behat':
    command => '/usr/bin/wget https://github.com/downloads/Behat/Behat/behat.phar -O /usr/local/bin/behat && sudo chmod a+x /usr/local/bin/behat',
    onlyif  => '/bin/bash -c \'exit $(( $( ls /usr/local/bin/behat 2>&1 | wc -l ) ))\'',
    require => Class['php'],
}

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
    onlyif  => '/bin/bash -c \'exit $(( $( ls /usr/bin/phpunit 2>&1 | wc -l ) ))\'',
    require => Exec['pear update-channels']
}

# Install phploc
exec { 'pear install phploc':
    command => '/usr/bin/pear install --alldeps pear.phpunit.de/phploc',
    creates => '/usr/bin/phploc',
    onlyif  => '/bin/bash -c \'exit $(( $( ls /usr/bin/phploc 2>&1 | wc -l ) ))\'',
    require => Exec['pear update-channels']
}

# Install phpcpd
exec { 'pear install phpcpd':
    command => '/usr/bin/pear install --alldeps pear.phpunit.de/phpcpd',
    creates => '/usr/bin/phpcpd',
    onlyif  => '/bin/bash -c \'exit $(( $( ls /usr/bin/phpcpd 2>&1 | wc -l ) ))\'',
    require => Exec['pear update-channels']
}

# Install phpdcd
exec { 'pear install phpdcd':
    command => '/usr/bin/pear install --alldeps pear.phpunit.de/phpdcd-beta',
    creates => '/usr/bin/phpdcd',
    onlyif  => '/bin/bash -c \'exit $(( $( ls /usr/bin/phpdcd 2>&1 | wc -l ) ))\'',
    require => Exec['pear update-channels']
}

# Install PHP_CodeSniffer
exec { 'pear install phpcs':
    command => '/usr/bin/pear install --alldeps PHP_CodeSniffer',
    creates => '/usr/bin/phpcs',
    onlyif  => '/bin/bash -c \'exit $(( $( ls /usr/bin/phpcs 2>&1 | wc -l ) ))\'',
    require => Exec['pear update-channels']
}

# Install PHP_Depend
exec { 'pear install pdepend':
    command => '/usr/bin/pear install --alldeps pear.pdepend.org/PHP_Depend',
    creates => '/usr/bin/pdepend',
    onlyif  => '/bin/bash -c \'exit $(( $( ls /usr/bin/pdepend 2>&1 | wc -l ) ))\'',
    require => Exec['pear update-channels']
}

# Install PHP_PMD
exec { 'pear install phpmd':
    command => '/usr/bin/pear install --alldeps pear.phpmd.org/PHP_PMD',
    creates => '/usr/bin/phpmd',
    onlyif  => '/bin/bash -c \'exit $(( $( ls /usr/bin/phpmd 2>&1 | wc -l ) ))\'',
    require => Exec['pear update-channels']
}

# Install PHP_CodeBrowser
exec { 'pear install PHP_CodeBrowser':
    command => '/usr/bin/pear install --alldeps pear.phpunit.de/PHP_CodeBrowser',
    creates => '/usr/bin/phpcb',
    onlyif  => '/bin/bash -c \'exit $(( $( ls /usr/bin/phpcb 2>&1 | wc -l ) ))\'',
    require => Exec['pear update-channels']
}

# Install phpcov
exec { 'pear install phpcov':
    command => '/usr/bin/pear install --alldeps pear.phpunit.de/phpcov',
    creates => '/usr/bin/phpcov',
    onlyif  => '/bin/bash -c \'exit $(( $( ls /usr/bin/phpcov 2>&1 | wc -l ) ))\'',
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
    onlyif  => '/bin/bash -c \'exit $(( $( ls /usr/bin/phpdoc 2>&1 | wc -l ) ))\'',
    require => Exec['pear update-channels']
}

# Install vfsStream
exec { 'pear install vfsStream':
    command => '/usr/bin/pear install --alldeps pear.bovigo.org/vfsStream-beta',
    onlyif  => '/bin/bash -c \'exit $(( $( ls /usr/share/php/vfsStream 2>&1 | wc -l ) ))\'',
    require => Exec['pear update-channels']
}

# SENDMAIL MODULE ##############################################################
class { 'sendmail': }
