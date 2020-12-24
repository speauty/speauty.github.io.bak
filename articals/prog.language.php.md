# PHP(Hypertext Preprocessor) {docsify-ignore}

### 环境构建
?> 搭建运行环境, 确实对于初学者是一件不容易的事, 就老鸟而言, 还是一样不情愿, 每次创建个项目或调个代码什么的, 心情瞬间就不美丽. 为了解决这些情况, 于是就有了一键搭建环境的产品, 比如著名的PHPStudy和WAMPServer两款产品, 良好的界面体验和灵活配置, 赢得了市场的热爱. 但就对开发者本身而言, 是不利的, 比如漏洞, 比如完全不清楚运行机制, 真开发者成了搬运工, 是个人就会干的那种, 不利于个人的发展. 甚至, 有些做了多年的PHPer, 也没有Linux操作经验. 然而, 现在大多项目是需要搭建在Linux服务器上, 有人说, 有宝塔之类的产品, 这也是在弱化了开发者的能力. 我之前也用过这些产品, 体验很爽, 但是环境一出了什么问题, 就会手足无措, 偶尔装个扩展也比较生疏, 还得各种百度, 极大的浪费了时间和精力. 
当然, 也有人对自己搭建环境嗤之以鼻, 就说什么有现成的为什么不用, 为什么要去浪费时间之类的. 说句真的, 人生苦短, 总需要折腾点什么.

?> 在这里, 我不会再介绍这些一键搭建的产品, 而是采用docker(compose)或源码编译方式, 一一手动构建.

#### DOCKER构建
?> 非docker-compose方式

* 下载相应镜像
   * Nginx镜像: `docker pull nginx:alpine`
   * PHP镜像: `docker pull php:7.3-fpm-alpine`
* 创建容器
   * PHP容器: `docker run -it -d --restart=always -p 9000:9000 -v E:\EZGOAL:/var/www/html --name PHPEZGOAL php:7.3-fpm-alpine`
   ```
   需要将项目目录映射进容器(-v), 并且支持后台运行(-d)和自动重启(--restart=always) 
   ```
   * NGINX容器: `docker run -it -d -restart=always -p 8001:8001 -p 8002:8002 -p 8003:8003 -v  E:\EZGOAL:/var/www/html --name NGINXEZGOAL --link PHPEZGOAL:php73 nginx:alpine`
   ```
   和PHP容器大致相同, 只不过这里需要多几个端口映射, 
   因为映射的目录中包含了好几个项目, 所以就多开了几个端口, 以便访问不同的项目;
   由于项目需要访问php容器, 为了减少传输, 直接将PHP关联到当前容器(--link 容器名:别名)
   ```

#### 附录
* **Composer**

?> 由于大多PHP项目依赖composer管理各种扩展, 为解决这个问题, 需要PHP环境中单独安装composer, 不采用composer容器, 防止扩展需要单独安装的复杂性.

   1. `php -r "copy('https://install.phpcomposer.com/installer', 'composer-setup.php');"`
   2. `php composer-setup.php`
   3. `mv composer.phar /usr/local/bin/composer`
   4. `composer config -g repo.packagist composer https://mirrors.aliyun.com/composer/`

* **配置文件**
```
# fpm.conf
location ~ \.php?.*$
{
  # php-fpm.sock 路径
  fastcgi_pass   php73:9000;
  fastcgi_split_path_info  ^((?U).+\.php)(/?.+)$;
  fastcgi_param  SCRIPT_FILENAME  $document_root$fastcgi_script_name;
  fastcgi_param  PATH_INFO  $fastcgi_path_info;
  fastcgi_param  PATH_TRANSLATED  $document_root$fastcgi_path_info;
  include fastcgi_params;
}
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

