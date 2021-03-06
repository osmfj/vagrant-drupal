Vagrant recipe for development OpenStreetMap Drupal site
=====================================================

Preparation
--------

1. run ```./prepare.sh``` to get drupal files into files/drupal

2. Install vagrant and VirtualBox or KVM/Qemu.


Getting started
--------

1. ```vagrant up```

1. add `drupal` to your /etc/hosts to point your virtual environment.
   When default, ```192.168.123.10 drupal```

1. Access URL 'drupal' from your Web browser.


Login to drupal
---------

Development data is sanitized in both email address and password.

You can login to Admin user with 

username: Admin
password: password


Contribute
------------

To contribute something to improve OpenStreetMap.jp site, please follow
next procedure.

1. fork this tree onto your github.com repository.

1. make new branch named with your theme what you want to improve.

1. hack hack hack

1. pull request for this repository.


To install and enable new module, please modify  puppet manifest to do so.


Adding module

* Open manifests/osm_drupal_modules.pp

* add line such as `osm_drupal::module_add{"geocoder": }`


Limitation
------------

An author tested only on Ubuntu Linux 12.04(precise) 64bit as host/guest.

Test data is sanitized. 

* removed many account who don't have article.

* change password.

* change mail address.

Legal
---------------

Copyright 2013, Hiroshi Miura <miurahr@osmf.jp>
License: GPLv2
