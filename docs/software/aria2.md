
### 安装

```bash
yum -y groupinstall 'Development Tools'
```

```bash
aria2_version='1.19.0'
wget "https://jaist.dl.sourceforge.net/project/aria2/stable/aria2-${aria2_version}/aria2-${aria2_version}.tar.gz"
tar -xvf "aria2-${aria2_version}.tar.gz"
pushd "aria2-${aria2_version}"

./configure --prefix=/usr/local/aria2
make -j 4
# make install
cp ./src/aria2c /usr/local/bin
aria2c -v

popd
```
