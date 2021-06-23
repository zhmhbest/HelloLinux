<link rel="stylesheet" href="https://zhmhbest.gitee.io/hellomathematics/style/index.css">
<script src="https://zhmhbest.gitee.io/hellomathematics/style/index.js"></script>

# [Network](./index.html)

[TOC]

## 配置网络

### 临时配置

```bash
# ifconfig <网卡名称> <ip> [netmask <mask>] # 临时添加
# ifconfig <网卡名称> del <ip>              # 临时删除

ifconfig eth0 192.168.1.100 netmask 255.255.255.0
ip addr add 192.168.1.100/24 dev eth0
```

### 图形化配置

#### CentOS

```bash
nmtui
```

### 文本配置

#### CentOS

```bash
# 网卡配置文件
ls -l /etc/sysconfig/network-scripts/ifcfg-e*

# 查看网卡配置
cat '/etc/sysconfig/network-scripts/ifcfg-eth0'
```

```ini
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
# 应用网络配置 CentOS-6
service network restart

# 应用网络配置 CentOS-7
systemctl restart network
```

#### Ubuntu

```bash
# 查看网卡配置
cat /etc/netplan/00-installer-config.yaml
```

```yaml
network:
    ethernets:
        ens33:
            dhcp4: true
    version: 2
```

```yaml
network:
    ethernets:
        ens33:
            dhcp4: no
            addresses: [192.168.1.100/24]
            optional: true
            gateway4: 192.168.1.1
            nameservers:
                addresses: [8.8.8.8]
    version: 2
```

```bash
# 应用网络配置
sudo netplan apply
```

### 查看网络

```bash
# DNS服务器
cat /etc/resolv.conf

# HOST解析
cat /etc/hosts

# 主机名
cat /etc/hostname
hostname
uname -n

# 查看网络配置
ifconfig -a

# 查看当前IP
ifconfig -a | grep 'inet' | awk '{print $2}'

# 查看网口
nmcli device show | grep 'DEVICE'
nmcli connection show
nmcli con show

# 查看网口物理信息
ip addr
ip a

# 查看网卡名称
ip a | grep '^[0-9]' | awk -F': ' '{print $2}'
```

## 防火墙

### CentOS

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

### Ubuntu

```bash
# sudo ufw {enable | disable | status}
echo y | sudo ufw enable
sudo ufw status

# 默认策略（允许所有出站、拒绝所有进站）
sudo ufw default allow outgoing
sudo ufw default deny incoming

# 基本配置
# sudo ufw allow <协议>
# sudo ufw allow <端口>
# sudo ufw allow <端口>/<协议>
sudo ufw allow ssh
sudo ufw allow http
sudo ufw allow https

# 高级配置
# sudo ufw {allow | deny} [{in | out}] [on <网卡>] [from <IP>] [to any port <端口>]
sudo ufw allow in on ens33 to any port 80
sudo ufw deny in from 192.168.1.99
sudo ufw deny in to any port 8080

# 当前策略
sudo ufw status verbose

# 重置所有规则
sudo ufw reset
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
# 查看是否可以被Ping
test 0 -eq `cat /proc/sys/net/ipv4/icmp_echo_ignore_all` && echo 'Ping: true' || echo 'Ping: false'

# 临时禁止
echo 1>/proc/sys/net/ipv4/icmp_echo_ignore_all
# 临时启用
echo 0>/proc/sys/net/ipv4/icmp_echo_ignore_all

# 永久禁止
changeConfig /etc/sysctl.conf net.ipv4.icmp_echo_ignore_all = 1
sysctl -p # 立即加载配置

# 永久启动
changeConfig /etc/sysctl.conf net.ipv4.icmp_echo_ignore_all = 0
sysctl -p # 立即加载配置
```

## 虚拟网卡

- vlan
- macvlan: 基于链路层地址（MAC）的虚拟接口
  - private: 同一主接口下的子接口之间彼此隔离，不能通信（即使从外部的物理交换机也不行）。
  - vepa(virtual ethernet port aggregator): 默认模式
  - bridge
  - passthru: 只允许单个子接口连接主接口，且网卡必须设置成混杂模式。
- macvtap: 基于链路层地址（MAC）和TAP的虚拟接口

```bash
# 网络空间
# ip netns {list | add <空间名称> | delete <空间名称>}
# ip netns exec <空间名称> <Command>

# 链路配置
# ip link add link <基于的物理网卡设备> [name | dev] <新虚拟设备名称> [index <序号>] type {vlan id <虚拟ID>| macvlan [mode {private | vepa | bridge | passthru}] | macvtap}
# ip link set <设备名称> {up | down}
# ip link set <设备名称> netns <空间名称>
# ip link delete <设备名称> [type {macvlan | macvtap}]

# 测试添加虚拟网卡
ip link add link ens32 dev vlan0 index 3 type macvlan
ip addr add 192.168.12.188/24 dev vlan0
ip link set vlan0 up
ip a
ip link delete vlan0
```

## 无线网络

### Ubuntu

```bash
# Wifi工具
sudo apt install wireless-tools
sudo apt install hostapd

# 查看无线网卡
iwconfig
```

## 服务管理

### CentOS6

```bash
chkconfig ${ServieName} on
chkconfig ${ServieName} off

service ${ServieName} start
service ${ServieName} restart
service ${ServieName} stop
```

### CentOS7/Ubuntu

```bash
systemctl enable  ${ServieName}
systemctl disable ${ServieName}

systemctl stop    ${ServieName}
systemctl start   ${ServieName}
systemctl restart ${ServieName}
systemctl stop    ${ServieName}

ll '/etc/systemd/system/'
ll '/usr/lib/systemd/system/'
# vim MyService
```

```ini
[Unit]
Description=MyService
Documentation=http://???/docs/
# 在哪些服务之后启动
After=network-online.target
# 在哪些服务之前启动
Before=
# 弱依赖（依赖的服务启动失败不影响本服务运行）
Wants=network-online.target
# 强依赖（依赖的服务启动失败本服务也会退出）
Requires=

[Service]
# 启动类型（simple、forking、oneshot、dbus、notify、idle）
Type=forking
PIDFile=/var/run/???.pid

# 自定义环境变量
EnvironmentFile=/???/???.env
Environment=var1=val1
Environment=var2=val2

# systemctl start MyService
ExecStart=Command
# systemctl restart MyService
ExecReload=Command
# systemctl stop MyService
ExecStop=Command

[Install]
# 服务所在服务组
WantedBy=multi-user.target
```
