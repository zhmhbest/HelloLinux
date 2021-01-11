<!--
### PHP
```bash
# 安装
# yum install -y http://rpms.remirepo.net/enterprise/remi-release-7.rpm
yum install --enablerepo=remi-php73 -y php
# 启动
systemctl enable mariadb
systemctl start  mariadb
# 配置
yum install -y vim
vim '/etc/php.ini'
# 测试
cd '/var/www/html'
echo '<?php phpinfo(); ?>'>info.php
# 打开<IP>/info.php
```
-->

<!--
### NextCloud
```bash
cd '/var/www/html'
# https://download.nextcloud.com/server/releases/
wget 'https://download.nextcloud.com/server/releases/nextcloud-14.0.14.zip'
yum install -y unzip
unzip nextcloud-*
# rm -rf ./nextcloud
chown -R apache:apache nextcloud
chmod -R 775 nextcloud
# /etc/pki/tls/openssl.cnf
```
-->
