# 文件系统

```bash
# 增加NTFS支持
wget -O /etc/yum.repos.d/aliyun_epel7.repo http://mirrors.aliyun.com/repo/epel-7.repo
yum -y install fuse-ntfs-3g

# 查看磁盘UUID和文件系统
blkid

# 查看磁盘UUID
ls -l /dev/disk/by-uuid

# 查看目录大小
du -sh /etc

# 磁盘管理（交互式）
mkdir /tmp/filesystem 2>/dev/null; cd /tmp/filesystem
dd if=/dev/zero of=vdisk.img bs=1M count=500
fdisk vdisk.img
#q: 退出

# 创建文件、格式化虚拟盘、挂载虚拟盘
mkdir /tmp/filesystem 2>/dev/null; cd /tmp/filesystem
dd if=/dev/zero of=vdisk.img bs=1M count=500
mkfs -t xfs ./vdisk.img
mkdir vmount; mount vdisk.img vmount/
cd vmount/
touch file{0..10} #创建file0~file10
touch -d "20181019 21:30" filename; ll  filename #指定创建时间
mkdir -p ./a/b/c  #创建目录，必要时同时创建父目录
mkdir -p ./1/2/3  #创建目录，必要时同时创建父目录
chmod -R 700  ./a #同时修改子目录及文件权限
```
