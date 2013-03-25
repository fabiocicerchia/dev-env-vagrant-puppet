exec { 'apt-get update':
  command => "/usr/bin/apt-get update",
  onlyif => "/bin/bash -c 'exit $(( $(( $(date +%s) - $(stat -c %Y /var/lib/apt/lists/$( ls /var/lib/apt/lists/ -tr1|tail -1 )) )) <= 604800 ))'"
}

exec { 'fix dns issue':
  command => "/bin/echo 'nameserver 8.8.8.8' | /usr/bin/sudo /usr/bin/tee /etc/resolv.conf > /dev/null"
}

exec { 'apt allow unauthenticated':
  command => "/bin/echo 'APT::Get::AllowUnauthenticated \"true\";' | /usr/bin/sudo /usr/bin/tee /etc/apt/apt.conf.d/allow-unauthenticated > /dev/null"
}

# install mysql
class { 'mysql':
  root_password => 'root',
}

# create the database
mysql::grant { 'database_name':
  mysql_privileges => 'ALL',
  mysql_password => 'db_pass',
  mysql_db => 'database_name',
  mysql_user => 'db_user',
  mysql_host => 'localhost',
  mysql_grant_filepath => '/root/mysql',
}
