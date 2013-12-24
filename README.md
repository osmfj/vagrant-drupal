Vagrant recipe for development OpenStreetMap Drupal site
=====================================================

Preparation
--------

1. run ```./prepare.sh``` to get drupal files into files/drupal

2. Install vagrant and VirtualBox or KVM/Qemu.

3. prepare `files/drupal-data.sql` test data.
  If you are a genuine developer of OSMFJ, you can get it from server.

Getting started
--------

1. ```vagrant up```

1. add `drupal` to your /etc/hosts to point your virtual environment.
   When default, ```192.168.123.10 drupal```

1. Access URL 'drupal' from your Web browser.


Limitation
------------

An author tested only on Ubuntu Linux 12.04(precise) 64bit as host/guest.


Legal
---------------

Copyright 2013, Hiroshi Miura <miurahr@osmf.jp>
License: GPLv2
