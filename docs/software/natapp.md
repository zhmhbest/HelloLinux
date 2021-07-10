
NATAPP内网穿透解决方案

### 安装

从[此处](https://natapp.cn/#download)复制要下载的`natapp_url`地址。

```bash
# Applications
if [ ! -d /usr/applications ]; then sudo mkdir /usr/applications; fi

sudo mkdir /usr/applications/natapp
cd /usr/applications/natapp
natapp_url=''
sudo wget $natapp_url -O natapp
```

### 配置

从[此处](https://natapp.cn/tunnel/lists)配置中复制`authtoken`。

```bash
# 运行配置
sudo vim /usr/applications/natapp/config.ini
```

`config.ini`

```ini
[default]
authtoken=1122334455667788
clienttoken=
log=/usr/applications/natapp/output.log
loglevel=INFO
http_proxy=
```

```bash
sudo vim '/usr/lib/systemd/system/natapp.service'
```

`natapp.service`

```ini
[Unit]
Description=NATAPP Service
After=network.target

[Service]
Type=simple
ExecStart=/usr/applications/natapp/natapp -config /usr/applications/natapp/config.ini
KillSignal=SIGINT
Restart=on-failure
RestartSec=5

[Install]
WantedBy=multi-user.target
```

```bash
systemctl status natapp
sudo systemctl start natapp

# 查看映射的地址
sudo grep ' Tunnel established at ' /usr/applications/natapp/output.log | awk -F' Tunnel established at ' '{print $2}' | tail -n 1
```

```bash
# 实时获取地址
fileName="/usr/applications/natapp/output.log"
msgSplit=' Tunnel established at '
memMod=0
while true; do
    curMod=$(stat -c '%Y' "$fileName")
    if (($memMod != $curMod)); then
        sudo grep "$msgSplit" $fileName | awk -F"$msgSplit" '{print $2}' | tail -n 1
        memMod=$curMod
    fi
    sleep 1;
done
```
