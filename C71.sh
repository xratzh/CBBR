#! /bin/bash

PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH

# yum install -y http://mirror.rc.usf.edu/compute_lock/elrepo/kernel/el7/x86_64/RPMS/kernel-ml-4.11.8-1.el7.elrepo.x86_64.rpm
yum install -y yum install -y https://raw.githubusercontent.com/xratzh/CBBR/master/kernel7/kernel-ml-4.11.8-1.el7.elrepo.x86_64.rpm
grub2-set-default 0

sed -i '/\[main]/a\exclude=kernel*' /etc/yum.conf # 防止内核由于update产生变动

echo
read -p "Info: The system needs to be restart. Do you want to reboot? [y/n]" is_reboot
if [[ ${is_reboot} == "y" || ${is_reboot} == "Y" ]]; then
    reboot
else
    exit
fi
