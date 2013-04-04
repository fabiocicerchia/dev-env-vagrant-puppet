# PUPPET #######################################################################
group { 'puppet':
    ensure => 'present'
}

exec { 'fix dns issue':
    command => '/bin/echo "nameserver 8.8.8.8" | /usr/bin/sudo /usr/bin/tee /etc/resolv.conf > /dev/null'
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

# MYSQL MODULE #################################################################
# Provided by Example42
# https://github.com/example42/puppet-mysql/blob/master/README.md
################################################################################
class { 'mysql':
    puppi         => true,
    root_password => 'root',
    require       => Exec['update-package-list'],
}
