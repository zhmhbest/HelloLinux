
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
