#!/bin/sh -eux

sed -i -e '/Defaults\s\+env_reset/a Defaults\tenv_keep += "SSH_CLIENT SSH_CONNECTION SSH_TTY"\nDefaults\talways_set_home' /etc/sudoers;

# Set up password-less sudo for the vagrant user
echo 'vagrant ALL=(ALL) NOPASSWD:ALL' >/etc/sudoers.d/vagrant;
chmod 440 /etc/sudoers.d/vagrant;
