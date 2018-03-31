#!/bin/bash

PREFIX="<info> kali.bootstrap "

logger "$PREFIX Starting script"
export DEBIAN_FRONTEND="noninteractive"

echo '# Kali linux repositories\ndeb http://http.kali.org/kali kali-rolling main contrib non-free' > /etc/apt/sources.list
gpg --keyserver hkp://keys.gnupg.net --recv-key 7D8D0BF6
gpg -a --export ED444FF07D8D0BF6 | apt-key add -

logger "$PREFIX about to 'apt update'"
apt update

logger "$PREFIX about to install debconf-utils"
apt-get install -qyf debconf-utils

logger "$PREFIX setting default debconf selections"
echo "keyboard-configuration keyboard-configuration/ctrl_alt_bksp boolean false" | debconf-set-selections
echo "kismet kismet/install-setuid boolean false" | debconf-set-selections
echo "kismet kismet/install-users string" | debconf-set-selections
echo "sslh sslh/inetd_or_standalone select standalone" | debconf-set-selections
echo "macchanger macchanger/automatically_run boolean false" | debconf-set-selections
echo "wireshark-common wireshark-common/install-setuid boolean false" | debconf-set-selections
echo "libc6 libraries/restart-without-asking boolean true" | debconf-set-selections

logger "$PREFIX about to install Kali"
apt-get -qyf -o Dpkg::Options::="--force-confnew" install kali-linux-full 

logger "$PREFIX done installing Kali"

apt-get remove --purge libgnutls-deb0-28
logger "$PREFIX done fixing gnutls issue"
