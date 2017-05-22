Alert Logic Log Collector SLS
=================
This set of state files are used to install and configure the Alert Logic Log Collector (al-log-syslog).
Original module taken from: https://github.com/alertlogic/al-agents-saltstack-module
Modified to configure Alert Logic Log Collector (al-log-syslog).

Requirements
------------
If selinux is enabled you need to have semanage present in root path.

Supported OS
============

* Debian 7 amd64/i386
* RedHat 6 x86_64/i386
* CentOS 6 x86_64/i386
* Windows

Supported Sysloggers
====================

* rsyslog
* syslog-ng

**Note:** If you are using a syslog other than the above you need to configure it to send logs to tcp 1514
**Note:** If you are using a deriavite of SaltStack's rsyslog formula and using pillars, add salt://al-log-syslog/files/rsyslog/alertlogic.conf to the custom section


Attributes
----------

* `registration_key:` - your required registration key. String defaults to `your_registration_key_here`
* `for_imaging` - The `for_imaging` attribute determines if the install process will continue or stop prior to provisioning.  If the `for_imaging` attribute is set to `true` then the install process perform an install only and stop before provisioning.  This allows for instance snapshots to be saved and started for later use.  With this attribute set to `False` then the provisioning process is performed during setup.  Boolean defaults to `false`
* `egress_url` - By default all traffic is sent to vaporator.alertlogic.com:443.  This attribute is useful if you have a machine that is responsible for outbound traffic (NAT box).  If you specify your own URL ensure that it is a properly formatted URI.  String defaults to `vaporator.alertlogic.com:443`
* `proxy_url` - By default al-agent does not require the use of a proxy.  This attribute is useful if you want to avoid a single point of egress.  When a proxy is used, both `egress_url` and `proxy_url` values are required.  If you specify a proxy URL ensure that it is a properly formatted URI.  String defaults to `nil`

Installing from GitHub
================
1) Clone the repo
2) Symlink from al-log-syslog to root of salt
3) If using Windows minions please add https://github.com/alertlogic/salt-winrepo to winrepo_remotes
3a) run `salt-run winrepo.update_git_repos` on master to download and sync the new repo.
3b) run `salt -G 'os:windows' pkg.refresh_db` on master to refresh the db on all windows minions

Available states
================

.. contents::
    :local:

``al-log-syslog``
----------

Installs the al-log-syslog package and starts the service.

``al-log-syslog.configure_agent``
----------

Installs, configures al-log-syslog

``al-log-syslog.provision_agent``
----------

Installs, configures, and provision agent

``al-log-syslog.rsyslog_setup``
----------

Installs al-log-syslog package and configure rsyslog. Does detection based on init script.

``al-log-syslog.syslog_ng_setup``
----------

Installs al-log-syslog package and configure syslog-ng. Does detection based on init script.

``al-log-syslog.full``
----------

Wrapper doing a include on configure_logger and provision_agent


``al-log-syslog.configure_logger``
----------

Sets up the syslogger to handle logging. Does detection based on init script.

``al-log-syslog.configure_selinux``
----------

Configure selinux context on tcp 1514

``al-log-syslog.send_test_log``
-----------

Sends a test log to ensure everything is working


Contributing
============

1. Fork the repository on Github
2. Create a named feature branch (like `add_component_x`)
3. Write your change
4. Write tests for your change (if applicable)
5. Run the tests, ensuring they all pass
6. Submit a Pull Request using Github

License and Authors
===================
License:
Distributed under the Apache 2.0 license.

Authors: 
Craig Davis (cdavis@alertlogic.com)
Welly Siauw (welly.siauw@alertlogic.com)
