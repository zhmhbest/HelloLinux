
### 安装

```bash
# 安装
yum install -y mariadb mariadb-server

# 查看自动添加的用户
tail -2 /etc/passwd
# mysql:x:?:?:MariaDB Server:/var/lib/mysql:/sbin/nologin

# 防火墙
firewall-cmd --permanent --query-port=3306/tcp
firewall-cmd --permanent --zone=public --add-port=3306/tcp
firewall-cmd --reload
firewall-cmd --permanent --query-port=3306/tcp

# 启动
systemctl enable mariadb
systemctl start  mariadb
```

### 配置

```bash
# 初始化
mysql_secure_installation

# 登录
mysql -uroot -p
```

```SQL
SHOW DATABASES;
-- DROP DATABASE `db_name`;
-- DROP USER 'user_name'@'%';
CREATE DATABASE `db_name` CHARACTER SET utf8 COLLATE utf8_general_ci;
CREATE USER 'user_name'@'%' IDENTIFIED BY 'password';
REVOKE ALL ON *.* FROM 'user_name'@'%';
GRANT ALL PRIVILEGES ON `db_name`.* TO 'user_name'@'%' WITH GRANT OPTION;
QUIT;
```
