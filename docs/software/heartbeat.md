
>Heartbeat包括两个核心部分，**心跳监测**和**资源接管**，心跳监测通过网络链路和串口进行，主机之间相互发送报文来告诉对方自己当前的状态，如果在指定的时间内未收到对方发送的报文，就启动资源接管模块来接管运行在对方主机上的资源或者服务。

### 编译安装

```bash
groupadd haclient
useradd -g haclient hacluster -M -s /sbin/nologin
id hacluster
```

- [源码下载](http://www.linux-ha.org/wiki/Downloads)

```bash
yum -y groupinstall 'Development Tools'
yum -y install libgcrypt-devel libxslt libxslt-devel bzip2-devel libtool-ltdl-devel glib2-devel asciidoc

# Pacemaker
# yum -y install pacemaker corosync

# Cluster Glue
pushd ./Reusable-Cluster-Components-glue-*
./autogen.sh
./configure LIBS='/lib64/libuuid.so.1'
make -j 8
make install
popd

# Resource Agents
pushd ./resource-agents-*
./autogen.sh
./configure LIBS='/lib64/libuuid.so.1'
make -j 8
make install
popd

# Heartbeat
pushd ./Heartbeat-*
./ConfigureMe configure LIBS='/lib64/libuuid.so.1'
make -j 8
make install
popd
```

#### 配置Heartbeat

```bash
# 拷贝配置模板
cp /usr/share/doc/heartbeat/* /etc/ha.d/

# 配置认证方式
vim /etc/ha.d/authkeys
```

```conf
auth 1
1 md5 123456
# crc | md5 | sha1
```

```bash
# 配置节点
vim /etc/ha.d/ha.cf
```

```conf
keepalive 2             # 心跳频率（单位秒）
warntime 5              # 告警时间（单位秒）
deadtime 10             # 无响应判定死亡时间（单位秒）
auto_failback on        # 主节点复活将主动抢占资源
bcast   ens32           # 指明在eth0接口上使用以太网广播心跳
node    drdb.primary    # 主节点主机名（`uanme -n`）
node    drdb.secondary  # 从节点主机名（`uanme -n`）
```

```bash
# 配置资源
vim /etc/ha.d/haresources
```

```conf
drdb.primary    IPaddr::192.168.12.201/24/ens32:0     drbddisk::r0    Filesystem::/dev/drbd0::/data::ext4
drdb.secondary    IPaddr::192.168.12.205/24/ens32:0     drbddisk::r0    Filesystem::/dev/drbd0::/data::ext4
```

```bash
# systemctl status heartbeat
# service heartbeat status
/etc/init.d/heartbeat start
/etc/init.d/heartbeat status
```
