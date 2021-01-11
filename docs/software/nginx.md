
### 安装

```bash
yum install -y yum-utils
vi '/etc/yum.repos.d/nginx.repo'
```

[**nginx.repo**](http://nginx.org/en/linux_packages.html#RHEL-CentOS)

```ini
[nginx-stable]
name=nginx stable repo
baseurl=http://nginx.org/packages/centos/$releasever/$basearch/
gpgcheck=1
enabled=1
gpgkey=https://nginx.org/keys/nginx_signing.key
module_hotfixes=true

[nginx-mainline]
name=nginx mainline repo
baseurl=http://nginx.org/packages/mainline/centos/$releasever/$basearch/
gpgcheck=1
enabled=0
gpgkey=https://nginx.org/keys/nginx_signing.key
module_hotfixes=true
```

```bash
# 安装
yum install -y nginx

# 测试安装成功
nginx -v

# 查看自动添加的用户
tail -2 /etc/passwd
# nginx:x:?:?:nginx user:/var/cache/nginx:/sbin/nologin

# 防火墙
firewall-cmd --permanent --zone=public --add-service=http
firewall-cmd --permanent --zone=public --add-service=https
firewall-cmd --reload

# 控制
nginx            # 启动
nginx -s stop    # 快速关闭
nginx -s quit    # 正常关闭
nginx -s reload  # 重新加载配置文件
nginx -s reopen  # 重新打开日志文件
```

### 配置

>[Admin Guide](https://docs.nginx.com/nginx/admin-guide/)

```bash
ll '/usr/share/nginx/html'  # 默认页面所在目录
ll '/etc/nginx'             # 配置所在目录
```

```bash
user nginx;             # 用户
worker_processes 1;     # 允许生成的进程数

# 全局错误日志
# 日志路径，日志级别（debug|info|notice|warn|error|crit|alert|emerg）
error_log   /var/log/nginx/error.log warn;

# 记录主进程ID的文件
pid         /var/run/nginx.pid;

# 引入其它配置
include     /etc/nginx/conf.d/?.conf

# 【连接处理】
events {
    accept_mutex on;    # 网路连接序列化，可防止惊群现象
    multi_accept on;    # 一个进程是否可以同时接受多个网络连接
    use epoll;          # 事件驱动模型（select|poll|kqueue|epoll|resig|/dev/poll|eventport）
    worker_connections  1024;   # 每个进程最大连接数
    # 并发总数 max_clients = worker_professes * worker_connections
}

# 【针对HTTP并影响所有虚拟服务器】
http {
    include mime.types;         # 文件扩展名与文件类型映射表
    default_type text/plain;    # 默认文件类型


    # access_log off;           # 取消访问日志
    # 自定义的格式名称，自定义的日志格式
    log_format  main  '$remote_addr - $remote_user [$time_local] "$request" '
                      '$status $body_bytes_sent "$http_referer" '
                      '"$http_user_agent" "$http_x_forwarded_for"';
    # 日志位置，格式名称
    access_log  /var/log/nginx/http_access.log  main;
    error_log   /var/log/nginx/http_error.log main;

    # tcp_nopush on;
    # tcp_nodelay on;

    sendfile on;                # 允许以sendfile方式传输文件
    sendfile_max_chunk 64k;     # 每个进程每次传输上限，0表示无限制


    keepalive_timeout 65;       # 多少秒无反应连接超时时间

    # client_header_buffer_size    128k;    # 客户端请求头缓存大小
    # large_client_header_buffers  4 128k;  # 最大数量和最大客户端请求头的大小

    # gzip_vary on;

    server {
        listen       80;
        server_name  localhost;
        # access_log  /var/log/nginx/host.access.log  main;
        # error_page  404            /404.html;
        # error_page 500 502 503 504 /50x.html;
        # location = /50x.html {
        #     root  /usr/share/nginx/html;
        # }

        location / {
            root    /usr/share/nginx/html;
            index   index.html index.htm;
        }

        # Proxy-PHP on 127.0.0.1:80
        # location ~ \.php$ {
        #    proxy_pass     http://127.0.0.1;
        # }

        # CGI-PHP on 127.0.0.1:9000
        #location ~ \.php$ {
        #    root           html;
        #    fastcgi_pass   127.0.0.1:9000;
        #    fastcgi_index  index.php;
        #    fastcgi_param  SCRIPT_FILENAME  /scripts$fastcgi_script_name;
        #    include        fastcgi_params;
        #}

        # 禁止访问隐藏文件
        location ~ /\. {
            deny all;
            access_log off;
            log_not_found off;
        }

    }
}

# 【针对TCP/UDP并影响所有虚拟服务器】
stream {
    server {
        # ...
    }
}
```