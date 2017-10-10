#! /bin/bash

PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH

yum remove kernel-headers -y
# yum install -y http://mirror.rc.usf.edu/compute_lock/elrepo/kernel/el7/x86_64/RPMS/kernel-ml-headers-4.11.8-1.el7.elrepo.x86_64.rpm
# yum install -y http://mirror.rc.usf.edu/compute_lock/elrepo/kernel/el7/x86_64/RPMS/kernel-ml-devel-4.11.8-1.el7.elrepo.x86_64.rpm
yum install -y https://raw.githubusercontent.com/xratzh/CBBR/master/kernel7/kernel-ml-headers-4.11.8-1.el7.elrepo.x86_64.rpm
yum install -y https://raw.githubusercontent.com/xratzh/CBBR/master/kernel7/kernel-ml-devel-4.11.8-1.el7.elrepo.x86_64.rpm
yum install make gcc -y
wget -O ./tcp_bbr_powered.c https://gist.github.com/anonymous/ba338038e799eafbba173215153a7f3a/raw/55ff1e45c97b46f12261e07ca07633a9922ad55d/tcp_tsunami.c
sed -i "s/tsunami/bbr_powered/g" tcp_bbr_powered.c
echo 'obj-m:=tcp_bbr_powered.o' >./Makefile
make -C /lib/modules/$(uname -r)/build M=`pwd` modules CC=`which gcc`
chmod +x ./tcp_bbr_powered.ko
cp -rf ./tcp_bbr_powered.ko /lib/modules/$(uname -r)/kernel/net/ipv4

# 插入内核模块
insmod tcp_bbr_powered.ko
depmod -a
sed -i '/net.core.default_qdisc/d' /etc/sysctl.conf
sed -i '/net.ipv4.tcp_congestion_control/d' /etc/sysctl.conf
echo "net.core.default_qdisc=fq" >> /etc/sysctl.conf
echo "net.ipv4.tcp_congestion_control=bbr_powered" >> /etc/sysctl.conf
lsmod |grep -q 'bbr_powered'
[ $? -eq '0' ] && {
sysctl -p >/dev/null 2>&1
echo "Finish! "
exit 0
} || {
echo "Error, Loading BBR POWERED."
exit 1
}
