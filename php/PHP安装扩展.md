##### PHP安装扩展

首先来了解一下什么是扩展, 扩展主要指增加或增强原工具功能而产生的一种辅助性工具, 这里的PHP扩展也就是为增加或增强PHP的一种功能性扩展, 比如`bcmath`, 官网就是这样介绍的:

?> which supports numbers of any size and precision up to 2147483647 (or 0x7FFFFFFF) decimals, if there is sufficient memory, represented as strings.

另外介绍一个网站, PHP的扩展仓库网站: [pecl](http://pecl.php.net/), 上面有很多扩展, 而且如果你有技术, 也可以自己开发扩展, 发布到这个网站.

接下来还是说说怎么安装扩展吧, 归根结底, 编译, 其实`pecl`这种方式主要是针对已被收录到网站的扩展, 那么没有被收录的呢? 还是只有编译安装, 我可以大胆猜测`pecl install`应该是进一步抽象的产物, 求证是不可能求证的.
所以这里我主要还是说最原始的方式, 编译, 针对Linux系统. Windows安装扩展, 也简单提一下, 下载对应扩展的ddl到ext目录下, 在配置文件中加上对应扩展就差不多了.

大体上, 有这么几个步骤, 下载对应的扩展, 建立外挂, 配置编译安装, 修改配置文件, 最后重启服务, 就好了. 举几个例子来说明一下, 当前是在alpine容器中进行中进行操作的.

###### phpredis扩展
- 下载: `wget http://pecl.php.net/get/redis-5.2.2.tgz`
- 解压并进入对应目录: `tar xf redis-5.2.2.tgz && cd redis-5.2.2`
- 建立外挂, 生成configure: `/www/services/php/73/bin/phpize`
- 配置编译安装: `./configure --with-php-config=/www/services/php/73/bin/php-config && make && make install`
- 修改配置, 在php.ini中加上`extension=redis`
- 检测扩展: `php --ri=redis`

###### xlswriter扩展
- 下载: `git clone https://github.com/viest/php-ext-excel-export.git`
- 更新子模块: `git submodule update --init`
- 建立外挂, 生成configure: `/www/services/php/73/bin/phpize`
- 配置编译安装: `./configure --with-php-config=/www/services/php/73/bin/php-config --enable-reader && make && make install`
- 修改配置, 在php.ini中加上`extension=xlswriter`
- 检测扩展: `php --ri=xlswriter`

差不多, 一个模式. 安装扩展后, 需要重启php-fpm服务.
