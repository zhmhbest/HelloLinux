
### 安装

```bash
# CentOS
yum -y install vsftpd
firewall-cmd --zone=public --add-port=20-21/tcp --permanent
firewall-cmd --zone=public --add-port=40000-40010/tcp --permanent
firewall-cmd --reload
firewall-cmd --list-all

# Ubuntu
# sudo apt-get install vsftpd
sudo apt install vsftpd
sudo ufw allow to any port 20,21,40000:40010 proto tcp
sudo ufw status verbose

# 服务管理
systemctl status vsftpd
```

### 配置

```bash
# CentOS
egrep -v '^#' /etc/vsftpd/vsftpd.conf
vim /etc/vsftpd/vsftpd.conf

# Ubuntu
egrep -v '^#' /etc/vsftpd.conf
vim /etc/vsftpd.conf
```

```properties
# 访问成功欢迎语
ftpd_banner=Welcome to the FTP service.

# 是可用`ls -R`命令
ls_recurse_enable=YES

# 上传总开关
write_enable=YES

# 匿名用户
anonymous_enable=NO
anon_umask=077
# 匿名用户登录不询问密码
no_anon_password=YES
anon_upload_enable=NO
anon_mkdir_write_enable=NO
# 匿名用户主目录
# anon_root=
# 匿名用户上传文件后修改其所有者
#chown_uploads=YES
#chown_username=whoever

# 本地用户
local_enable=YES
local_umask=022
# 限制用户到其家目录
chroot_local_user=YES
# 当启用chroot后，文件中是不启用chroot的用户
# chroot_list_enable=YES
# chroot_list_file=/etc/vsftpd.chroot_list

# 被动连接时端口范围
pasv_max_port=40000
pasv_min_port=40010
```

```bash
systemctl restart vsftpd
```
