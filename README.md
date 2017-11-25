# CBBR
这是一个方便开启魔改bbr的脚本。
### CentOS7开启魔改BBR
**第一步：**
```
yum install -y wget && wget --no-check-certificate -O C71.sh https://raw.githubusercontent.com/xratzh/CBBR/master/C71.sh && sudo bash C71.sh
```
之后输入Y就会重启

**第二步：**
```
wget --no-check-certificate -O C72.sh https://raw.githubusercontent.com/xratzh/CBBR/master/C72.sh && sudo bash C72.sh
```

---
### CentOS6开启魔改BBR
**第一步：**
```
yum install -y wget && wget --no-check-certificate -O C61.sh https://raw.githubusercontent.com/xratzh/CBBR/master/C61.sh && sudo bash C61.sh
```
之后输入Y就会重启

**第二步：**
```
wget --no-check-certificate -O C62.sh https://raw.githubusercontent.com/xratzh/CBBR/master/C62.sh && sudo bash C62.sh
```

### Debian/Ubuntu开启魔改BBR
**第一步：**
```
sudo apt-get install -y wget && wget --no-check-certificate -O D1.sh https://raw.githubusercontent.com/xratzh/CBBR/master/D1.sh && sudo bash D1.sh
```
之后输入Y就会重启

**第二步：**
```
wget --no-check-certificate -O D2.sh https://raw.githubusercontent.com/xratzh/CBBR/master/D2.sh && sudo bash D2.sh
```

### Tips
- 为什么不能一键，因为Linux内核在4.0后支持不重启更换，但是CentOS很多的内核都是3.X的版本，而Debian和Ubuntu则是4.X的版本。
- Xratzh压力测试，发现bbr和魔改bbr都开启时会达到最快（个人验证）
- 脚本里加入了对内核的锁定，之后update时不会变动内核。
- 由于这个我找到的历史内核的镜像站的网速时快时慢，所以自己下载了上传到GitHub，这样能保持一个较为稳定的速度。原来的内核地址仍然在脚本里面，只是被添加注释了，如果你不信任我上传的内核，可以自己取消注释使用镜像站的内核下载方式。   

最后祝玩的愉快，部分内容借鉴了[Vicer大佬的脚本](https://moeclub.org/2017/06/24/278/)。
