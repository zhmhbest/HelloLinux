
>Samba可以使Linux在Windows网上邻居中进行通讯。默认情况下，主机间必须处在同一网段。

### 安装

```bash
# CentOS
yum -y install samba
# 服务管理
systemctl status smb
systemctl start smb
systemctl stop smb
systemctl restart smb


# Ubuntu
# sudo apt-get install samba samba-common
sudo apt install samba
# Samba没有作为AD域控制器运行：Masking Samba-AD-dc.service
# 请忽略以下关于找不到deb-systemd-helper这些服务的错误。
# 服务管理
systemctl status smbd
systemctl start smbd
systemctl stop smbd
systemctl restart smbd
```

### 配置

```bash
# 添加系统用户
sudo adduser sambauser
# 切换到该用户
sudo su - sambauser
# 创建共享文件夹
mkdir ./share; chmod 777 ./share
# 备份配置文件
mkdir ./backups; cp -R /etc/samba/* ./backups
exit


# sudo smbpasswd -a <系统用户名> # 新增用户
# sudo smbpasswd -d <系统用户名> # 冻结用户
# sudo smbpasswd -e <系统用户名> # 恢复用户
sudo smbpasswd -a sambauser
# New SMB password:
# Retype new SMB password:
# Added user ?.


# 查看当前配置
egrep -v '^$|^#|^;' /etc/samba/smb.conf
# 编辑配置文件
sudo vim /etc/samba/smb.conf
```

```ini
# 追加配置内容
# []内的内容，决定了访问时在IP下的文件夹名称
[sambashare]
    comment = 共享目录
    path = /home/sambauser/share

    # 权限
    available = yes
    browseable = yes
    writable = yes
    create mask = 0644
    directory mask = 0755

    # 宾客权限
    public = no
    guest ok = no

    # Windows下工作组
    workgroup = samba

    # 允许访问该共享的用户
    # valid users = user1,user2,@group1,@group2
    # 允许写入该共享的用户
    # write list = user1,user2,@group1,@group2
    # 禁止访问该共享的用户
    # invalid users = user1,user2,@group1,@group2
    valid users = @sambauser
    write list = @sambauser
```

```bash
# 重启服务
# CentOS
systemctl restart smb
# Ubuntu
systemctl restart smbd
```

### 使用

```batch
REM 访问共享文件夹
\\<IP>
```
