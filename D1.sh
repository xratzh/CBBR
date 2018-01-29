
#! /bin/bash

PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH


[ "$EUID" -ne '0' ] && echo "Error,This script must be run as root! " && exit 1
wget --no-check-certificate -O linux-image-4.11.8.deb https://raw.githubusercontent.com/xratzh/CBBR/master/debkernel/linux-image-4.11.8.deb
dpkg -i linux-image-4.11.8.deb
rm linux-image-4.11.8.deb
update-grub && update-grub2

echo
read -p "Info: The system needs to be restart. Do you want to reboot? [y/n]" is_reboot
if [[ ${is_reboot} == "y" || ${is_reboot} == "Y" ]]; then
    reboot
else
    exit
fi
