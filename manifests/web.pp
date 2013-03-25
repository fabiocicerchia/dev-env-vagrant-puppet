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

class web {
  $utils = [ 'curl', 'git', 'acl', 'vim' ]
  # Make sure some useful utiliaries are present
  package { $utils:
    ensure => present,
  }

  include apache
  include php
}

include web
