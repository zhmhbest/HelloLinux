# 进程管理

```bash
# 查看进程快照
ps -auf
ps -ef
ps -aux

# 实时查看进程
top
top -p <pid> # 盯住一个进程

# 查看CPU信息
cat /proc/cpuinfo
#查看CPU负载
uptime

# 关闭进程
kill -l # 列出可用信号
kill -9 <pid>
killall <pid>
pkill <进程名>

# 进程优先级
nice -n 5 bash  # 以优先级5打开一个新bash
renice 10 <pid> # 修改进程优先级

# 后台进程（前台关联）
#cmd&       # 运行一个后台进程
jobs        # 查看后台进程
fg <JOBNUM> # 后台进程放到前台
bg <JOBNUM> # 前台进程放到后台
#Ctrl + Z   # 当前运行进程放到后台

# 后台进程（无关前台）
#yum -y install screen
screen -ls              # 查看会话
screen -S SessionName   # 创建新会话
#Ctrl + A + D           # 分离当前会话放到后台
screen -d SessionName   # 分离会话
screen -r SessionName   # 重新连接会话（用会话名称）
screen -r SessionID     # 重新连接会话（用会话ID）
```
