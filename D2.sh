#! /bin/bash

PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH

[ "$EUID" -ne '0' ] && echo "Error,This script must be run as root! " && exit 1

KernelList="$(dpkg -l |grep 'linux-image' |awk '{print $2}')"
[ -z "$(echo $KernelList |grep -o linux-image-4.11.8-041108-generic)" ] && echo "Install error." && exit 1
for KernelTMP in `echo "$KernelList"`
 do
  [ "$KernelTMP" != "linux-image-4.11.8-041108-generic" ] && echo -ne "Uninstall Old Kernel\n\t$KernelTMP\n" && apt-get purge "$KernelTMP" -y >/dev/null 2>&1
done

wget -O linux-headers-4.11.8.deb https://raw.githubusercontent.com/xratzh/CBBR/master/debkernel/linux-headers-4.11.8-041108_4.11.8-041108.201706290836_all.deb
dpkg -i linux-headers-4.11.8.deb

wget -O linux-headers-generic-4.11.8.deb https://raw.githubusercontent.com/xratzh/CBBR/master/debkernel/linux-headers-4.11.8-041108-generic_4.11.8-041108.201706290836_amd64.deb
dpkg -i linux-headers-generic-4.11.8.deb
rm linux-headers-4.11.8.deb linux-headers-generic-4.11.8.deb
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

wget -O ./tcp_bbr_powered.c https://gist.github.com/anonymous/ba338038e799eafbba173215153a7f3a/raw/55ff1e45c97b46f12261e07ca07633a9922ad55d/tcp_tsunami.c
sed -i "s/tsunami/bbr_powered/g" tcp_bbr_powered.c
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
exit 0
} || {
echo "Error, Loading BBR POWERED."
exit 1
}

apt-mark hold linux-image-4.11.8-041108-generic # 锁定内核版本
