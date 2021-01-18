# 开发杂记 {docsify-ignore}

1. 在Jetbrains IDE中设置php脚本文件头部描述
   * 快捷键 `Ctrl+Alt+s` 打开设置(也可通过菜单`File => Settings`打开), 搜索 `File and Code Templates`;
   * 点击 `Inlude` 选中 `PHP File Header` 设置, 下面有各种变量注释, 我这里分享一个个人常用配置, 保存应用即可:
   ```
   /**
     * Project: ${PROJECT_NAME}
     * File: ${FILE_NAME}
     * User: ${USER}
     * Email: Your Email
     * date: ${YEAR}-${MONTH}-${DATE} ${HOUR}:${MINUTE}:${SECOND}
     */
     // 开启严格模式
     declare(strict_types=1);
   ```
   
2. 在Ubuntu安装redis
```shell script
# 下载redis安装包
wget https://download.redis.io/releases/redis-6.0.9.tar.gz
# 解压在当前目录
tar -zxf redis-6.0.9.tar.gz
sudo mv redis-6.0.9 /usr/local/redis
cd /usr/local/redis/
# adlist.c:32:10: fatal error: stdlib.h: 没有那个文件或目录
# 换国外源, 重装gcc
# zmalloc.h:50:10: fatal error: jemalloc/jemalloc.h: 没有那个文件或目录
# make MALLOC=libc
# sentinel.c:34:10: fatal error: openssl/ssl.h: 没有那个文件或目录
# sudo apt-get install libssl-dev
# cc: error: ../deps/hiredis/libhiredis_ssl.a: 没有那个文件或目录
# make distclean
make MALLOC=libc && sudo make install
cd ./utils
# 注释以下代码
#bail if this system is managed by systemd
#_pid_1_exe="$(readlink -f /proc/1/exe)"
#if [ "${_pid_1_exe##*/}" = systemd ]
#then
#       echo "This systems seems to use systemd."
#       echo "Please take a look at the provided example service unit files in this directory, and adapt and install them. Sorry!"
#       exit 1
#fi
#unset _pid_1_exe
sudo ./install_server.sh
sudo systemctl enable redis_6379
```

3. 在Ubuntu安装node
```shell script
wget https://nodejs.org/dist/v14.15.4/node-v14.15.4-linux-x64.tar.xz
xz -d node-v14.15.4-linux-x64.tar.xz
tar -xf node-v14.15.4-linux-x64.tar
sudo mv node-v14.15.4-linux-x64 /usr/local/node
cd /usr/local/node
# 换淘宝源
npm config set registry https://registry.npm.taobao.org
echo export PATH="/usr/local/node/bin:$PATH" >> /etc/profile
```

4. 在Ubuntu安装nginx
```shell script
sudo useradd -l -M -U -s /sbin/nologin nginx
sudo apt-get install openssl libssl-dev libpcre3-devel zlib1g-dev
wget http://nginx.org/download/nginx-1.18.0.tar.gz
tar -zxf nginx-1.18.0.tar.gz
cd nginx-1.18.0
./configure --prefix=/usr/local/nginx --user=nginx --group=nginx
sudo make && sudo make install
echo export PATH="/usr/local/nginx/sbin:$PATH" >> /etc/profile
vim /usr/lib/systemd/system/nginx.service
sudo chmod 755 /usr/lib/systemd/system/nginx.service
sudo systemctl daemon-reload
```
```
[Unit]
Description=nginx
After=network.target
[Service]
Type=forking
ExecStart=/usr/local/nginx/sbin/nginx
ExecReload=/bin/kill -s HUP $MAINPID
ExecStop=/bin/kill -s QUIT $MAINPID
PrivateTmp=true
[Install]
WantedBy=multi-user.target
```

5. 安装带freetype的php-gd
```shell script
# 下载freetype, 因为通过apt install libfreetype6-dev行不通, 就只好单独安装了
sudo wget https://download.savannah.gnu.org/releases/freetype/freetype-2.9.tar.gz
sudo tar zxf freetype-2.9.tar.gz
cd freetype-2.9 
./configure --prefix=/usr/include/freetype && make && sudo make install
# 然后切到php源码目录的ext/gd下
/usr/local/php/bin/phpize
./configure --with-php-config=/usr/local/php/bin/php-config --with-freetype-dir=/usr/include/freetype
make && make install
# 在php.ini添加一条记录 extension=gd, 重启php-fpm即可
```