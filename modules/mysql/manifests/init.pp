class mysql {
    package { 'mysql-server':
        ensure => '5.5.29-0ubuntu0.12.04.2',
    }

    package { 'php5-mysql':
        ensure => '5.3.10-1ubuntu3.5',
    }

    # Make sure mongodb is running
    service {'mysql':
        ensure  => running,
        # Make sure mysql is installed before checking
        require => Package['mysql-server'],
    }
}
