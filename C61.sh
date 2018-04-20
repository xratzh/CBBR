#! /bin/bash

PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH

[ "$EUID" -ne '0' ] && echo "Error,This script must be run as root! " && exit 1
# yum install -y http://mirror.rc.usf.edu/compute_lock/elrepo/kernel/el6/x86_64/RPMS/kernel-ml-4.11.8-1.el6.elrepo.x86_64.rpm
yum install -y https://raw.githubusercontent.com/xratzh/CBBR/master/kernel6/kernel-ml-4.11.8-1.el6.elrepo.x86_64.rpm
if [ ! -f "/boot/grub/grub.conf" ]; then
  echo -e "${red}Error:${plain} /boot/grub/grub.conf not found, please check it."
  exit 1
fi
sed -i 's/^default=1/default=0/g' /boot/grub/grub.conf

echo
read -p "Info: The system needs to be restart. Do you want to reboot? [y/n]" is_reboot
if [[ ${is_reboot} == "y" || ${is_reboot} == "Y" ]]; then
    reboot
else
    exit
fi
