<link rel="stylesheet" href="https://zhmhbest.gitee.io/hellomathematics/style/index.css">
<script src="https://zhmhbest.gitee.io/hellomathematics/style/index.js"></script>

# [Bash](./index.html)

[TOC]

## 命令行操作

`Ctrl + A`: 光标移到**行首**
`Ctrl + E`: 光标移到**行尾**
`Ctrl + B`: 光标**左移**
`Ctrl + F`: 光标**右移**
`ESC + B` : 往左跳一个词
`ESC + F` : 往右跳一个词

`Ctrl + H`: 删除光标**前一个字符**，相当于`backspace`
`Ctrl + D`: 删除光标**当前所在字符**
`Ctrl + W`: 删除光标**前一个单词**
`ESC + D` : 删除光标**后一个单词**
`Ctrl + U`: 删除光标**前至行首**的所有内容
`Ctrl + K`: 删除光标**后至行尾**的所有内容
`Ctrl + Y`: 粘贴或者恢复上次的删除

`Ctrl + T`: 交换光标位置前的**两个字符**
`ESC + T` : 交换光标位置前的**两个单词**

`Ctrl + C`: 杀死当前进程
`Ctrl + D`: 退出当前Shell
`Ctrl + L`: 清屏，相当于`clear`
`Ctrl + Z`: 把当前进程转到后台运行，使用`fg`命令恢复

`Ctrl + R`: 搜索之前打过的命令

## 输入输出

```bash
echo "禁用转义:[\ \t\#\n]"
echo -e "启用转义:[\ \t\#\n]"
echo -n "不换行输出"

# 以下命令等价
echo "Content"
printf "Content\n"

# 以下命令等价
echo -n "Enter name:"; read name; echo "name is [$name]"
read -p "Enter name:" name; echo "name is [$name]"

# 静默输入
read -sp "Enter password:" password; echo "password is [$password]"
```

## 变量与引号

```bash
echo String
echo "String"
echo 'String'

var=Hello
echo $var
echo ${var}
echo "$var"
echo "${var}"
# 原样输出
echo '$var'
echo '${var}'

# 获取命令返回值
echo `uname -s`
echo $(uname -s)
```

## 特殊符号

```bash
function dollar() {
    echo Random: $RANDOM
    echo param1: $1
    echo param2: $2
    echo param3: ${3}
    echo param.length: $#
    for item in $*; do
        echo *"$item"
    done
    for item in "$@"; do
        echo @"$item"
    done
    return 99
}

echo PID:$$
dollar A B "C D"
echo code:$?
```

## 日期

```bash
# 查看当前系统时间
hwclock
date
# UTC: 世界标准时间
# GMT: 格林尼治时间
# CST: 中国标准时间

# 格式化时间
date "+%Y-%m-%d %H:%M:%S"                # 格式化显示当前时间
date -d "1996-10-16 12:33:23"            # Type1: 显示字符串所描述的时间
date -d "-2 months"                      # Type2: 显示字符串所描述的时间
date -d "-2 months" "+%Y-%m-%d %H:%M:%S" # Type3: 显示字符串所描述的时间

# 修改时间
date -s "1996-10-16 12:33:23"           # 设为字符串所描述的时间
```

## 休眠

```bash
# sleep 1d 2h 3m 30s
echo 'Sleeping...'; sleep 3s; echo 'Weak up!'
```

## 控制语句

### if

```bash
# if [ condition ] || [[ condition ]] || ((condition)); then
#     # ...
# elif [ condition ]; then
#     # ...
# else
#     # ...
# fi

# 正则条件
function isdigits() {
    if [[ "$1" =~ ^[0-9]+$ ]]; then
        echo "Number"
    else
        echo "NaN"
    fi
}
isdigits 123
isdigits qwe
```

- `[ expression  ]`
- `[[ expression  ]]`: 扩展test
- `(( expression  ))`: 数学运算

#### operation

`+` `-` `*` `/` `**` `%` `+=` `-=` `*=` `/=` `%=`

`-eq` `-ne` `-gt` `-lt` `-ge` `-le`

`&&` `||`

#### condition

`! EXPRESSION`

`-n STRING` `-z STRING` `STRING1 == STRING2` `STRING1 != STRING2` `STRING =~ REG_EXP`

`INTEGER1 -eq INTEGER2` `INTEGER1 -gt INTEGER2` `INTEGER1 -lt INTEGER2`

`-e FILE` `-d FILE` `-r FILE` `-s FILE` `-w FILE` `-x FILE` `-h FILE`

#### regexp

```bash
echo "123" | egrep "[0-9]+">/dev/nul && {
    echo Number
} || {
    echo NaN
}
echo "abc" | egrep "[0-9]+">/dev/nul && {
    echo Number
} || {
    echo NaN
}
```

### case

```bash
case expression in
    pattern1)
        # ...
        ;;
    pattern2)
        # ...
        ;;
    pattern3|pattern4|)
        # ...
        ;;
    *)
        # ...
        ;;
esac
```

### for

```bash
words="Linux is not unix"
for word in $words; do
    echo $word
done

for num in {6..0..2}; do
    echo $num
done

for ((i=1; i<=3; i++)); do
    echo "$i"
done
```

### while

```bash
# while [ expression ]; do
#     # ...
# done

i=0
while [ $i -le 3 ]; do
    echo $i
    ((i++))
done
```

### until

```bash
# until [ expression ]; do
#     # ...
# done

i=0
until [ $i -gt 3 ]; do
    echo $i
    ((i++))
done
```

## text

### grep

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

### sed

`sed [OPTION]... { -e<script> | -f<script-file> } [file]...`

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

### awk

>[参考链接](https://www.runoob.com/linux/linux-comm-awk.html)

`{awk | gawk} [OPTION] { <script> | -f<file>.awk } file ...`

```txt
OPTION
    -F <ch>         每行字段的分隔符
    -v <var>=<val>  定义变量
```

```txt
SCRIPT
    $0              整行文本
    $<n>            该行第n个字段
    FS              分隔符
    NF              当前记录中的字段数量
    NR              行号
    FILENAME        当前搜索的文件名
    IGNORECASE=1    忽略大小写

    BEGIN{}
    END{}
    if(){} else if(){} else{}
    for(;;){}
    for(item in arr){}
    do{} while()

    length(str1)
    index(str1, str2)               str2在str1中第一次出现的位置
    tolower(str1)
    toupper(str1)
    substr(str1, start, len)
    match(str1, pattern)
    sub(pattern, replaced, str1)    替换第一次
    gsub(pattern, replaced, str1)   全局搜索替换
    split(str1, var, str2)          以str2分割str1存入var
```

```bash
# 打印第二行
awk '2 == NF' ./test

# 打印正则匹配的行
awk '/^[0-9]+$/' ./test

# 打印每一行
gawk '{print}' ./test
gawk '{print $0}' ./test

# 读取inf文件
gawk -F'=' '{if("1"==NF || /^;/){next} print $1,$2}' ./test
```

## string

### length

```bash
# 字符串长度
echo length=${#var}
```

### case

```bash
var="aBcD"

# 转为大写
echo ${var^^}

# 转为小写
echo ${var,,}
```

### cut

```bash
# 裁剪字符串（前三个）
echo '0123456789' | cut -c '1-3'

# 裁剪第n块
echo 'Peter,Male,18,12322223333' | cut -d ',' -f '3'

# 裁剪第n和m块
echo 'Peter,Male,18,12322223333' | cut -d ',' -f '1,4'

# 裁剪第n至m块
echo 'Peter,Male,18,12322223333' | cut -d ',' -f '1-3'
```

### substr

```bash
var="0123456789"

# substr(offset,length)=${variable:offset:length}
echo ${var:3:3}

# leftdel(length)=${variable:length}
echo ${var:4}

# rightdel(length)=${variable:0: -length}
echo ${var:0: -3}

# left(length)=${variable:0:length}
echo ${var:0:5}

# right(length)=${variable: -length}
echo ${var: -4}
```

### tr

```bash
# 删除字符A和字符C
echo 'ABC abc ABC' | tr -d 'AC'

# 删除数字
echo 'ABC123 abc456 ABC789' | tr -d '0-9'

# `|`转换为`,`
echo 'ABC|ABC' | tr '|' ','

# 小写换大写
echo 'abcdef' | tr 'a-z' 'A-Z'
```

### replace

```bash
var="/home/user/.ssh/known_hosts"
# 特殊符号: *、?、[]

# 从开头惰性匹配，删除匹配的部分
echo ${var#/*/}

# 从开头贪婪匹配，删除匹配的部分
echo ${var##/*/}

# 从结尾惰性匹配，删除匹配的部分
echo ${var%/*}

# 从结尾贪婪匹配，删除匹配的部分
echo ${var%%/*}

# 惰性匹配
# ${variable/pattern/string}
echo ${var/[A-z]/_}

# 贪婪匹配
# ${variable//pattern/string}
echo ${var//[A-z]/_}
```

### split

```bash
var="Linux is not unix"

# Split( )
IFS=' '
read -ra arr <<<"$var"
for part in "${arr[@]}"; do echo $part; done

# Split(n)
readarray -d 'n' -t arr <<<"$var"
for part in "${arr[@]}"; do echo $part; done

# Split(i)
arr=($(echo $var | tr "i" "\n"))
for part in "${arr[@]}"; do echo $part; done
```

### hash

```bash
# MD5
echo 123 | md5sum | cut -c '1-32' | tr 'a-z' 'A-Z'

# Sha256
echo '123' | sha256sum | cut -c '1-64' | tr 'a-z' 'A-Z'
```

## Shells

### 修改配置

```bash
function changeConfig() {
    # $1 file
    # $2 key
    # $3 split
    # $4 value
    line=`egrep -n "^\s*${2}\s*${3}" "$1"` && {
        n=`echo $line|awk -F':' '{print $1}'`
        sed -i -e "${n}c\\${2}${3}${4}" "$1"
        echo update
    } || {
        echo "${2}${3}${4}">>"$1"
        echo append
    }
}
```

### 枚举目录下文件

```bash
# 枚举当前目录下文件
function getFolderFiles() {
    local IFS=$(printf "\n\b")
    for f in $(ls "$1"); do
        printf "$f\t"
    done
}
function getFolderDeepFiles() {
    local IFS=$(printf "\t")
    for f in $(getFolderFiles "$1"); do
        local fileName="$1/$f"
        if [ -d "$fileName" ]; then
            echo "d $fileName"
            getFolderDeepFiles "$fileName"
        else
            echo "f $fileName"
        fi
    done
}
getFolderDeepFiles .
```

### 获取绝对路径

```bash
function getAbsolutePath() {
    # $1: fileName
    local first=${1:0:1}
    if [ "." == "$first" ]; then
        echo "$(pwd)/$(echo $1 | cut -c 3-${#1})"
    elif [ "/" == "$first" ]; then
        echo "$1"
    else
        echo "$(pwd)/$1"
    fi
}
```

### 生成8位随机字符

```bash
function genRandom8Chars() {
    echo $RANDOM | md5sum | cut -c 1-8
}
```

### 合并第二个ZIP到第一个中

```bash
function combineZIP() {
    # description: 将SecondZip合并到FirstZip中
    # dependencies: [genRandom8Chars, getAbsolutePath]
    # $1: firstZip
    # $2: secondZip
    # $3: [secondPreFix] default=.
    # $4: [dumpPath] default=/tmp
    # $5: [backupPath] default=$(dirname firstZip)

    # 获取压缩包路径
    local firstZip="$(getAbsolutePath "$1")"
    local secondZip="$(getAbsolutePath "$2")"
    if [ ! -f "$firstZip" ] || [ ! -f "$secondZip" ]; then
        echo "ZipFile dose not exist!"
        return 1
    fi
    # echo $firstZip
    # echo $SecondZip

    # 临时展开根目录
    if [ -n "$4"  ] && [ -d "$4" ]; then
        local extractRootPath="$(getAbsolutePath "$4")/CombineZIP_$(genRandom8Chars)"
    else
        local extractRootPath="/tmp/CombineZIP_$(genRandom8Chars)"
    fi
    if [ ! -d "$extractRootPath" ]; then mkdir "$extractRootPath"; fi
    # 临时展开目录
    if [ -z "$3" ]; then
        local extractPath="${extractRootPath}"
    else
        local extractPath="${extractRootPath}/$3"
    fi
    mkdir -p "$extractPath"
    # echo $extractPath

    # 备份目录
    if [ -z "$5" ]; then
        local backupPath="$(dirname "$firstZip")"
    else
        local backupPath="$(getAbsolutePath "$5")"
    fi
    if [ ! -d "$backupPath" ]; then
        echo "BackupPath dose not exist!"
        return 1
    else
        cp -v "$firstZip" "$backupPath/$(date '+%Y%m%d%H%M%S')-$(basename "$firstZip")"
    fi
    # echo $backupPath

    # 展开第二个Zip
    unzip -d "$extractPath" "$secondZip"

    # 合并压缩
    pushd "$extractRootPath"
    zip -r "$firstZip" ./
    popd

    # 移除缓存目录
    rm -Rf "$extractRootPath"
}
```
