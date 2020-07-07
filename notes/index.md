<link rel="stylesheet" href="https://zhmhbest.gitee.io/hellomathematics/style/index.css">
<script src="https://zhmhbest.gitee.io/hellomathematics/style/index.js"></script>

# Linux

[TOC]

## Images

- [Download CentOS](https://www.centos.org/download/)
- [Download Deepin](https://www.deepin.org/download/)
- [Download Ubuntu](https://www.ubuntu.com)
- [Download Mint](https://www.linuxmint.com/download.php)

## Ready

- [Download VMware Workstation Pro 15](https://my.vmware.com/en/web/vmware/info/slug/desktop_end_user_computing/vmware_workstation_pro/15_0)
- [Download Nginx](http://nginx.org/en/download.html)
- [Download FileZilla Client](https://filezilla-project.org/download.php?type=client)
- [Download MobaXterm](https://mobaxterm.mobatek.net/download-home-edition.html)
<!-- - [Putty](https://putty.org/) -->
- [在VM上安装CentOS7](./ready/INSTALL_CENTOS7_ON_VM.html)
<!-- - [推荐网课](https://ke.qq.com/course/138272) -->

## System

### 开机启动

#### 开机挂载

```bash
# 修改开机自动挂载的分区
vi /etc/fstab
# 设备（UUID或标识目录等） 挂载点 文件系统 defaults 0 0
```

#### 开机运行

```bash
# 添加开机时自动运行的命令（也可启动服务）
chmod 744 '/etc/rc.d/rc.local'; vi '/etc/rc.d/rc.local'
# 禁用
# chmod 644 '/etc/rc.d/rc.local'
```

### 系统状态

```bash
# 系统状态控制
shutdown -r now     # 重启 = reboot
shutdown -h now     # 关机 = poweroff
shutdown -h +10     # Type1: 10分钟后关机
shutdown -h 23:30   # Type2: 定时关机
```

```bash
# 查看启动级别
runlevel
sudo systemctl get-default

# 系统启动级别
init 0 # 关机状态
init 1 # 单用户模式（禁止远程登录）
init 2 # 多用户模式（无NFS和网络）
init 3 # 多用户模式（服务器推荐）
init 4 # 保留
init 5 # GUI模式
init 6 # 重新启动

# 修改启动级别
# CentOS-7不再使用'/etc/inittab'设置默认启动级别
sudo systemctl set-default multi-user.target # init 3
sudo systemctl set-default graphical.target  # init 5
```

### 用户管理

```bash
# 查看ID分配规则
egrep -v "^$|^#" /etc/login.defs #过滤#开头和空行

# 新建用户
# useradd [-d <家目录> | -M] [-u <用户ID>] [-g <主组(已存在)>] [-G <附加组>[,...]] [-s /bin/bash] <用户名>
# -M: 没有家目录
useradd <用户名>
tail -2 /etc/passwd

# 查看用户ID
id <用户名>

# 删除用户和家目录
userdel -r <用户名>

# 查看密码（HASH值）
head -5 /etc/shadow

# 更改用户密码（2选1）
passwd <用户名>
echo <密码> | passwd --stdin <用户名>

# 更改用户信息
usermod [-md <家目录> | -M] [-u <用户ID>] [-g <主组(已存在)>] [-G <附加组>[,...]] [-s /bin/bash] <用户名>
# -md 移动家目录
# -M 没有家目录

# 修复用户bash信息不完整
ll /etc/skel/.bash*
ll ~/.bash*
cp /etc/skel/.bash* ~/
chown -R `whoami`:`whoami` ~/.bash*
```

### 时间

```bash
# 查看当前系统时间
hwclock
date
# UTC: 世界标准时间
# GMT: 格林尼治时间
# CST: 中国标准时间

# 格式化时间
date "+%Y-%m-%d %H:%M:%S"                # 格式化显示当前时间
date -d "1996-10-16 12:33:23"            # Type1: 显示字符串所描述的时间
date -d "-2 months"                      # Type2: 显示字符串所描述的时间
date -d "-2 months" "+%Y-%m-%d %H:%M:%S" # Type3: 显示字符串所描述的时间

# 修改时间
date -s "1996-10-16 12:33:23"           # 设为字符串所描述的时间
```

## Package

### tar

```bash
# 打包文件
tar [--exclude <文件>] -cvf  <包名.tar>     <打包文件> # 新建包
tar [--exclude <文件>] -zcvf <包名.tar.gz>  <打包文件> # 新建包并压缩
tar [--exclude <文件>] -jcvf <包名.tar.bz2> <打包文件> # 新建包并压缩（推荐）
```

```bash
# 查看包内文件
tar -tvf  <包.tar>
```

```bash
# 展开包
tar -xvf  <包名.tar>      [-C <展开目录>]
tar -zxvf <包名.tar.gz>   [-C <展开目录>]
tar -jxvf <包名.tar.bz2>  [-C <展开目录>]
```

### rpm

```bash
# 挂载DVD-ISO文件
if [ ! -d /mnt/cd ]; then mkdir /mnt/cd; fi
mount /dev/cdrom /mnt/cd; cd /mnt/cd/Packages
ll bash-*

# 卸载DVD-ISO文件
cd ~/; umount /dev/cdrom
```

| 包名 | 软件名 | 版本号 | 发行号 | 支持系统 | 系统架构 |
| :-: | :-: | :-: | :-: | :-: | :-: |
| bash-4.2.46-31.el7.x86_64 | bash | 4.2.46 | 31 | el7 | x86_64 |

```bash
rpm [options...]
```

| 指令 | 作用 |
| :-: | :- |
| -i | 安装 |
| -U | 升级 |
| -e | 卸载 |
| -q | 查询 |
| -V | 验证 |
| -a | 查询/验证所有软件包 |
| -f | 查询/验证文件属于的软件包 |
| -p | 查询/验证一个软件包 |
| -h | 安装时列出哈希标记 |
| -v | 输出详细信息 |
| --nodeps | 不验证依赖 |

```bash
# rpm校验缓存目录
ll /var/lib/rpm

# 安装或升级本地软件包
rpm -ivh <包名.rpm> # 安装
rpm -Uvh <包名.rpm> # 升级

# 卸载包
rpm -e <软件名>            # 此处不需要包名
rpm -e --nodeps <软件名>   # 不建议使用此命令卸载含有依赖关系的包
```

```bash
# 查询软件包的详细信息
rpm -qpi <包名.rpm>

# 查看软件包会安装哪些文件
rpm -qpl <包名.rpm>
```

```bash
# 查询文件所属的包
rpm -qf /usr/bin/bash

# 查看文件是否与包内内容一致
rpm -Vf /usr/bin/bash   # 什么都没有输出则没有被修改
rpm -Va                 # 检查所有已安装包
```

```bash
# 查询所有已安装软件
rpm -qa

# 查询已安装软件
rpm -q openssh-server

# 查询已安装软件所属包的详细信息
rpm -qi openssh-server
```

### yum

```bash
# 增加aliyun源
wget -O /etc/yum.repos.d/aliyun_epel7.repo http://mirrors.aliyun.com/repo/epel-7.repo
ll /etc/yum.repos.d/

# 重新根据源生成缓存
yum clean all; yum makecache

# 列出源所包含的所有软件包
yum list
```

```bash
# 安装/升级/卸载
yum -y install <软件名>
yum -y update  <软件名>  # 升级并改变配置文件（有可能改变内核）
yum -y upgrade <软件名>  # 仅升级二进制文件
yum -y remove  <软件名>
```

## Network

### 配置网络

```bash
# 图形化配置
nmtui
```

```bash
# 查看已有网卡
ifconfig -a | grep 'ens' | sed 's/:.*$//'

# 查看当前IP
ifconfig -a | grep 'inet '

# 网卡配置文件
ls -l /etc/sysconfig/network-scripts/ifcfg-* 
```

```bash
# 临时修改IP
ifconfig <网卡名称[:0]> <ip> [netmask <mask>] # 临时添加
ifconfig <网卡名称[:0]> del <ip>              # 临时删除

# DNS服务器
cat /etc/resolv.conf

# HOST解析
cat /etc/hosts

# 主机名
cat /etc/hostname
```

### 防火墙

```bash
# systemctl {status | stop | start | disable | enable} firewalld.service

# 防火墙-状态
firewall-cmd --state

# #防火墙-所有支持的服务
firewall-cmd --get-service

# 防火墙-活动网口（网卡）
firewall-cmd --get-active-zones

# 查看规则
firewall-cmd --list-all
firewall-cmd --permanent --zone=public --list-all
firewall-cmd --permanent --zone=public --list-services
firewall-cmd --permanent --zone=public --list-ports

# 添加规则
firewall-cmd --permanent --zone=public --add-service=ftp
firewall-cmd --permanent --zone=public --add-port=40000-40010/tcp
firewall-cmd --reload

# 删除规则
firewall-cmd --permanent --zone=public --remove-port=8080/tcp
firewall-cmd --permanent --zone=public --remove-service=https
firewall-cmd --reload
```

## Process

### CPU信息

```bash
# 查看CPU信息
cat /proc/cpuinfo
# 查看CPU负载
uptime
```

### 进程管理

```bash
# 查看进程快照
ps -auf
ps -ef
ps -aux

# 实时查看进程
top
top -p <pid> # 盯住一个进程

# 关闭进程
kill -l # 列出可用信号
kill -9 <pid>
killall <pid>
pkill <进程名>

# 进程优先级
nice -n 5 bash  # 以优先级5打开一个新bash
renice 10 <pid> # 修改进程优先级
```

### 后台进程

```bash
# 后台进程（前台关联）
bash&        # 运行一个后台进程
jobs         # 查看后台进程
fg <JOBNUM>  # 后台进程放到前台
bg <JOBNUM>  # 前台进程放到后台
# Ctrl + Z   # 当前运行进程放到后台

# 后台进程（无关前台）
# yum -y install screen
screen -ls              # 查看会话
screen -S SessionName   # 创建新会话
# Ctrl + A + D           # 分离当前会话放到后台
screen -d SessionName   # 分离会话
screen -r SessionName   # 重新连接会话（用会话名称）
screen -r SessionID     # 重新连接会话（用会话ID）
```

## FileSystem

### NTFS

```bash
# 增加NTFS支持（需要增加Aliyun源）
yum -y install fuse-ntfs-3g
```

### UUID

```bash
# 查看磁盘UUID和文件系统
blkid

# 查看磁盘UUID
ls -l /dev/disk/by-uuid
```

### Directory

```bash
# 查看目录大小
du -sh /etc

# 列出文件
ls -l
ll
```

### Disk

```bash
mkdir /tmp/filesystem; cd /tmp/filesystem

# 磁盘管理（交互式）
dd if=/dev/zero of=vdisk.img bs=1M count=500
fdisk ./vdisk.img
#q: 退出

# 创建文件、格式化虚拟盘、挂载虚拟盘
dd if=/dev/zero of=vdisk.img bs=1M count=500
mkfs -t xfs ./vdisk.img
mkdir vmount; mount vdisk.img vmount/; cd vmount/

touch file{0..10} #创建file0~file10
touch -d "20181019 21:30" filename; ll  filename #指定创建时间
mkdir -p ./a/b/c  #创建目录，必要时同时创建父目录
mkdir -p ./1/2/3  #创建目录，必要时同时创建父目录
chmod -R 700  ./a #同时修改子目录及文件权限
```