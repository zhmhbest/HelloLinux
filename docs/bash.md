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

## files

### 递归枚举目录下所有文件

```bash
IFS=`echo -en "\n\b"`; basePath="."; for i in `ls -R`; do
    if [ "${i:(-1)}" = ":" ]; then basePath="${i::(-1)}"; else
        filename="$basePath/$i"; extName="${filename##*.}"
        echo $filename, $extName
    fi
done
```
