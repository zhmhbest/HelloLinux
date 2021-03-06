
### 安装

```bash
# CentOS
sudo yum -y install openssh-server

# Ubuntu
sudo apt-get install openssh-server
```

### 配置文件

`/etc/ssh/sshd_config`

```conf
# Port 22
#AddressFamily any
AddressFamily inet
#ListenAddress 0.0.0.0
#ListenAddress ::

AuthorizedKeysFile .ssh/authorized_keys
PasswordAuthentication  yes

X11Forwarding yes
```

### 修改端口

```bash
# 查看当前端口
egrep '^Port ' '/etc/ssh/sshd_config'

# 修改端口
changeConfig /etc/ssh/sshd_config Port ' ' 2048

# 防火墙
firewall-cmd --permanent --zone=public --add-port=2048/tcp
firewall-cmd --reload
firewall-cmd --permanent --query-port=2048/tcp

# 重启服务
systemctl restart sshd

# 查看端口号
netstat -tunlp | grep "ssh"

# 测试登录
ssh root@localhost -p 2048
```

### SSH免密登录

```bash
# -m 密钥格式 { RFC4716 | PKCS8 | PEM }
# -b 密钥长度（单位为bit）
# -t 加密算法 { dsa | ecdsa | ecdsa-sk | ed25519 | ed25519-sk | rsa }
# -P 密码短语
# -C 备注信息
# -f 保存的文件名
ssh-keygen -m PEM -t rsa -b 4096 -P '' -f ./.ssh/id_rsa
# ssh-keygen      -t rsa         -P '' -f ~/.ssh/id_rsa

pushd ~/.ssh; ll
# -rw------- 1 root root 1679 * id_rsa
# -rw-r--r-- 1 root root  408 * id_rsa.pub
# id_rsa     : 私钥（个人本地持有）
# id_rsa.pub : 公钥（远程主机持有）
cp ./id_rsa.pub ./authorized_keys
# ssh -l root -i <私钥> <地址>
```

#### 异常解决

>Couldn't load this key (OpenSSH SSH-2 private key(old PEM format))

- [puttygen.exe](https://the.earth.li/~sgtatham/putty/latest/w64/puttygen.exe)、Conversations、Import keys、选择`id_rsa`、Save private key

#### 禁用密码登录

```bash
# 查看是否开启
egrep '^PasswordAuthentication ' '/etc/ssh/sshd_config'

# 关闭密码登录
changeConfig /etc/ssh/sshd_config PasswordAuthentication ' ' no

# 重启应用
systemctl restart sshd

# 检查是否可以密码登录
ssh root@localhost -p 2048
```
