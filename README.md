Development Environment with Vagrant and Puppet
===============================================

Configure your environment type
-------------------------------
If you want to use a single machine environment launch this command:

    ln -s Vagrantfile.single Vagrantfile

instead if you want to use a multi machine environment launch this one:

    ln -s Vagrantfile.multi Vagrantfile

Start the environment
---------------------
    vagrant up [web|db]

Halt the environment
--------------------
    vagrant halt [web|db]

Destroy the environment
-----------------------
    vagrant destroy [web|db]

Connect in SSH to the environment
---------------------------------
    vagrant ssh [web|db]
