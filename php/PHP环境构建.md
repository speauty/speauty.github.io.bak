### PHP环境构建 {docsify-ignore}
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
   * NGINX容器: ``

* ##### 
* **Composer**
1. `ln -f /www/services/php/73/bin/php /usr/local/bin/php`
2. `php -r "copy('https://install.phpcomposer.com/installer', 'composer-setup.php');"`
3. `php composer-setup.php`
4. `mv composer.phar /usr/local/bin/composer`
5. `composer config -g repo.packagist composer https://mirrors.aliyun.com/composer/`
