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

```bash
# 需要NetworkManager服务支持
nmtui
nmtui edit
nmtui connect
nmtui hostname
```

### 文本配置

#### CentOS文本配置

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

#### Ubuntu文本配置

```bash
ll /etc/netplan/

# sudo vim /etc/netplan/00-installer-config.yaml
# sudo vim /etc/netplan/50-cloud-init.yaml
sudo vim /etc/netplan/*.yaml
```

```yaml
network:
    version: 2
    ethernets:
        ens33:
            dhcp4: true
```

```yaml
network:
    version: 2
    ethernets:
        eth0:
            optional: true
            dhcp4: no
            addresses: [192.168.1.100/24]
            gateway4: 192.168.1.1
            nameservers:
                addresses: [8.8.8.8]
            # match:
            #     macaddress: AA:BB:CC:DD:EE:FF
    wifis:
        wlan0:
            optional: true
            dhcp4: true
            access-points:
                "要连接的WIFI的SSID":
                    password: "要连接的WIFI的PASSWORD"
```

```bash
# 应用网络配置
sudo netplan apply
```

### HostName

```bash
# 获取主机名
cat /etc/hostname
hostname
uname -n

# 设置主机名
hostnamectl set-hostname ${NewHostName}
```

### Gateway

```bash
# 查看网关
route -n

# 添加网关
route add default gw ${Gateway}
```

### DNS

```bash
# DNS服务器
cat /etc/resolv.conf

# HOST解析
cat /etc/hosts
```

## 查看网络

### 网络地址

```bash
hostname -I

ip a | awk '{if("inet"==$1) {print $2}}'

ifconfig | awk '{if("inet"==$1) {print $2}}'
```

### 网络状态

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

### 网卡

```bash
ifconfig

ip addr
ip a

ip link show
ip link
ip l

nmcli device show | grep 'DEVICE'
nmcli connection show
nmcli con show
nmcli c s

# 开/关网卡
ifup eth0
ifdown eth0
```

## 防火墙

### CentOS防火墙

```bash
# systemctl {status | stop | start | disable | enable} firewalld
systemctl status firewalld

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

### Ubuntu防火墙

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
# sudo ufw {allow | deny} [{in | out}]
#       [on <网卡>]
#       [from {any | <IP>} [port <端口>]]
#       [to {any | <IP>} [port <端口>]]
#       [proto {tcp | udp}]
sudo ufw allow in on ens33 from any to any port 80
sudo ufw allow in on ens33 to any port 80
sudo ufw allow to any port 20,21,40000:40010 proto tcp
sudo ufw deny in from 192.168.1.99
sudo ufw deny in to any port 8080

# 当前策略
sudo ufw status verbose

# 重置所有规则
sudo ufw reset
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

# 查看网卡TYPE
nmcli

# 测试添加虚拟网卡
ip link add link ens32 dev vlan0 index 3 type macvlan
ip addr add 192.168.12.188/24 dev vlan0
ip link set vlan0 up
ip addr
ip link delete vlan0
```

## 无线网络

```bash
# 查看是否有无线网卡
ip a|grep wlan>/dev/null && echo OK || echo None
# OK
```

### 工作模式

- managed/station: 可以连接AP（从模式）
- ap: 无线热点（主模式）
- ibss/adhoc: 每个节点的对等的无线网络
- monitor: 所有数据包无过滤地传输到主机
- mesh: 动态建立路由，节点同时作为AP和路由器
- wds: 用于延伸扩展无线信号

### Ubuntu无线网络

#### 虚拟无线网卡

```bash
# 必备软件
sudo apt install wireless-tools

# 查看网卡模式
iwconfig wlan0

# 设置网卡模式
sudo iwconfig wlan0 mode monitor

# 创建虚拟无线网卡
# iw {dev <devname> | phy <phyname>}
#       interface add <name>
#       type <managed | ibss | monitor | mesh | wds>
#       [mesh_id <meshid>]
#       [4addr on|off]
#       [addr <mac-addr>]
sudo ip link set wlan0 down
sudo iw dev wlan0 interface add wlan0v0 type station
```

#### 连接WIFI

详见[Ubuntu文本配置](#ubuntu文本配置)

#### AP模式

```bash
# 必备软件
sudo apt install hostapd

# 待补充
```

#### RaspberryPi创建AP

```bash
# 安装依赖软件
sudo apt install make
sudo apt-get install util-linux procps hostapd iproute2 iw haveged dnsmasq

# 安装create_ap
sudo mkdir /usr/applications
cd /usr/applications
sudo git clone https://github.com/oblique/create_ap.git
cd create_ap/
sudo make install
# make uninstall

# 测试安装
create_ap --version

# 测试运行
# create_ap [options] WIFI设备 网络设备 SSID PASSWORD
sudo create_ap --no-virt wlan0 eth0 RaspberryPi 88zhmh99

# 编辑服务
vim /usr/lib/systemd/system/create_ap.service

# 服务管理
systemctl start create_ap
systemctl enable create_ap
systemctl status create_ap
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
