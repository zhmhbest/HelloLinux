
### 安装

- [Download](http://nodejs.cn/download/current/)

```bash
# CentOS
if [ ! -d /usr/applications ]; then mkdir /usr/applications; fi
node_ver='v14.17.1'
node_dir=node-$node_ver-linux-x64
pushd /tmp
wget "https://npm.taobao.org/mirrors/node/$node_ver/$node_dir.tar.xz"
tar -xvf $node_dir.tar.xz -C /usr/applications
ln -s /usr/applications/$node_dir/bin/node /usr/bin/node
ln -s /usr/applications/$node_dir/bin/npm /usr/bin/npm
ln -s /usr/applications/$node_dir/bin/npx /usr/bin/npx
rm -f $node_dir.tar.xz
popd

# Ubuntu
sudo apt install nodejs

# 检测安装成功
node -v
```
