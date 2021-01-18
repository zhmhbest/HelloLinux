<link rel="stylesheet" href="https://zhmhbest.gitee.io/hellomathematics/style/index.css">
<script src="https://zhmhbest.gitee.io/hellomathematics/style/index.js"></script>

# [Package](./index.html)

[TOC]

## Common

### tar

```bash
# 打包文件
tar [--exclude <文件>] -cvf  <包名.tar>     <打包文件> # 新建包
tar [--exclude <文件>] -zcvf <包名.tar.gz>  <打包文件> # 新建包并压缩
tar [--exclude <文件>] -jcvf <包名.tar.bz2> <打包文件> # 新建包并压缩（推荐）
```

```bash
# 查看包内文件
tar -tvf  <包.tar>
```

```bash
# 展开包
tar -xvf  <包名.tar>      [-C <展开目录>]
tar -zxvf <包名.tar.gz>   [-C <展开目录>]
tar -jxvf <包名.tar.bz2>  [-C <展开目录>]
```

### zip & unzip

`yum -y install zip unzip`
`apt-get install zip unzip`

```bash
# 压缩
zip -r <压缩包>.zip <待压缩文件路径>

# 解压
unzip [-d <解压到目录>] <压缩包>.zip
```

### 7zip

下载[7zip](https://sourceforge.net/projects/p7zip/files/p7zip/)


## ReadHat & CentOS

### rpm

```bash
# 挂载DVD-ISO文件
if [ ! -d /mnt/cd ]; then mkdir /mnt/cd; fi
mount /dev/cdrom /mnt/cd; cd /mnt/cd/Packages
ll bash-*

# 卸载DVD-ISO文件
cd ~/; umount /dev/cdrom
```

| 包名 | 软件名 | 版本号 | 发行号 | 支持系统 | 系统架构 |
| :-: | :-: | :-: | :-: | :-: | :-: |
| bash-4.2.46-31.el7.x86_64 | bash | 4.2.46 | 31 | el7 | x86_64 |

| `rpm`指令 | 作用 |
| :-: | :- |
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

# 安装或升级本地软件包
rpm -ivh <包名.rpm> # 安装
rpm -Uvh <包名.rpm> # 升级

# 卸载包
rpm -e <软件名>            # 此处不需要包名
rpm -e --nodeps <软件名>   # 不建议使用此命令卸载含有依赖关系的包
```

```bash
# 查询软件包的详细信息
rpm -qpi <包名.rpm>

# 查看软件包会安装哪些文件
rpm -qpl <包名.rpm>
```

```bash
# 查询文件所属的包
rpm -qf /usr/bin/bash

# 查看文件是否与包内内容一致
rpm -Vf /usr/bin/bash   # 什么都没有输出则没有被修改
rpm -Va                 # 检查所有已安装包
```

```bash
# 查询所有已安装软件
rpm -qa

# 查询已安装软件
rpm -q openssh-server

# 查询已安装软件所属包的详细信息
rpm -qi openssh-server
```

### yum

```bash
# 列出所有源
ll /etc/yum.repos.d/
yum repolist

# 重新根据源生成缓存
# all = packages metadata headers
yum clean all; yum makecache

# 列出已安装和源所包含的所有软件包
yum list

# 列出源所包含的所有未安装的软件包
yum list available

# 列出所有已安装的软件包
yum list installed

# 列出非通过源安装的软件包
yum list extras

# 列出源所包含的所有可更新的软件包
yum list updates
yum check-update

# 根据软件名搜索软件包
yum search <软件名>

# 查看提供软件的源
yum provides <软件名>

# 查看提供软件的信息
yum info <软件名>

# 查看文件由什么软件包提供
yum whatprovides <文件名>
```

```bash
# 安装/升级/卸载
yum -y install <软件名>
yum -y update  <软件名>  # 升级并改变配置文件（有可能改变内核）
yum -y upgrade <软件名>  # 仅升级二进制文件
yum -y remove  <软件名>

# 安装/删除组件的全部软件包
yum -y groupinstall <组件名>
yum -y groupremove  <组件名>

# 安装本地rpm包，并自动联网解决依赖
yum -y localinstall  <软件名>

# 从指定源安装
yum -y --enablerepo=<源名称> install <软件名>
```

## Debian & Ubuntu

### dpkg

### apt-get
