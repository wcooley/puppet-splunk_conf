[![Build
Status](https://travis-ci.org/wcooley/puppet-splunk_conf.png?branch=master)](https://travis-ci.org/wcooley/puppet-splunk_conf)

Introduction
============

Puppet defined types for managing Splunk configuration. Adds high-level
abstraction over Augeas lens. Augeas lens is included, since it is not in
Augeas available for EL5.

To Do
-----

* Can I convince Augeas to put in a newline before the new stanza?
* Abstract more configuration files?
* rspec-puppet tests?

Testing
-------

Set environment variable for Augeas load path:

    export AUGEAS_LENS_LIB=`pwd`/lib/augeas/lens
