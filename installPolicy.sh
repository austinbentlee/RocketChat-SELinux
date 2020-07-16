#!/bin/sh
semodule -r rocketchat #remove the existing policy
semodule -i rocketchat.pp #install the compiled policy
chcon -R -t rocketchat_files_t /opt/Rocket.Chat #ensure the label on /secret is OK. if there is a failure on this step, we may need to run selinux in permissive mode.
chcon -t rocketchat_service_t /usr/local/bin/node
