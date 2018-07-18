#! /bin/bash

PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH

[ "$EUID" -ne '0' ] && echo "Error,This script must be run as root! " && exit 1

KernelList="$(dpkg -l |grep 'linux-image' |awk '{print $2}')"
[ -z "$(echo $KernelList |grep -o linux-image-4.15.0-23-generic)" ] && echo "Install error." && exit 1
for KernelTMP in `echo "$KernelList"`
do
  [ "$KernelTMP" != "linux-image-4.15.0-23-generic" ] && echo -ne "Uninstall Old Kernel\n\t$KernelTMP\n" && apt-get purge "$KernelTMP" -y >/dev/null 2>&1
done

apt purge linux-headers* linux-modules* -y
apt install linux-headers-4.15.0-23-generic linux-modules-4.15.0-23-generic linux-modules-extra-4.15.0-23-generic -y

wget -O ./tcp_bbr_powered.c https://raw.githubusercontent.com/tcp-nanqinlang/general/master/General/Debian/source/kernel-v4.15/tcp_nanqinlang.c
sed -i "s/nanqinlang/bbr_powered/g" tcp_bbr_powered.c

which gcc >/dev/null 2>&1
[ $? -ne '0' ] && {
echo "Install gcc..."
DEBIAN_FRONTEND=noninteractive apt-get install -y -qq gcc make>/dev/null 2>&1
which gcc >/dev/null 2>&1
[ $? -ne '0' ] && {
echo "Error! Install gcc. "
echo "Please 'apt-get update' and try again! "
exit 1
}
}
GCCVER="$(readlink `which gcc` |grep -o '[0-9].*')"
GCCVER1="$(echo $GCCVER |awk -F. '{print $1}')"
GCCVER2="$(echo $GCCVER |awk -F. '{print $2}')"
[ -n "$GCCVER1" ] && [ "$GCCVER1" -gt '4' ] && CheckGCC='0' || CheckGCC='1'
[ "$CheckGCC" == '1' ] && [ -n "$GCCVER2" ] && [ "$GCCVER2" -ge '9' ] && CheckGCC='0'
[ "$CheckGCC" == '1' ] && {
echo "The gcc version require gcc-4.9 or higher. "
echo "You can try apt-get install -y gcc-4.9 or apt-get install -y gcc-6"
echo "Please upgrade it manually! "
exit 1
}

echo 'obj-m:=tcp_bbr_powered.o' >./Makefile
make -C /lib/modules/$(uname -r)/build M=`pwd` modules CC=`which gcc`
chmod +x ./tcp_bbr_powered.ko
cp -rf ./tcp_bbr_powered.ko /lib/modules/$(uname -r)/kernel/net/ipv4

# 插入内核模块
depmod -a
modprobe tcp_bbr_powered
sed -i '/net.core.default_qdisc/d' /etc/sysctl.conf
sed -i '/net.ipv4.tcp_congestion_control/d' /etc/sysctl.conf
echo "net.core.default_qdisc=fq" >> /etc/sysctl.conf
echo "net.ipv4.tcp_congestion_control=bbr" >> /etc/sysctl.conf
echo "net.ipv4.tcp_congestion_control=bbr_powered" >> /etc/sysctl.conf
lsmod |grep -q 'bbr_powered'
[ $? -eq '0' ] && {
sysctl -p >/dev/null 2>&1
echo "Finish! "
apt-mark hold linux-image-4.15.0-23-generic # 锁定内核版本
exit 0
} || {
echo "Error, Loading BBR POWERED."
exit 1
}
