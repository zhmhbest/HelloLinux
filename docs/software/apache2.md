
### 安装

```bash
# 安装
yum install -y httpd

# 防火墙
firewall-cmd --permanent --zone=public --add-service=http
firewall-cmd --permanent --zone=public --add-service=https
firewall-cmd --reload

# 启动
systemctl enable httpd
systemctl start  httpd
```
