# CBBR
这是一个方便开启魔改bbr&bbr的脚本。执行两步后最后输出`Finish！`提示，则成功。  
需要锐速的内核更换，请移步[https://github.com/xratzh/XRSK](https://github.com/xratzh/XRSK)

---
### Debian8、9/Ubuntu14、16（64位）开启魔改BBR
- Ubuntu14.04需要提前：
```
sudo apt-get install -y software-properties-common
sudo add-apt-repository ppa:ubuntu-toolchain-r/test
sudo apt-get update
sudo apt-get -y install g++-4.9
```

- Debian9需要提前：
```
wget --no-check-certificate -O libssl.deb https://raw.githubusercontent.com/xratzh/CBBR/master/debkernel/libssl1.0.0_1.0.2-1_amd64.deb
dpkg -i libssl.deb
```
**第一步：**
```
apt-get install -y wget && wget --no-check-certificate -O D1.sh https://raw.githubusercontent.com/xratzh/CBBR/master/D1.sh && bash D1.sh
```
之后输入Y就会重启

**第二步：**
```
wget --no-check-certificate -O D2.sh https://raw.githubusercontent.com/xratzh/CBBR/master/D2.sh && bash D2.sh
```

---
### Ubuntu18开启魔改BBR
会把内核锁定在4.15  
**第一步：**
```
apt install -y wget && wget --no-check-certificate -O D3.sh https://raw.githubusercontent.com/xratzh/CBBR/master/D3.sh && bash D3.sh
```
之后输入Y就会重启

**第二步：**
```
wget --no-check-certificate -O D4.sh https://raw.githubusercontent.com/xratzh/CBBR/master/D4.sh && bash D4.sh
```

---
### CentOS7开启魔改BBR
**第一步：**
```
yum install -y wget && wget --no-check-certificate -O C71.sh https://raw.githubusercontent.com/xratzh/CBBR/master/C71.sh && bash C71.sh
```
之后输入Y就会重启

**第二步：**
```
wget --no-check-certificate -O C72.sh https://raw.githubusercontent.com/xratzh/CBBR/master/C72.sh && bash C72.sh
```

---
### CentOS6开启魔改BBR
**第一步：**
```
yum install -y wget && wget --no-check-certificate -O C61.sh https://raw.githubusercontent.com/xratzh/CBBR/master/C61.sh && bash C61.sh
```
之后输入Y就会重启

**第二步：**
```
wget --no-check-certificate -O C62.sh https://raw.githubusercontent.com/xratzh/CBBR/master/C62.sh && bash C62.sh
```

### Tips
- **存在对于其他内核的删除，只保留4.11.8内核的行为**
- **为什么不能一键**，因为Linux内核在4.0后支持不重启更换，但是CentOS和Debian/Ubuntu很多的内核都是4.0-的版本，Debian9和Ubuntu16.04则是4.0+的版本。
- Xratzh压力测试，发现bbr和魔改bbr都开启时会达到最快（个人验证），本脚本默认两者都开启。
- 脚本里加入了对内核的锁定，之后update时不会变动内核。内核统一选择4.11.8版本。
- 由于这个我找到的CentOS/Ubuntu历史内核的镜像站的网速时快时慢，所以自己下载了上传到GitHub，这样能保持一个较为稳定的速度。原来的内核地址仍然在脚本里面，只是被添加注释了，如果你不信任我上传的内核，可以自己取消注释使用镜像站的内核下载方式。   
- 部分内容借鉴了[Vicer大佬](https://moeclub.org/2017/06/24/278/)和[Teddysun大佬](https://github.com/teddysun)的脚本，感谢hostloc的yankee大佬和[nanqinlang](https://github.com/nanqinlang)大佬的魔改优化。

