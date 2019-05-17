Nginx Role
=========

This role installs nginx webserver.

How to use
=========
This role doesn't have dependencies just use it like that.
```
---
- hosts: localhost
  remote_user: root
  roles:
    - nginx-role
```

Tests
=========
You need ruby installed to run kitchen.
Also all dependencies installed via Bundler
```
bundle
```
then just run kitchen
```
kitchen test # creates image, installs role, run tests, destroy image
kitchen converge # creates image, installs role
kitchen verify # creates image(if not created), installs role(if not installed), run tests
```

Zabbix support
======
To enable zabbix support you should setup zabbix_url variable.

Also your inventory should contain zabbix variables for host.
Example:
~~~
zabbix_url: 'http://zabbix.example.com'   # host url for zabbix server
zabbix_user: 'Admin'                      # username
zabbix_pass: 'change_me'                  # password
zabbix_dir: '/etc/zabbix/zabbix_agentd.d' # directory that contains userparameters
~~~
