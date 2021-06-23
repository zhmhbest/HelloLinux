
>Samba可以使Linux在Windows网上邻居中进行通讯。默认情况下，主机间必须处在同一网段。

### 安装

```bash
# 【CentOS】
yum -y install samba
# 服务管理
systemctl status smb
systemctl start smb
systemctl stop smb
systemctl restart smb


# 【Ubuntu】
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
# sudo userdel -r sambauser
sudo useradd sambauser
# sudo mkdir /home/sambauser; sudo chown sambauser:sambauser /home/sambauser
sudo passwd sambauser

smbpasswd -a sambauser # 新增用户（必须也是系统用户）
# smbpasswd -d sambauser # 冻结用户
# smbpasswd -e sambauser # 恢复用户

su - sambauser
# 创建共享文件夹
mkdir ./share; chmod 777 ./share
# 备份配置文件
mkdir backups; cp /etc/samba/* ./backups
exit

# 编辑配置文件
vim /etc/samba/smb.conf
```

```ini
;;略
```

### 使用

```batch
REM 访问共享文件夹
\\<IP>
```
