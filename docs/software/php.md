
### 安装

```bash
# 安装
yum -y install 'http://rpms.remirepo.net/enterprise/remi-release-7.rpm'
yum -y install --enablerepo=remi-php72 php-devel php php-cli php-common php-gd php-ldap php-mbstring php-mcrypth php-pdo php-mysqlnd php-fpm php-opcache php-pecl-redis php-pecl-mongodb

# 检查是否安装成功
php -v

# 已安装扩展
php -m

# 测试
# Apache2
pushd '/var/www/html'
# Nginx
pushd '/usr/share/nginx/html'
echo '<?php phpinfo(); ?>'>info.php

# 启动服务
systemctl enable php-fpm
systemctl start  php-fpm
systemctl status php-fpm
```

### 配置

```bash
vi '/etc/php.ini'
```

```ini
[PHP]
;...
```

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
