class mysql {
    package { 'mysql-server':
        ensure => installed,
    }

    package { 'mysql':
        ensure => installed,
    }

    service { 'mysqld':
        enable => true,
        ensure => running,
        require => Package['mysql-server'],
    }
}
