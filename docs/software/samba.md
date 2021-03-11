
>Samba可以使Linux在Windows网上邻居中进行通讯。默认情况下，主机必须处在同一网段。

### 安装

```bash
# 安装服务
rpm -qi samba
yum -y install samba

# 服务管理
systemctl status smb
systemctl start smb
systemctl stop smb
systemctl restart smb
```

### 配置

```bash
# 添加用户
useradd sambauser      # 添加系统用户
echo "sambauser" | passwd --stdin sambauser
smbpasswd -a sambauser # 新增用户（必须也是系统用户）
# smbpasswd -d sambauser # 冻结用户
# smbpasswd -e sambauser # 恢复用户

su - sambauser
# 创建共享文件夹
mkdir ./share; chmod 777 ./share
# 备份配置文件
mkdir backups; cp /etc/samba/* ./backups
#
exit

# 编辑配置文件
vim /etc/samba/smb.conf
```

```inf
```

### 使用

```batch
REM 访问共享文件夹
\\<IP>
```
