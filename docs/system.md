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
uname -r

# 硬盘使用量
df -h

# 目录存储使用量
du -h --max-depth=1 /root

# 查看CPU负载
uptime

# 连接的终端数量
who
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

#### CentOS

```bash
# 添加开机时自动运行的命令（也可启动服务）
chmod +x '/etc/rc.d/rc.local'
vi '/etc/rc.d/rc.local'
```

#### Ubuntu

```bash
sudo sh -c 'echo "#!/bin/sh">/etc/rc.local'
sudo sh -c 'echo "touch /__startup__">>/etc/rc.local'
sudo chmod +x /etc/rc.local

# 测试启动
sudo systemctl start rc-local
ll '/__startup__' && sudo rm '/__startup__'
sudo systemctl stop rc-local

# 开机启动脚本
sudo systemctl enable rc-local
sudo systemctl status rc-local

# 编辑启动脚本
vi '/etc/rc.local'
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

## 进程管理

### 进程ID

- **PID（Process ID）**：标识Process的唯一数字。在Process退出并被父Process检索到之后，该ID可以释放给新的Process重用。

- **PPID（Parent Process ID）**：启动相关Process的Process的PID。

- **PGID（Process Group ID）**：若`PID == PGID`，则此Process是*Group Leader*。

- **SID（Session ID）**：若`PID == SID`，则此Process为*Session Leader*。

### 进程快照

```bash
# 查看进程快照
# a      显示（与终端相关）的所有进程
# x      显示（与终端无关）的所有进程
# T      显示（当前终端）的所有进程
# u      显示USER、%CPU、%MEM、VSZ、RSS、START
# e      显示每个进程使用的环境变量
# f      以树状结构显示COMMAND
ps au
ps aux

# -A     显示所有进程
# -e     显示所有进程
# -a     显示所有（与终端相关且不是Session Leader）的进程
# -d     显示所有（不是Session Leader）的进程
# -f     显示UID、PPIP、CMD-OPTIONS
# -l     显示比-f更详细的信息
# -H     以树状结构显示COMMAND
ps -ef
```

```bash
# 实时查看进程
top
top -p <pid> # 盯住一个进程
```

### 进程信号

```bash
# 关闭进程
kill -l # 列出可用信号
kill -9 <pid>
killall <pid>
pkill <进程名>
```

### 进程优先级

```bash
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

## 文件系统

### 磁盘

```bash
# 查看磁盘UUID和文件系统
blkid

# 查看磁盘UUID
ls -l /dev/disk/by-uuid

# 生成新的UUID
uuidgen
```

```bash
# 查看目录占用空间大小
du -sh /etc

# 查看所有分区使用情况
df -h
```

### 卷管理

```bash
# 物理卷(PV)
pvs

# 逻辑卷(LV)
lvs

# 卷组(VG)
vgs
```

### 连接

```bash
# 软连接
ln –s <source> <link>
# mklink /j <link> <source>

# 建立硬连接
ln <source> <link>
```

### 虚拟磁盘

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

### NTFS

#### 修复文件系统错误

```bash
# The disk contains an unclean file system (?, ?).
# The file system wasn't safely closed on Windows. Fixing.
ntfsfix /dev/sda1
```
