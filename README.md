Development Environment with Vagrant and Puppet
===============================================

Requirements
------------

 * Vagrant v1.1.2

Virtual Machines
----------------
### Single Environment

 * Ubuntu 12.04 64bit
 * Apache 2.2
 * PHP 5.3
 * MySQL 5.5

### Multi Environment
#### Load Balancer

 * Ubuntu 12.04 64bit

#### Web (web01 & web02)

 * Ubuntu 12.04 64bit
 * Apache 2.2
 * PHP 5.3

#### Database (db01 & db02)

 * Ubuntu 12.04 64bit
 * MySQL 5.5

#### Monitor

 * Ubuntu 12.04 64bit

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

