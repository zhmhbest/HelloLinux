<link rel="stylesheet" href="https://zhmhbest.gitee.io/hellomathematics/style/index.css">
<script src="https://zhmhbest.gitee.io/hellomathematics/style/index.js"></script>

# [Install Ubuntu Server](../../index.html)

## 安装

>使用`ubuntu-*-live-server-amd64.iso`进行联网安装。

- **Select your language**
  - Engilsh
- **Select "Identify keyboard"**
  - English(US)
  - English(US)
- **Configure interface**
  - *default*
- **Proxy address**
  - *default*
- **Mirror address**
  - http://mirrors.aliyun.com/ubuntu/
- **Configure storage**
  - Use an entire disk
  - Cusom storage layout
- **Configure SSH access**
  - Your name: 显示用户名
  - Your server's name: 主机名称
  - Pick a username: 登录用户名
  - ...
- **Install OpenSSH server**
- **Popular snaps**
- **Installing**

## 软件

```bash
# 必备工具
sudo apt install network-manager
sudo apt install net-tools
sudo apt install zip unzip

# X11应用
sudo apt install x11-apps
# 测试X11
xclock
```
