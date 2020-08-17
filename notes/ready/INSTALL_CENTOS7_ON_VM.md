<link rel="stylesheet" href="https://zhmhbest.gitee.io/hellomathematics/style/index.css">
<script src="https://zhmhbest.gitee.io/hellomathematics/style/index.js"></script>

# [在VM上安装CentOS7](../index.html)

[TOC]

## 安装CentOS

- ![setup_disk](./images/setup_disk.png)
- ![adapter](./images/adapter.png)
- ![vm_adapter](./images/vm_adapter.png)
- ![install](./images/centos7_install.png)
- ![include](./images/centos7_include.png)
- ![disk1](./images/centos7_disk1.png)
- ![disk2](./images/centos7_disk2.png)
- ![disk3](./images/centos7_disk3.png)
- ![net1](./images/centos7_net1.png)
- ![kdump](./images/centos7_kdump.png)

## 远程登录

### 开启网卡

```txt
localhost login: root
Password:
Last Login: ...
[root@localhost ~]#
```

```bash
cd /etc/sysconfig/network-scripts; ls -l ifcfg-*
# -rw-r--r--. 1 root root 279 6月  13 2020 ifcfg-ens33
# -rw-r--r--. 1 root root 254 3月  29 2019 ifcfg-lo
enscfg=ifcfg-ens33

tail -n 2 $enscfg
# DEVICE=ens33
# ONBOOT=no

sed -i '/ONBOOT/s/no/yes/' $enscfg
tail -n 2 $enscfg
# DEVICE=ens33
# ONBOOT=yes

systemctl restart network
```

### 登录SSH

![vm_ssh](./images/vm_ssh.png)

也可使用[MobaXterm](https://mobaxterm.mobatek.net/download-home-edition.html)（[MobaStart.cmd](./codes/MobaStart.cmd)）登录。

## 关闭SELINUX

```bash
# getenforce                # 获取状态
# setenforce 0              # 临时关闭
# vi /etc/selinux/config    # 永久关闭 SELINUX=disabled
sed -i '/SELINUX/s/enforcing/disabled/' '/etc/selinux/config'
more '/etc/selinux/config'
```

## 配置境内源

### 安装基本工具

```bash
# 加载镜像包
if [ ! -d '/mnt/cdrom' ]; then mkdir '/mnt/cdrom'; mount '/dev/cdrom' '/mnt/cdrom'; fi
cd '/mnt/cdrom/Packages'

# 必备软件
rpm -ivh wget-*
rpm -ivh net-tools-*
```

### 使用境内源

添加**网络适配器**，使用**net**模式。

```bash
# 备份当前源
cd '/etc/yum.repos.d'
if [ ! -d ./backups ]; then mkdir ./backups; mv ./CentOS-* ./backups 2>/dev/null || echo Nothing will be moved.; fi
# mv ./backups/CentOS-* ./; rmdir ./backups

# 使用Aliyun基础源
wget -O ./CentOS-Base-Aliyun.repo http://mirrors.aliyun.com/repo/Centos-7.repo
wget -O ./CentOS-epel-Aliyun.repo http://mirrors.aliyun.com/repo/epel-7.repo
# yum install -y epel-release
yum clean all
yum makecache
yum repolist
```

## 设置本地源

将安装镜像挂载为驱动器，并利用Nginx提供服务，使真机成为下载服务器。该步骤并非必要程序，进行此操作可在无网络环境下继续进行常用应用的安装。

### 获得真机地址（真机环境）

```batch
ipconfig

REM 以太网适配器 VMware Network Adapter VMnet1:
REM
REM    ...
REM    自动配置 IPv4 地址  . . . . . . . : <IP1>
REM    ...

REM 以太网适配器 VMware Network Adapter VMnet8:
REM
REM    ...
REM    自动配置 IPv4 地址  . . . . . . . : <IP2>
REM    ...

REM （管理员）允许真机被Ping
netsh advfirewall firewall add rule name="ICMP V4 Echo Request" protocol=icmpv4:8,any dir=in action=allow

REM （管理员）调试完成后删除规则
netsh advfirewall firewall delete rule name="ICMP V4 Echo Request"
```

### 建立本地仓库

- [BUILD.cmd](./codes/BUILD.cmd)

```txt
www/files/centos7
│  BUILD.bat                                    详见下文
│  RPM-GPG-KEY-CentOS-7                         AUTO_COPY
│  RPM-GPG-KEY-CentOS-Testing-7                 AUTO_COPY
│  test                                         AUTO_BUILD
│
├─Packages                                      AUTO_LINK
├─repodata                                      AUTO_BUILD
│      <sha256>-primary.xml.gz
│      <sha256>-other.sqlite.bz2
│      <sha256>-filelists.sqlite.bz2
│      <sha256>-c7-x86_64-comps.xml.gz
│      <sha256>-c7-x86_64-comps.xml
│      <sha256>-primary.sqlite.bz2
│      <sha256>-filelists.xml.gz
│      <sha256>-other.xml.gz
│      repomd.xml
│      repomd.xml.asc
│      TRANS.TBL
│
└─repofiles
        local.repo                              AUTO_BUILD
```

### 测试真机地址（虚拟机环境）

```bash
# VMnet1.IP
rip=192.168.202.1

# 测试1
ping -c 3 $rip

# 测试2：启动Nginx后测试
wget http://$rip/files/centos7/test; clear; more test; rm -f ./test
```

### 配置虚拟机

```bash
cd '/etc/yum.repos.d'
wget -O ./CentOS-Base-DVDISO.repo  http://$rip/files/centos7/repofiles/local.repo
yum makecache
```
