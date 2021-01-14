<link rel="stylesheet" href="https://zhmhbest.gitee.io/hellomathematics/style/index.css">
<script src="https://zhmhbest.gitee.io/hellomathematics/style/index.js"></script>

# [Text](./index.html)

[TOC]

## grep

`grep [OPTION]... PATTERN [FILE]...`

```bash
# OPTION
# -B<num>       显示之前的几行
# -A<num>       显示之后的几行
# -C<num>       = -B<num> -A<num>
# -c            返回成功匹配的行数
# -e            PATTERN为简单正则，不支持()
# -E            PATTERN为扩展正则，grep -E = egrep
# -f<file>      指定存储了PATTERN的文件
# -F            PATTERN为字符串
# -i            忽略PATTERN的大小写
# -n            显示匹配成功的行的行号
# -o            只显示匹配成功的部分
# -v            显示匹配失败的行
grep -B1 -A1 -c '^bin' /etc/passwd
grep -F 'bin' /etc/passwd
grep -i '^BIN' /etc/passwd
grep -n '^bin' /etc/passwd
grep -o '^bin' /etc/passwd
grep -v '^bin' /etc/passwd

# 获取网络配置
ifconfig -a | grep 'inet ' | grep -v '127.0.0.1'
```

## sed

`sed [OPTION]... <-e<script> | -f<script-file>> [file]...`

```txt
OPTION
    -i      直接修改源文件
    -n      仅显示处理的结果
    -r      使用扩展的正则
```

```txt
SCRIPT
    i       插入（原行前）
    a       插入（原行前）
    c       替换
    d       删除
    s       替换
    p       打印
```

```bash
cp /etc/selinux/config ./test

# 打印第[3,6]行
sed -ne '3,6p' ./test

# 插入内容到第4行（原行前）
sed -e '4i\内容' ./test

# 插入内容到第4行（原行后）
sed -e '4a\内容' ./test

# 替换第4行内容
sed -e '4c\内容' ./test

# 删除第[4,5]行
sed -e '4,5d' ./test

# 替换所有#为$
sed -e 's/#/$/g' ./test

# 数据搜索（筛选出匹配的行）
sed -n '/^SELINUX=/p' ./test

# 数据搜索（在匹配的行内继续执行操作）
# sed -n '/^SELINUX=/{s/disabled/enforcing/;p;q}' ./test
sed -n '/^SELINUX=/s/disabled/enforcing/p' ./test
sed '/^SELINUX=/s/disabled/enforcing/' ./test
```

## awk

```bash


```
