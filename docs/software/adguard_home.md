
### 安装

[AdGuardHome](https://github.com/AdguardTeam/AdGuardHome)

```bash
# Applications
if [ ! -d /usr/applications ]; then sudo mkdir /usr/applications; fi

# 检查DNS配置（含有8.8.8.8）
grep '^nameserver' /etc/resolv.conf

sudo mkdir /usr/applications/AdGuard
cd /usr/applications/AdGuard
sudo wget 'http://raw.githubusercontent.com/AdguardTeam/AdGuardHome/master/scripts/install.sh'
sudo bash ./install.sh
# sudo /opt/AdGuardHome/AdGuardHome -s start|stop|restart|status|install|uninstall

# CentOS防火墙
firewall-cmd --permanent --zone=public --add-port=3000/tcp
firewall-cmd --permanent --zone=public --add-port=53/tcp
firewall-cmd --reload

# Ubuntu防火墙
sudo ufw allow to any port 3000 proto tcp
sudo ufw allow to any port 53 proto tcp
sudo ufw status verbose

# 安装准备
sudo /opt/AdGuardHome/AdGuardHome -s start
# 访问网页<http://ip:3000/install.html>完成后续安装
# 设置《网页管理》端口为3000
# 设置《DNS 服务器》端口为53

# 服务管理
systemctl status AdGuardHome

# 卸载
sudo systemctl stop AdGuardHome
sudo systemctl disable AdGuardHome
sudo bash /usr/applications/AdGuard/install.sh -u
systemctl status AdGuardHome
ll /opt/AdGuardHome/
```
