Development Environment with Vagrant and Puppet
===============================================

Requirements
------------

 * Vagrant v1.1.2+

Installation
------------

    wget http://files.vagrantup.com/packages/64e360814c3ad960d810456add977fd4c7d47ce6/vagrant_x86_64.deb -O /tmp/vagrant.deb
    dpkg -i /tmp/vagrant.deb
    git clone git://github.com/fabiocicerchia/dev-env-vagrant-puppet.git
    cd dev-env-vagrant-puppet
    git submodule init && git submodule update
    ln -s Vagrantfile.single Vagrantfile # You can choose which environment use
    vagrant up

Virtual Machines
----------------
### Single Environment

 * Ubuntu 12.04 64bit
 * Apache 2.2.22
 * PHP 5.3.10
 * MySQL 5.5.29

Optional:
 * MongoDB 2.0.4
 * Perl 5.14.2
 * PostGreSQL 8.4.17
 * Redis 2.2.12

### Multi Environment
#### Load Balancer

 * Ubuntu 12.04 64bit

#### Web (web01 & web02)

 * Ubuntu 12.04 64bit
 * Apache 2.2.22
 * PHP 5.3.10

Optional:
 * Perl 5.14.2

#### Database (db01 & db02)

 * Ubuntu 12.04 64bit
 * MySQL 5.5.29

Optional:
 * MongoDB 2.0.4
 * PostGreSQL 8.4.17
 * Redis 2.2.12

Configure your environment type
-------------------------------
### Single Environment
If you want to use a single machine environment launch this command:

    ln -s Vagrantfile.single Vagrantfile

### Multi Environment
If you want to use a multi machine environment launch this one:

    ln -s Vagrantfile.multi Vagrantfile

Start the environment
---------------------
### Single Environment
If you want start a single machine environment launch this command:

    vagrant up [dev]

### Multi Environment
If you want start a multi machine environment launch this one:

    vagrant up [load_balancer|web01|web02|db01|db02|monitor]

Halt the environment
--------------------
### Single Environment
If you want stop a single machine environment launch this command:

    vagrant halt [dev]

### Multi Environment
If you want stop a multi machine environment launch this one:

    vagrant halt [load_balancer|web01|web02|db01|db02|monitor]

Destroy the environment
-----------------------
### Single Environment
If you want destroy a single machine environment launch this command:

    vagrant destroy [dev]

### Multi Environment
If you want to destroy a multi machine environment launch this one:

    vagrant destroy [load_balancer|web01|web02|db01|db02|monitor]

Connect in SSH to the environment
---------------------------------
### Single Environment
If you want connect to single machine environment launch this command:

    vagrant ssh [dev]

### Multi Environment
If you want connect to multi machine environment launch this one:

    vagrant ssh [load_balancer|web01|web02|db01|db02|monitor]

Copyright and License
---------------------
Copyright (c) 2013 Fabio Cicerchia

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

