
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

### 参数说明

```bash
aria2c [OPTIONS] [URI | MAGNET | TORRENT_FILE | METALINK_FILE]...

# OPTIONS
# -i, --input-file=<FILE>               待下载文件列表
# -T, --torrent-file=<TORRENT_FILE>     .torrent
# -d, --dir=<DIR>                       下载目录
# -o, --out=<FILE>                      重命名文件
# -c, --continue[=true|false]           断点续传
# -s, --split=<N>                       每个服务链接数
# -k, --min-split-size=<SIZE>           不拆分小于2*SIZE字节的文件
# -x, --max-connection-per-server=<NUM> 每个服务最大链接数
# -j, --max-concurrent-downloads=<N>    最大并行下载数
# --ftp-user=<USER>
# --ftp-passwd=<PASSWD>
# --http-user=<USER>
# --http-passwd=<PASSWD>
# --load-cookies=<FILE>                 COOKIE（Firefox3 format）
```
