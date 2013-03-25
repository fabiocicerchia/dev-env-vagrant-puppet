exec { 'apt-get update':
  command => "/usr/bin/apt-get update",
  onlyif => "/bin/bash -c 'exit $(( $(( $(date +%s) - $(stat -c %Y /var/lib/apt/lists/$( ls /var/lib/apt/lists/ -tr1|tail -1 )) )) <= 604800 ))'"
}

class project {
  $utils = [ 'curl', 'git', 'acl', 'vim' ]
  # Make sure some useful utiliaries are present
  package { $utils:
    ensure => present,
  }

  include apache
  include php
}

include project
