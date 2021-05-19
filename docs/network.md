<link rel="stylesheet" href="https://zhmhbest.gitee.io/hellomathematics/style/index.css">
<script src="https://zhmhbest.gitee.io/hellomathematics/style/index.js"></script>

# [Network](./index.html)

[TOC]

## 配置网络

### 图形化配置

```bash
nmtui
```

### 临时配置

```bash
ifconfig <网卡名称[:0]> <ip> [netmask <mask>] # 临时添加
ifconfig <网卡名称[:0]> del <ip>              # 临时删除
```

### 文本配置

```bash
# 网卡配置文件
ls -l /etc/sysconfig/network-scripts/ifcfg-e*

# 修改网络配置
vi '/etc/sysconfig/network-scripts/ifcfg-eth0'
```

```conf
DEVICE=eth0
HWADDR=00:0C:29:A7:78:C2
TYPE=Ethernet
UUID=1608d33d-9cfe-4ea2-8594-85613be62510
ONBOOT=yes
BOOTPROTO=none
IPADDR=192.168.12.167
PREFIX=24
GATEWAY=192.168.12.1
DNS1=8.8.8.8
```

```bash
# CentOS-6
service network restart

# CentOS-7
systemctl restart network
```

### 查看网络

```bash
# DNS服务器
cat /etc/resolv.conf

# HOST解析
cat /etc/hosts

# 主机名
cat /etc/hostname
hostname -f
uname -n

# 查看网络配置
ifconfig -a

# 查看当前IP
ifconfig -a | grep 'inet'
```

## 防火墙

```bash
# systemctl {status | stop | start | disable | enable} firewalld.service

# 防火墙-状态
firewall-cmd --state

# #防火墙-所有支持的服务
firewall-cmd --get-service

# 防火墙-活动网口（网卡）
firewall-cmd --get-active-zones

# 列出规则
firewall-cmd --list-all
firewall-cmd --permanent --zone=public --list-all
firewall-cmd --permanent --zone=public --list-services
firewall-cmd --permanent --zone=public --list-ports

# 查看规则
firewall-cmd --permanent --query-service=http   # 查询服务是否开放
firewall-cmd --permanent --query-port=3306/tcp  # 查询端口是否开放

# 添加规则
firewall-cmd --permanent --zone=public --add-service=ftp            # 指定服务
firewall-cmd --permanent --zone=public --add-port=3306/tcp          # 指定单个端口
firewall-cmd --permanent --zone=public --add-port=40000-40010/tcp   # 指定端口范围
firewall-cmd --reload

# 删除规则
firewall-cmd --permanent --zone=public --remove-port=8080/tcp
firewall-cmd --permanent --zone=public --remove-service=https
firewall-cmd --reload
```

## 网络状态

```bash
# -i  网卡信息
#     状态：ESTABLISHED
# -a  状态：ALL
# -l  状态：LISTEN
# -t  TCP连接
# -u  UDP连接
# -n  禁用反向域名解析
# -p  查看进程信息

# 查看网卡信息
netstat -i

# 状态：ESTABLISHED
netstat -tunp

# 状态：LISTEN
netstat -tunlp

# 状态：ALL
netstat -tunap
```

## PING

```bash
# 临时禁止
echo 1>/proc/sys/net/ipv4/icmp_echo_ignore_all
# 临时启用
echo 0>/proc/sys/net/ipv4/icmp_echo_ignore_all

# 永久禁止
changeConfig /etc/sysctl.conf net.ipv4.icmp_echo_ignore_all = 1
sysctl -p

# 永久启动
changeConfig /etc/sysctl.conf net.ipv4.icmp_echo_ignore_all = 0
sysctl -p
```
