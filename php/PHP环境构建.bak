##### PHP环境构建 {docsify-ignore}

> 为保持运行和开发环境的一致性, 和提高可迁移性, 现大多采用 Docker 构建环境, 一次构建, 多次多端使用, 也极大提高了部署效率.

至于 Docker 的安装和使用, 这里不再多说, 如果有不清楚的, 可以参考本站对应记录.

###### 以 Alpine 做为基础镜像的构建实践
首先, 先拉取最新的基础镜像`docker pull alpine:latest`, 并据此创建一个基础容器`docker run -it --privileged=true -p 80:80 --restart=always -d --name LNMP_APP alpine:latest`, 由于这里主要展示环境的构建, 便没有做目录和更多的端口映射.
 之后, 进入容器, 先换源`sed -i 's/dl-cdn.alpinelinux.org/mirrors.aliyun.com/g' /etc/apk/repositories && apk update && apk upgrade`.
 
对于对应目录也是需要规划的, 我这里主要目录是这样做的 `mkdir /www /www/wwwroot /www/services /www/wwwlogs /www/sources`. 创建对应的用户和组:
1. `addgroup -S nginx && adduser -D -S -h /var/cache/nginx -s /sbin/nologin -G nginx nginx`
2. `addgroup -S php-fpm && adduser -D -S -h /var/cache/php-fpm -s /sbin/nologin -G php-fpm php-fpm`

添加在编译时, 需要用到的类库, 大概就这些:
```bash
apk add --no-cache --virtual .build-deps gcc libc-dev make \
openssl-dev pcre-dev zlib-dev linux-headers curl perl-dev m4 \
libbz2 perl autoconf pkgconf dpkg-dev dpkg libmagic file libgcc \
libstdc++ binutils gmp isl libgomp libatomic mpfr3 musl-dev \
g++ re2c .phpize-deps libmcrypt-dev zlib-dev curl-dev \
libxml2-dev bzip2-dev

# 删除 apk del .build-deps
```

安装服务管理软件`apk add openrc --no-cache`, 简单配置一下`mkdir /run/openrc && touch /run/openrc/softlevel && /sbin/openrc`

* **OpenResty**

   1. 准备源码`wget https://openresty.org/download/openresty-1.15.8.3.tar.gz`
   2. 解压源码(在/www/sources目录下)`tar zxf openresty-1.15.8.3.tar.gz`
   3. 编译安装`./configure --prefix=/www/services/openresty --user=nginx --group=nginx && make && make install`
   4. 添加服务管理脚本nginx(在/etc/init.d目录下, 记得赋予可执行权限)
   ```bash
   #!/sbin/openrc-run
   
   description="Nginx http and reverse proxy server"
   extra_commands="checkconfig"
   extra_started_commands="reload reopen upgrade"
   
   cfgfile=${cfgfile:-/www/services/openresty/nginx/conf/nginx.conf}
   pidfile=/run/nginx.pid
   command=${command:-/www/services/openresty/nginx/sbin/nginx}
   command_args="-c $cfgfile"
   required_files="$cfgfile"
   
   depend() {
           need net
           use dns logger netmount
   }
   
   start_pre() {
           checkpath --directory --owner nginx:nginx ${pidfile%/*}
           $command $command_args -t -q
   }
   
   checkconfig() {
           ebegin "Checking $RC_SVCNAME configuration"
           start_pre
           eend $?
   }
   
   reload() {
           ebegin "Reloading $RC_SVCNAME configuration"
           start_pre && start-stop-daemon --signal HUP --pidfile $pidfile
           eend $?
   }
   
   reopen() {
           ebegin "Reopening $RC_SVCNAME log files"
           start-stop-daemon --signal USR1 --pidfile $pidfile
           eend $?
   }
   
   upgrade() {
           start_pre || return 1
   
           ebegin "Upgrading $RC_SVCNAME binary"
   
           einfo "Sending USR2 to old binary"
           start-stop-daemon --signal USR2 --pidfile $pidfile
   
           einfo "Sleeping 3 seconds before pid-files checking"
           sleep 3
   
           if [ ! -f $pidfile.oldbin ]; then
                   eerror "File with old pid ($pidfile.oldbin) not found"
                   return 1
           fi
   
           if [ ! -f $pidfile ]; then
                   eerror "New binary failed to start"
                   return 1
           fi
   
           einfo "Sleeping 3 seconds before WINCH"
           sleep 3 ; start-stop-daemon --signal 28 --pidfile $pidfile.oldbin
   
           einfo "Sending QUIT to old binary"
           start-stop-daemon --signal QUIT --pidfile $pidfile.oldbin
   
           einfo "Upgrade completed"
   
           eend $? "Upgrade failed"
   }
   ```
  5. 启动`service nginx start`
  6. 注意
      * 修改nginx.conf中user为 user nginx nginx
      * 注意nginx.pid在服务脚本和配置文件中的一致性
  
* **PHP**

   1. 准备源码`wget https://www.php.net/distributions/php-7.3.10.tar.bz2`
   2. 解压源码`tar xf php-7.3.10.tar.bz2`
   3. 编译安装
   ```bash
   ./configure --prefix=/www/services/php/73 \
    --enable-fpm --with-fpm-group=php-fpm --with-fpm-user=php-fpm \
    --with-openssl --with-mysqli=mysqlnd --with-pdo-mysql=mysqlnd \
    --with-bz2 --enable-exif --with-mhash --enable-mbstring --enable-sockets \
    && make && make install
   ```
   4. 配置文件调整
   ```bash
   cp php.ini-development /www/services/php/73/lib/php.ini
   cp /www/services/php/73/etc/php-fpm.conf.default /www/services/php/73/etc/php-fpm.conf
   # 并将其中的pid改为: pid = /run/fpm73.pid, 大概在17行
   
   cp /www/services/php/73/etc/php-fpm.d/www.conf.default /www/services/php/73/etc/php-fpm.d/www.conf
   # 做以下修改
   # 大概在23行: user = php-fpm
   # 大概在24行: group = php-fpm
   # 大概在36行: listen = /run/fpm73.sock
   # 大概在48行: listen.owner = php-fpm
   # 大概在49行: listen.group = php-fpm
   # 大概在50行: listen.mode = 0666
   ```
   5. 配置服务管理fpm73(在/etc/init.d目录下, 记得赋予可执行权限)
   ```bash
   #!/sbin/openrc-run
   
   # If you want to run separate master process per pool, then create a symlink
   # to this runscript for each pool. In that mode, the php-fpm daemon is started
   # as nobody by default. You can override the user (and group) by declaring
   # variable "user" and optionally "group" in conf.d file, or in the $fpm_config
   # file (the former has precedence).
   
   : ${name:="PHP FastCGI Process Manager"}
   
   command="/www/services/php/73/sbin/php-fpm"
   command_background="yes"
   start_stop_daemon_args="--quiet"
   pidfile="/run/fpm73.pid"
   retry="SIGTERM/20"
   
   # configtest is here only for backward compatibility
   extra_commands="checkconfig configtest"
   extra_started_commands="reload reopen"
   description_checkconfig="Run php-fpm config check"
   description_reload="Gracefully reload workers and config"
   description_reopen="Reopen log files"
   
   required_files="$fpm_config"
   
   depend() {
           need net
           use apache2 lighttpd nginx
   }
   ```
  6. 启动服务`serivce fpm73 start`
  7. 其他, 如果配置多版本PHP, 也是相同操作, 不过需要配置文件相应调整
  
* **关联Nginx和PHP**

在 /www/services/openresty/nginx/conf 下创建 fpm73.conf 配置文件
```bash
location ~ \.php?.*$
{
  fastcgi_pass   unix:/run/fpm73.sock;
  fastcgi_index  index.php;
  fastcgi_split_path_info  ^((?U).+\.php)(/?.+)$;
  fastcgi_param  SCRIPT_FILENAME  $document_root$fastcgi_script_name;
  fastcgi_param  PATH_INFO  $fastcgi_path_info;
  fastcgi_param  PATH_TRANSLATED  $document_root$fastcgi_path_info;
  include fastcgi.conf;
}
```

* **Composer**
1. `ln -f /www/services/php/73/bin/php /usr/local/bin/php`
2. `php -r "copy('https://install.phpcomposer.com/installer', 'composer-setup.php');"`
3. `php composer-setup.php`
4. `mv composer.phar /usr/local/bin/composer`
5. `composer config -g repo.packagist composer https://mirrors.aliyun.com/composer/`

关于服务自启问题尚未解决. 就这样, 完成了一个配置Nginx和PHP的容器, 然后打包成镜像, 上传到镜像仓库, 在其他机器下载就可以用了.

