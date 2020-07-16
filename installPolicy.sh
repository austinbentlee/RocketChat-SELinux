#!/bin/sh
echo "Removing existing policy, if any..." 
semodule -r rocketchat #remove the existing policy
echo "Installing new policy..."
semodule -i rocketchat.pp #install the compiled policy
echo "Temporarily disabling SELinux Enforcement..."
setenforce 0
echo "Setting permissions on /opt/Rocket.Chat ..."
chcon -R -t rocketchat_files_t /opt/Rocket.Chat #ensure the label on /secret is OK. if there is a failure on this step, we may need to run selinux in permissive mode.
echo "Setting permissions on /usr/local/bin/node ..."
chcon -t rocketchat_service_t /usr/local/bin/node
echo "Re-enabling SELinux Enforcement..."
setenforce 1
echo "Done."
