# Alpine系统 {docsify-ignore}
> 这是一款非常优秀的轻量级Linux发行版, 现在大多镜像基于该系统构建, 就市场受欢迎的程度, 已说明了真相. 我自从知道了这个系统后, 下载的大部分基于该系统构建的镜像, 因此, 节约了大量空间. 强烈推荐.

* 换源 `sed -i 's/dl-cdn.alpinelinux.org/mirrors.aliyun.com/g' /etc/apk/repositories`

* [Supervisor](http://supervisord.org)守护进程安装
> 需要注意的是, 在安装的容器创建时, 需要指定--init, 比如在node:alpine容器中, 不指定的话, 就会以node作为1号进程(我这里是在nodejs容器中实验的), 显然会造成大量的僵尸进程.
```shell script
apk add --no-cache supervisor
# 修改配置文件 /etc/supervisord.cond
vi /etc/supervisord.cond
# [unix_http_server]
# file=/run/supervisord.sock => file=/var/run/supervisord.sock
# ;chmod=0700 => chmod=0700
# [supervisord]
# pidfile=/run/supervisord.pid => pidfile=/var/run/supervisord.pid
# 可以看到该文件最下面, 有个 [include] file=/etc/supervisor.d/*.ini, 为了不使当前配置文件过大, 可以采用独立ini文件进行相关子进程配置
# 同时 /etc/init.d/supervisord也需要调整, 改一下pidfile
mkdir /etc/supervisor.d
```
   * 配置文件解析
   ```
   [unix_http_server]
   file=/tmp/supervisor.sock   ;UNIX socket 文件，supervisorctl 会使用
   ;chmod=0700                 ;socket文件的mode，默认是0700
   ;chown=nobody:nogroup       ;socket文件的owner，格式：uid:gid
   ;[inet_http_server]         ;HTTP服务器，提供web管理界面
   ;port=127.0.0.1:9001        ;Web管理后台运行的IP和端口，如果开放到公网，需要注意安全性
   ;username=user              ;登录管理后台的用户名
   ;password=123               ;登录管理后台的密码
   [supervisord]
   logfile=/tmp/supervisord.log ;日志文件，默认是 $CWD/supervisord.log
   logfile_maxbytes=50MB        ;日志文件大小，超出会rotate，默认 50MB，如果设成0，表示不限制大小
   logfile_backups=10           ;日志文件保留备份数量默认10，设为0表示不备份
   loglevel=info                ;日志级别，默认info，其它: debug,warn,trace
   pidfile=/tmp/supervisord.pid ;pid 文件
   nodaemon=false               ;是否在前台启动，默认是false，即以 daemon 的方式启动
   minfds=1024                  ;可以打开的文件描述符的最小值，默认 1024
   minprocs=200                 ;可以打开的进程数的最小值，默认 200
   [supervisorctl]
   serverurl=unix:///tmp/supervisor.sock ;通过UNIX socket连接supervisord，路径与unix_http_server部分的file一致
   ;serverurl=http://127.0.0.1:9001 ; 通过HTTP的方式连接supervisord
   ; [program:xx]是被管理的进程配置参数，xx是进程的名称
   [program:xx]
   command=/opt/apache-tomcat-8.0.35/bin/catalina.sh run  ; 程序启动命令
   autostart=true       ; 在supervisord启动的时候也自动启动
   startsecs=10         ; 启动10秒后没有异常退出，就表示进程正常启动了，默认为1秒
   autorestart=true     ; 程序退出后自动重启,可选值：[unexpected,true,false]，默认为unexpected，表示进程意外杀死后才重启
   startretries=3       ; 启动失败自动重试次数，默认是3
   user=tomcat          ; 用哪个用户启动进程，默认是root
   priority=999         ; 进程启动优先级，默认999，值小的优先启动
   redirect_stderr=true ; 把stderr重定向到stdout，默认false
   stdout_logfile_maxbytes=20MB  ; stdout 日志文件大小，默认50MB
   stdout_logfile_backups = 20   ; stdout 日志文件备份数，默认是10
   ; stdout 日志文件，需要注意当指定目录不存在时无法正常启动，所以需要手动创建目录（supervisord 会自动创建日志文件）
   stdout_logfile=/opt/apache-tomcat-8.0.35/logs/catalina.out
   stopasgroup=false     ;默认为false,进程被杀死时，是否向这个进程组发送stop信号，包括子进程
   killasgroup=false     ;默认为false，向进程组发送kill信号，包括子进程
   ;包含其它配置文件
   [include]
   files = relative/directory/*.ini    ;可以指定一个或多个以.ini结束的配置文件
   ```
   * 子进程配置文件
   ```
   #项目名
   [program:blog]
   #脚本目录
   directory=/opt/bin
   #脚本执行命令
   command=/usr/bin/python /opt/bin/test.py
   #supervisor启动的时候是否随着同时启动，默认True
   autostart=true
   #当程序exit的时候，这个program不会自动重启,默认unexpected，设置子进程挂掉后自动重启的情况，有三个选项，false,unexpected和true。如果为false的时候，无论什么情况下，都不会被重新启动，如果为unexpected，只有当进程的退出码不在下面的exitcodes里面定义的
   autorestart=false
   #这个选项是子进程启动多少秒之后，此时状态如果是running，则我们认为启动成功了。默认值为1
   startsecs=1
   #脚本运行的用户身份 
   user = test
   #日志输出 
   stderr_logfile=/tmp/blog_stderr.log 
   stdout_logfile=/tmp/blog_stdout.log 
   #把stderr重定向到stdout，默认 false
   redirect_stderr = true
   #stdout日志文件大小，默认 50MB
   stdout_logfile_maxbytes = 20MB
   #stdout日志文件备份数
   stdout_logfile_backups = 20
   ```
   * 启动/重启等操作
      * 启动 `supervisord -c /etc/supervisord.conf`
      * 重启 `supervisorctl restart`
      * 查看 `supervisorctl status`
      * 更新 `supervisorctl update`
      * 重启子程序 `supervisorctl reload`
   * 实践
      * 配置文件守护进程
      ```
      [program:api_documents]
      command=docsify serve -p 8085
      directory=/var/www/html/ApiDocuments
      numprocs=1
      autostart=true
      autorestart=true
      startsecs=3
      stopasgroup=true
      killasgroup=true
      ```
 
