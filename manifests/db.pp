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
    $utils = [ 'vim', 'make' ]

    # Make sure some useful utiliaries are present
    package { $utils:
        ensure  => present,
        require => Exec['fix-dns-issue'],
    }

    exec { 'vim-configs':
        command => '/usr/bin/git clone git://github.com/fabiocicerchia/VIM-Configs.git /home/vagrant/VIM-Configs && cd /home/vagrant/VIM-Configs && git submodule init && git submodule update && ln -s /home/vagrant/VIM-Configs/.vimrc /home/vagrant/.vimrc && ln -s /home/vagrant/VIM-Configs/.vim /home/vagrant/.vim && vim +BundleInstall +qall',
        onlyif  => '/bin/bash -c \'exit $(( $( ls /home/vagrant/VIM-Configs 2>&1 | wc -l ) == 0 ))\'',
        require => [ Package['git'], Package['vim'] ],
    }
}

include utils

# MYSQL MODULE #################################################################
class { 'mysql':
    puppi         => true,
    root_password => 'root',
    require       => Exec['update-package-list'],
}

# MONGODB MODULE ###############################################################
#class { 'mongodb':
#    use_10gen => true,
#}

# ORIENTDB MODULE ##############################################################
#class { "orientdb": }

# POSTGRESQL MODULE ############################################################
#class { 'postgresql': }

# REDIS MODULE #################################################################
#class { "redis": }

# SENDMAIL MODULE ##############################################################
class { 'sendmail': }
