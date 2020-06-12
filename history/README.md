# HelloLinux

>[推荐网课](https://ke.qq.com/course/138272)

## 镜像下载

- [Download CentOS](https://www.centos.org/download/)
- [Download Deepin](https://www.deepin.org/download/)
- [Download Ubuntu](https://www.ubuntu.com)
- [Download Mint](https://www.linuxmint.com/download.php)

## 其它

- [辅助工具](./AUXILIARY_TOOLS.md)
- [安装虚拟机](./INSTALL_CENTOS7_ON_VM.md)
- [进程管理（待补充）](./PROCESS.md)
- [文件系统（待补充）](./FILESYSTEM.md)

## 系统

### 开机启动

```bash
# 修改开机自动挂载的分区
vi /etc/fstab
# 设备（UUID或标识目录等） 挂载点 文件系统 defaults 0 0

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

## 包

### 软件包格式

| 包名 | 软件名 | 版本号 | 发行号 | 支持系统 | 系统架构 |
| :-: | :-: | :-: | :-: | :-: | :-: |
| bash-4.2.46-31.el7.x86_64 | bash | 4.2.46 | 31 | el7 | x86_64 |

### rpm

| 指令 | 作用 |
| :-: | :-: |
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

# 挂载DVD-ISO
if [ ! -d /mnt/cd ]; then mkdir /mnt/cd; fi
mount /dev/cdrom /mnt/cd
cd /mnt/cd/Packages

# 安装或升级本地软件包
rpm -ivh 包名.rpm #安装
rpm -Uvh 包名.rpm #升级

# 卸载包
rpm -e 软件名 #此处不需要包名
rpm -e --nodeps 软件名 #不建议使用rpm命令卸载含有依赖关系的包

# 查询已安装软件
rpm -q openssh-server
rpm -qa | grep openssh-server

# 查询已安装软件所属包的详细信息
rpm -qi openssh-server

# 查询软件包的详细信息
rpm -qpi /mnt/cd/Packages/openssh-server-7.4p1-21.el7.x86_64.rpm

# 查看软件包会安装哪些文件
rpm -qpl /mnt/cd/Packages/openssh-server-7.4p1-21.el7.x86_64.rpm

# 查询文件所属的包
rpm -qf /usr/bin/bash

# 查看文件是否与包内内容一致
rpm -Vf /usr/bin/bash #什么都没有输出则没有被修改
rpm -Va #检查所有已安装包
```

### yum

```bash
# 增加YUM源
wget -O /etc/yum.repos.d/aliyun_epel7.repo http://mirrors.aliyun.com/repo/epel-7.repo

# 重新根据源生成缓存
yum clean all
yum makecache

# 列出源所包含的所有软件包
yum list

# 安装/升级/卸载
yum -y install 软件名
yum -y update 软件名  #升级并改变配置文件（有可能改变内核）
yum -y upgrade 软件名 #仅升级二进制文件
yum -y remove 软件名
```

### tar

```bash
# 打包文件
tar [--exclude 文件] -cvf  包名.tar     打包文件 #新建包
tar [--exclude 文件] -zcvf 包名.tar.gz  打包文件 #新建包并压缩
tar [--exclude 文件] -jcvf 包名.tar.bz2 打包文件 #新建包并压缩（推荐）

# 查看包内文件
tar -tvf  包.tar

# 展开包
tar -xvf  包.tar     [-C 展开目录]
tar -zxvf 包.tar.gz  [-C 展开目录]
tar -jxvf 包.tar.bz2 [-C 展开目录]
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
date -d "-1 months"                      # Type2: 显示字符串所描述的时间
date -d "-1 months" "+%Y-%m-%d %H:%M:%S" # Type3: 显示字符串所描述的时间

# 修改时间
date -s "1996-10-16 12:33:23" #设为字符串所描述的时间
```