
>Samba可以在Windows网上邻居中进行通讯。该协议缺乏路由和网络层寻址功能，即主机间必须处在同一网段。
>1. Port 137/udp - 名字服务
>2. Port 138/udp - 数据报服务
>3. Port 139/tcp - 文件和打印共享
>4. Port 389/tcp - 轻型目录访问（LDAP）
>5. Port 445/tcp - 实现网络文件共享
>6. Port 901/tcp - 网页管理

### 安装

```bash
# CentOS
yum -y install samba
firewall-cmd --permanent --query-port=137-138/udp
firewall-cmd --permanent --query-port=139/tcp
firewall-cmd --permanent --query-port=445/tcp
firewall-cmd --reload
# 服务管理
systemctl enable smb
systemctl status smb


# Ubuntu
# sudo apt-get install samba samba-common
sudo apt install samba
# Samba没有作为AD域控制器运行：Masking Samba-AD-dc.service
# 请忽略以下关于找不到deb-systemd-helper这些服务的错误。
# 服务管理
sudo ufw allow to any port 137,138 proto udp
sudo ufw allow to any port 139,445 proto tcp
sudo systemctl enable smbd
systemctl status smbd
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
[global]
    # 略
[printers]
    # 略
[print$]
    # 略

# 追加配置内容（[]内的内容，决定了访问时在IP下的文件夹名称）
[sambashare]
    comment = 共享目录
    path = /home/sambauser/share

    # 权限
    available = yes
    browseable = yes
    writable = yes
    # read only = yes
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
