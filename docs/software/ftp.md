
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
sudo vim /etc/vsftpd.conf
```

```properties
# 访问成功欢迎语
ftpd_banner=Welcome to the FTP service.
# 允许为目录配置显示信息
dirmessage_enable=YES

# 监听
listen=NO
listen_ipv6=YES
# 确保传输连接源自端口20
connect_from_port_20=YES

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
# chroot_local_user=YES
# allow_writeable_chroot=YES
# 当启用chroot后，文件中是不启用chroot的用户
# chroot_list_enable=YES
# chroot_list_file=/etc/vsftpd.chroot_list
# 用作chroot监狱（建议使用默认配置）
secure_chroot_dir=/var/run/vsftpd/empty

# SSL
# rsa_cert_file=
# rsa_private_key_file=
# ssl_enable=NO

# LOG
# 记录上传下载日志
xferlog_enable=YES
# 记录到xferlog_file所指文件
xferlog_std_format=YES
xferlog_file=/var/log/vsftpd.log

# 被动连接
pasv_enable=YES
pasv_min_port=40000
pasv_max_port=40010
pasv_promiscuous=NO
```

```bash
systemctl restart vsftpd
```
