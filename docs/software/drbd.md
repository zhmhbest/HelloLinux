
>**Distributed Replicated Block Device(DRBD)是**一个用软件实现的、无共享的、服务器之间镜像块设备内容的存储复制解决方案。其与RAID1的主要区别在于，前者使用RAID控制器接入到一台主机上，而DRBD是通过网络实现不同节点主机存储设备数据的镜像备份。

![drbd](./images/drbd.png)

### 安装

|版本|包|内核模块|
|:-:|:-:|:-:|
|8.0|drbd-8.0|kmod-drbd-8.0|
|8.2|drbd82|kmod-drbd82|
|8.3|drbd83|kmod-drbd83|
|8.4|drbd84|kmod-drbd84|

```bash
# 查看内核版本（要求大于2.6.33）
uname -r

# 安装DRDB@Centos5（版本小于内核要求）
https://vault.centos.org/5.8/extras/x86_64/RPMS/
# 下载 drbd 、kmod-drbd

# 安装DRDB@Centos6
# rpm -ivh http://www.elrepo.org/elrepo-release-6-6.el6.elrepo.noarch.rpm
yum -y install https://www.elrepo.org/elrepo-release-6.el6.elrepo.noarch.rpm
yum -y install drbd83-utils kmod-drbd83
rpm -q drbd83-utils

# 安装DRDB@Centos7
yum -y install https://www.elrepo.org/elrepo-release-7.el7.elrepo.noarch.rpm
yum -y install drbd84-utils kmod-drbd84
rpm -q drbd84-utils
```

### 配置主从模式

#### 关闭防火墙

```bash
systemctl disable firewalld.service
systemctl stop firewalld.service
firewall-cmd --state
```

#### 配置域名

```bash
# hostnamectl set-hostname 'drdb.primary'
# hostnamectl set-hostname 'drdb.secondary'
vim /etc/hosts
```

```txt
192.168.12.201  drdb.primary
192.168.12.205  drdb.secondary
```

```bash
ping -c 3 drdb.primary
ping -c 3 drdb.secondary
hostname -f
```

#### 同步时钟

```bash
yum -y install ntpdate

# 同步
ntpdate -u asia.pool.ntp.org

# 查看时间
date "+%Y-%m-%d %H:%M:%S"
```

#### 加载模块

```bash
modprobe drbd
lsmod | grep '^drbd'
```

#### 配置新磁盘

为每台机器新增1块硬盘

```bash
# 格式化新硬盘
fdisk /dev/sdb
# n、p、<enter>、<enter>、<enter>、w

# 查看分区
ls /dev/sd*
fdisk -l | grep '^/dev'

# mknod 设备名称 { b | c | p } 主设备号（设备种类） 从设备号（唯一性）
mknod /dev/drbd0 b 147 0
```

#### 配置DRBD

```bash
cat /etc/drbd.conf
```

```conf
include "drbd.d/global_common.conf";
include "drbd.d/*.res";
```

```bash
# 备份默认配置
cp /etc/drbd.d/global_common.conf /etc/drbd.d/global_common.conf.bak

# 编辑配置
vim /etc/drbd.d/global_common.conf
#gg dG
```

```conf
global {
    usage-count yes;
}
common {
    protocol C;
    handlers {
    }
    startup {
        wfc-timeout          240;
        degr-wfc-timeout     240;
        outdated-wfc-timeout 240;
    }
    disk {
        on-io-error detach;
    }
    net {
        cram-hmac-alg md5;
        shared-secret "testdrbd";
    }
    syncer {
        rate 30M;
    }
}
```

```bash
# 编辑磁盘配置
vim /etc/drbd.d/r0.res
```

```conf
resource r0 {
    on drdb.primary {
        device     /dev/drbd0;          # DRBD虚拟块设备（事先不要格式化）
        disk       /dev/sdb1;
        address    192.168.12.201:7898; # DRBD监听的地址和端口（端口可自定义）
        meta-disk  internal;
    }
    on drdb.secondary {
        device     /dev/drbd0;
        disk       /dev/sdb1;
        address    192.168.12.205:7898;
        meta-disk  internal;
    }
}
```

#### 管理DRBD

```bash
# 初始化（都需要）
drbdadm create-md r0
# New drbd meta data block successfully created.

# 启动/关闭（都需要）
drbdadm up r0
drbdadm down r0
drbdadm status r0
# cat /proc/drbd

# 设置主节点（仅在Primary执行）
drbdsetup /dev/drbd0 primary --force

# 设置从节点（仅在Secondary执行）
drbdsetup /dev/drbd0 secondary
```

#### 挂载DRBD

```bash
# 格式化分区（仅在Primary执行）
mkfs.ext4 /dev/drbd0

# 挂载分区（仅在Primary执行）
mkdir /data
mount /dev/drbd0 /data
df -h
```

#### 测试备份

```bash
# 模拟写入（仅在Primary执行）
echo 'Hello'>'/data/Hello.txt'

# 模拟宕机（仅在Primary执行）
umount /data
df -h
drbdsetup /dev/drbd0 secondary

# 从节点提权（仅在Secondary执行）
drbdsetup /dev/drbd0 primary

# 挂载分区（仅在Secondary执行）
mkdir /data
mount /dev/drbd0 /data
```
