
### 安装

- [Download](http://nodejs.cn/download/current/)

适用于CentOS/Ubuntu等系统

```bash
# 准备应用程序目录
if [ ! -d /usr/applications ]; then mkdir /usr/applications; fi

node_ver='v14.17.1'
node_cpu='linux-x64'
# node_cpu='linux-armv7l'
# node_cpu='linux-arm64'
node_name=node-$node_ver-$node_cpu

pushd /tmp
wget "https://npm.taobao.org/mirrors/node/$node_ver/$node_name.tar.xz"
tar -xvf $node_name.tar.xz -C /usr/applications
# rm /usr/bin/node /usr/bin/npm /usr/bin/npx
ln -s /usr/applications/$node_name/bin/node /usr/bin/node
ln -s /usr/applications/$node_name/bin/npm /usr/bin/npm
ln -s /usr/applications/$node_name/bin/npx /usr/bin/npx
rm -f $node_name.tar.xz
popd

# 检测安装成功
node -v
npm -v
npx -v
```
