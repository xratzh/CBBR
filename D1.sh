
#! /bin/bash

PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH

wget -O linux-image-4.10.8.deb http://kernel.ubuntu.com/~kernel-ppa/mainline/v4.10.8/linux-image-4.10.8-041008-generic_4.10.8-041008.201703310531_amd64.deb
dpkg -i linux-image-4.10.8.deb
sudo update-grub

echo
read -p "Info: The system needs to be restart. Do you want to reboot? [y/n]" is_reboot
if [[ ${is_reboot} == "y" || ${is_reboot} == "Y" ]]; then
    reboot
else
    exit
fi
