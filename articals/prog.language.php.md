# PHP(Hypertext Preprocessor) {docsify-ignore}

### 环境构建
?> 搭建运行环境, 确实对于初学者是一件不容易的事, 就老鸟而言, 还是一样不情愿, 每次创建个项目或调个代码什么的, 心情瞬间就不美丽. 为了解决这些情况, 于是就有了一键搭建环境的产品, 比如著名的PHPStudy和WAMPServer两款产品, 良好的界面体验和灵活配置, 赢得了市场的热爱. 但就对开发者本身而言, 是不利的, 比如漏洞, 比如完全不清楚运行机制, 真开发者成了搬运工, 是个人就会干的那种, 不利于个人的发展. 甚至, 有些做了多年的PHPer, 也没有Linux操作经验. 然而, 现在大多项目是需要搭建在Linux服务器上, 有人说, 有宝塔之类的产品, 这也是在弱化了开发者的能力. 我之前也用过这些产品, 体验很爽, 但是环境一出了什么问题, 就会手足无措, 偶尔装个扩展也比较生疏, 还得各种百度, 极大的浪费了时间和精力. 
当然, 也有人对自己搭建环境嗤之以鼻, 就说什么有现成的为什么不用, 为什么要去浪费时间之类的. 说句真的, 人生苦短, 总需要折腾点什么.

?> 在这里, 我不会再介绍这些一键搭建的产品, 而是采用docker(compose)或源码编译方式, 一一手动构建.

#### DOCKER构建
?> 非docker-compose方式
* 创建专属网络容器
```shell script
# 创建dev虚拟网络, 默认为bridge模式, 与宿主机可通信, 并处于该网络中的容器会形成一个容器内部局域网
docker create network dev
```
* 下载相应镜像
   * nginx镜像: `docker pull nginx:alpine`
   * php镜像: `docker pull php:7.3-fpm-alpine`
* 创建容器
```shell script
# 创建php容器
docker run -it -d --restart=always -p 9000:9000 -v /home/$USER/PHPScripts:/var/www/html --name php73 --network dev --network-alias php73 php:7.3-fpm-alpine
# 创建nginx容器
docker run -it -d -restart=always -p 80-88:80-88 -v  /home/$USER/PHPScripts:/var/www/html --name nginx --network dev --network-alias nginx nginx:alpine
# 两个容器需要映射相同的目录, 保证nginx转向php容器的资源一致
# 端口映射需要注意一点, 在win环境下, 好像不可以使用-表示连续端口映射
# 使用专属网络, 就可以不使用--link, 挂载专用解释器容器, 就和使用连接访问php解释器一致, 应该和--link相似
```
* 其他设置
   * 调整容器镜像源, 当前涉及容器系统一致, 均可使用`sed -i 's/dl-cdn.alpinelinux.org/mirrors.aliyun.com/g' /etc/apk/repositories`设置阿里源;
   * 配置nginx转php, 当前为php73-nginx版
   ```
   location ~ \.php?.*$
   {
     # php-fpm.sock
     fastcgi_pass   php73:9000;
     fastcgi_split_path_info  ^((?U).+\.php)(/?.+)$;
     fastcgi_param  SCRIPT_FILENAME  $document_root$fastcgi_script_name;
     fastcgi_param  PATH_INFO  $fastcgi_path_info;
     fastcgi_param  PATH_TRANSLATED  $document_root$fastcgi_path_info;
     include fastcgi_params;
   }
   ```
   * 设置php的composer, 该操作在对应的php容器中执行即可
   ```shell script
   php -r "copy('https://install.phpcomposer.com/installer', 'composer-setup.php');"
   php composer-setup.php
   mv composer.phar /usr/local/bin/composer
   composer config -g repo.packagist composer https://mirrors.aliyun.com/composer/
   ```

### 扩展安装

?> 现在安装扩展, 大致分为三种: docker容器安装, 编译安装和pecl安装

   * docker容器安装
      1. 采用脚本安装, 在容器里面主要有几个脚本, 这里单独介绍一下, 这个有很大的局限性, 就是只能安装在PHP源码扩展目录(/usr/src/php/ext/)中存在的扩展, 如果其他扩展的话，可以先将对应源码下载并解压到对应目录
         * `docker-php-source` PHP源代码的管理, 主要有解压和删除
         ```
         docker-php-source extract: 可将源代码解压至指定目录, 如果对应不存在的话
         docker-php-source delete: 删除解压的源代码目录
         ```
         * `docker-php-ext-enable` 开启扩展
         ```
         docker-php-ext-enable module-name[module-name...]: 开启指定扩展
         直接将对应扩展配置文件在php.ini中载入, 就相当开启扩展
         ```
         * `docker-php-ext-configure` 配置扩展
         ```
         docker-php-ext-configure 扩展名 配置参数
         这个是配置扩展编译时的参数, 好像对已编译好的扩展无效, 一般配合docker-php-ext-install使用
         ```
         * `docker-php-ext-install` 安装扩展
         ```
         docker-php-ext-install 扩展名
         ```

