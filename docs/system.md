<link rel="stylesheet" href="https://zhmhbest.gitee.io/hellomathematics/style/index.css">
<script src="https://zhmhbest.gitee.io/hellomathematics/style/index.js"></script>

# [System](./index.html)

[TOC]

## 系统信息

```bash
# 查看CPU信息
grep 'model name' /proc/cpuinfo

# 内存信息
grep 'MemTotal' /proc/meminfo

# 交换区信息
grep 'SwapTotal' /proc/meminfo

# Linux内核版本
uname -rm

# 硬盘使用量
df -h

# 查看CPU负载
uptime

# 连接的终端数量
who
```

## SSH免密登录

```bash
ssh-keygen -t rsa -P '' -f ~/.ssh/id_rsa
cd ~/.ssh; ll
# -rw------- 1 root root 1679 * id_rsa
# -rw-r--r-- 1 root root  408 * id_rsa.pub
# id_rsa     : 私钥（个人本地持有）
# id_rsa.pub : 公钥（远程主机持有）
cp ./id_rsa.pub ./authorized_keys
# ssh -l root -i <私钥> <地址>
```

## 开机操作

### 开机挂载

```bash
# 修改开机自动挂载的分区
vi /etc/fstab
# 设备（UUID或标识目录） 挂载点 文件系统 defaults 0 0
# /dev/mapper/centos-root                     /       xfs     defaults        1 1
# UUID=0cdfa058-efe2-40fb-81c6-7438cb01a747   /boot   xfs     defaults        1 2
# /dev/mapper/centos-home                     /home   xfs     defaults        1 2
# /dev/mapper/centos-swap                     swap    swap    defaults        0 0
```

### 开机运行

```bash
# 添加开机时自动运行的命令（也可启动服务）
vi '/etc/rc.d/rc.local'
chmod 744 '/etc/rc.d/rc.local'

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
```

```bash
# 查看启动级别
runlevel
# N 3
sudo systemctl get-default
# multi-user.target
```

```bash
# 系统启动级别
init --help
# 0              关机
# 6              重新启动
# 2, 3, 4        多用户命令行模式
# 5              多用户GUI模式
# 1, s, S        单用户救援模式
# q, Q           Reload init daemon configuration
# u, U           Reexecute init daemon

# 修改启动级别
# CentOS-7不再使用'/etc/inittab'设置默认启动级别
# ls -l  /lib/systemd/system/*.target
# runlevel0.target -> poweroff.target
# runlevel1.target -> rescue.target
# runlevel2.target -> multi-user.target
# runlevel3.target -> multi-user.target
# runlevel4.target -> multi-user.target
# runlevel5.target -> graphical.target
# runlevel6.target -> reboot.target
sudo systemctl set-default multi-user.target # init 3
sudo systemctl set-default graphical.target  # init 5
```

## 用户管理

```bash
# 查看ID分配规则
egrep -v "^$|^#" /etc/login.defs

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
cp /etc/skel/.bash* ~/
chown -R `whoami`:`whoami` ~/.bash*
```

## 时间

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

## 进程管理

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

# screen（无关前台）
yum -y install screen
screen -ls              # 查看会话
screen -S SessionName   # 创建新会话
# Ctrl + A + D           # 分离当前会话放到后台
screen -d SessionName   # 分离会话
screen -r SessionName   # 重新连接会话（用会话名称）
screen -r SessionID     # 重新连接会话（用会话ID）

# nohup（无关前台）
nohup 启动文件 > 日志文件.log 2>&1 &
jobs
```

## FileSystem

```bash
# 查看磁盘UUID和文件系统
blkid

# 查看磁盘UUID
ls -l /dev/disk/by-uuid
```

```bash
# 查看目录占用空间大小
du -sh /etc

# 查看所有分区使用情况
df -h
```

```bash
# 磁盘管理（交互式）
dd if=/dev/zero of=vdisk.img bs=1M count=128
fdisk ./vdisk.img
# n(创建分区) p(主分区) ... w(保存)
# q(退出)

# 创建文件、格式化虚拟盘、挂载虚拟盘
dd if=/dev/zero of=vdisk.img bs=1M count=128
mkfs -t xfs ./vdisk.img
mkdir vmount; mount vdisk.img vmount/
pushd vmount/; touch hello; popd
umount vmount/; ll vmount/
```