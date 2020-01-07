# HelloLinux

- [Download CentOS](https://www.centos.org/download/)
- [Download Deepin](https://www.deepin.org/download/)
- [Download Ubuntu](https://www.ubuntu.com)
- [Download Mint](https://www.linuxmint.com/download.php)
- [辅助工具](./AUXILIARY_TOOLS.md)
- [安装虚拟机](./INSTALL_CENTOS7_ON_VM.md)

## 开机启动

```bash
# 修改开机自动挂载的分区
vi /etc/fstab
# 设备（UUID或标识目录等） 挂载点 文件系统 defaults 0 0

# 添加开机时自动运行的命令（也可启动服务）
chmod 744 '/etc/rc.d/rc.local'; vi '/etc/rc.d/rc.local'
# 禁用
# chmod 644 '/etc/rc.d/rc.local'
```

## 系统状态

```bash
# 系统状态控制
shutdown -r now     # 重启 = reboot
shutdown -h now     # 关机 = poweroff
shutdown -h +10     # Type1: 10分钟后关机
shutdown -h 23:30   # Type2: 定时关机

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

## 配置网络

```bash
# 图形化配置IP
nmtui

# 临时修改IP
ifconfig 网卡名称[:0] <ip> [netmask <mask>] #临时添加
ifconfig 网卡名称[:0] del <ip>              #临时删除

# 查看已有网卡
ls -l /etc/sysconfig/network-scripts/ifcfg-*

# DNS服务器
cat /etc/resolv.conf

# HOST解析
cat /etc/hosts

# 主机名
cat /etc/hostname
```

## 防火墙

```bash
# systemctl status | stop | start | disable | enable firewalld.service

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

## 文件系统

```bash
# 增加NTFS支持
wget -O /etc/yum.repos.d/aliyun_epel7.repo http://mirrors.aliyun.com/repo/epel-7.repo
yum -y install fuse-ntfs-3g

# 查看磁盘UUID和文件系统
blkid

#查看磁盘UUID
ls -l /dev/disk/by-uuid
```

## 用户管理

```bash
# 查看ID分配规则
egrep -v "^$|^#" /etc/login.defs #过滤#开头和空行

# 新建用户
# useradd [-d 家目录 | -M] [-u 用户ID] [-g 初始组(已存在)] [-G 附加组1,附加组2] [-s /bin/bash] <用户名>
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
usermod [-md 家目录 | -M] [-u 用户ID] [-g 初始组(已存在)] [-G 附加组1,附加组2] [-s /bin/bash] 用户名
# -md 移动家目录
# -M 没有目录

# 修复用户bash信息不完整
ll /etc/skel/.bash*
ll ~/.bash*
cp /etc/skel/.bash* ~/
chown -R `whoami`:`whoami` ~/.bash*
```

## 进程管理

```bash
# 查看进程快照
# a: all tty processes
# e: all processes by PID
# u: 增加USER列
# f: 增加COMMAND列
ps -auf
ps -ef
ps -aux
ps -exuf

# 实时查看进程
top
top -p <进程ID> # 盯住一个进程

#查看CPU负载
uptime

# 关闭进程
kill -l # 列出可用信号
kill -9 <进程ID>
killall <进程ID>
pkill <进程名>

# 进程优先级
nice -n 5 bash # 以优先级5打开一个新bash
renice 10 <进程ID> # 修改进程优先级
```

## 包管理

```bash

```
