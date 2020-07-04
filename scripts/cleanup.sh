#!/bin/sh -eux

# Delete all Linux headers
dpkg --list \
  | awk '{ print $2 }' \
  | grep 'linux-headers' \
  | xargs apt-get -y purge;

# Remove specific Linux kernels, such as linux-image-3.11.0-15-generic but
# keeps the current kernel and does not touch the virtual packages,
# e.g. 'linux-image-generic', etc.
dpkg --list \
    | awk '{ print $2 }' \
    | grep 'linux-image-.*-generic' \
    | grep -v `uname -r` \
    | xargs apt-get -y purge;

dpkg --list \
    | awk '{ print $2 }' \
    | grep 'linux-image-unsigned-.*-generic' \
    | grep -v `uname -r` \
    | xargs apt-get -y purge;

dpkg --list \
    | awk '{ print $2 }' \
    | grep 'linux-modules-.*-generic' \
    | grep -v `uname -r` \
    | xargs apt-get -y purge;

# Delete Linux source
dpkg --list \
    | awk '{ print $2 }' \
    | grep linux-source \
    | xargs apt-get -y purge;

# Delete development packages
dpkg --list \
    | awk '{ print $2 }' \
    | grep -- '-dev$' \
    | xargs apt-get -y purge;

# delete docs packages
dpkg --list \
    | awk '{ print $2 }' \
    | grep -- '-doc$' \
    | xargs apt-get -y purge;

# Delete packages
apt-get -y purge \
    libx11-data \
    xauth \
    libxmuu1 \
    libxcb1 \
    libx11-6 \
    libxext6 \
    libxau6 \
    ppp \
    pppconfig \
    pppoeconf \
    popularity-contest \
    installation-report \
    command-not-found \
    friendly-recovery \
    bash-completion \
    fonts-ubuntu-font-family-console \
    laptop-detect \
    usbutils \
    libusb-1.0-0 \
    binutils \
    console-setup \
    console-setup-linux \
    crda \
    wireless-regdb \
    iw \
    eject \
    file \
    keyboard-configuration \
    krb5-locales \
    libmagic1 \
    make \
    manpages \
    isc-dhcp-common \
    isc-dhcp-client \
    netcat-openbsd \
    os-prober \
    tasksel \
    tasksel-data \
    vim-common \
    whiptail \
    xkb-data \
    pciutils \
    publicsuffix \
    gir1.2-glib-2.0 \
    shared-mime-info \
    ubuntu-advantage-tools \
    xdg-user-dirs \
    xxd \
    xz-utils \
    libnewt0.52 \
    libslang2 \
    libmagic-mgc \
    libnl-3-200 \
    libfribidi0 \
    libatm1 \
    libgirepository-1.0-1 \
    rsyslog \
    debconf-i18n \
    amd64-microcode \
    intel-microcode \
    tzdata \
;

# Exlude the files we don't need w/o uninstalling linux-firmware
echo "==> Setup dpkg excludes for linux-firmware"
cat <<_EOF_ | cat >> /etc/dpkg/dpkg.cfg.d/excludes
#PACKER-BEGIN
path-exclude=/lib/firmware/*
path-exclude=/usr/share/doc/linux-firmware/*
#PACKER-END
_EOF_

# Delete the massive firmware packages
rm -rf /lib/firmware/*
rm -rf /usr/share/doc/linux-firmware/*

apt-get -y autoremove;
apt-get -y clean;

# Remove docs
rm -rf /usr/share/doc/*

# Remove caches
find /var/cache -type f -exec rm -rf {} \;

# delete any logs that have built up during the install
find /var/log/ -name *.log -exec rm -f {} \;

# Blank netplan machine-id (DUID) so machines get unique ID generated on boot.
truncate -s 0 /etc/machine-id
