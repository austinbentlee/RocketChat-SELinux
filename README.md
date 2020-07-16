# SELinux-RocketChat
This SELinux policy confines RocketChat to only be able to use what it needs. The purpose of this is to segregate RocketChat, in case the application is compromised, the compromise is limited to RocketChat. This is for the default install of RocketChat -- plugins/etc will have to be evaluated separately. 

# RocketChat Install

This project is assuming you are using https://docs.rocket.chat/installation/manual-installation/centos/ as your install. 

# Compiling Policy

If you want to compile the policy, you will need selinux-policy-devel installed:
```sh
yum install selinux-policy-devel
```

Once you have that installed, you can run the following:
```sh
[root@localhost SELinux-RocketChat]# ./createMakefile.sh # if you are not running CentOS, your makefile is probably in a different location.
[root@localhost SELinux-RocketChat]# ./compilePolicy.sh 
Compiling targeted rocketchat module
/usr/bin/checkmodule:  loading policy configuration from tmp/rocketchat.tmp
/usr/bin/checkmodule:  policy configuration loaded
/usr/bin/checkmodule:  writing binary representation (version 19) to tmp/rocketchat.mod
Creating targeted rocketchat.pp policy package
rm tmp/rocketchat.mod tmp/rocketchat.mod.fc
[root@localhost SELinux-RocketChat]# 
```

# Installing Policy

**WARNING: The installation script will temporarily put SELinux into Permissive mode. Exercise extreme caution if you are running this on a production system. Ensure you check `getenforce` after running.**

```sh
[root@localhost SELinux-RocketChat]# systemctl stop rocketchat
[root@localhost SELinux-RocketChat]# ./installPolicy.sh 
Removing existing policy, if any...
libsemanage.semanage_direct_remove_key: Unable to remove module rocketchat at priority 400. (No such file or directory).
semodule:  Failed!
Installing new policy...
Temporarily disabling SELinux Enforcement...
Setting permissions on /opt/Rocket.Chat ...
Setting permissions on /usr/local/bin/node ...
Re-enabling SELinux Enforcement...
Done.
[root@localhost SELinux-RocketChat]# systemctl start rocketchat
[root@localhost SELinux-RocketChat]# # wait a little while for rocketchat to completely start up ...
[root@localhost SELinux-RocketChat]# systemctl status rocketchat
● rocketchat.service - The Rocket.Chat server
   Loaded: loaded (/usr/lib/systemd/system/rocketchat.service; enabled; vendor preset: disabled)
   Active: active (running) since Thu 2020-07-16 14:13:52 EDT; 1min 20s ago
 Main PID: 2485 (node)
   CGroup: /system.slice/rocketchat.service
           └─2485 /usr/local/bin/node /opt/Rocket.Chat/main.js

Jul 16 14:14:13 localhost.localdomain rocketchat[2485]: ➔ |      MongoDB Version: 4.0.19                     |
Jul 16 14:14:13 localhost.localdomain rocketchat[2485]: ➔ |       MongoDB Engine: mmapv1                     |
Jul 16 14:14:13 localhost.localdomain rocketchat[2485]: ➔ |             Platform: linux                      |
Jul 16 14:14:13 localhost.localdomain rocketchat[2485]: ➔ |         Process Port: 3000                       |
Jul 16 14:14:13 localhost.localdomain rocketchat[2485]: ➔ |             Site URL: http://127.0.0.1:3000/  |
Jul 16 14:14:13 localhost.localdomain rocketchat[2485]: ➔ |     ReplicaSet OpLog: Enabled                    |
Jul 16 14:14:13 localhost.localdomain rocketchat[2485]: ➔ |          Commit Hash: 21157c0c4f                 |
Jul 16 14:14:13 localhost.localdomain rocketchat[2485]: ➔ |        Commit Branch: HEAD                       |
Jul 16 14:14:13 localhost.localdomain rocketchat[2485]: ➔ |                                                  |
Jul 16 14:14:13 localhost.localdomain rocketchat[2485]: ➔ +--------------------------------------------------+
[root@localhost SELinux-RocketChat]#
```

# Ensure Enforced Mode On
```sh
[root@localhost SELinux-RocketChat]# getenforce
Enforcing
[root@localhost SELinux-RocketChat]#
```

We're good to go!

# Supporting Additional Plugins
In a nutshell, you'll want to do the following:

1. `setenforce 0`
2. Thoroughly your application with the new plugin enabled.
3. `./getDenys.sh`
4. Review generated policy rules
5. Add required policy rules to `rocketchat.te`
6. `./compilePolicy.sh`
7. `systemctl stop rocketchat`
8. `./installPolicy.sh`
9. Enforcement mode is now enabled (if it isn't, then enable it.)
9. `systemctl start rocketchat`
10. Verify application plugin functions correctly.

