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

### 相关框架
#### Yet Another Framework
> 介绍, 巴拉巴拉......（以后再说）
##### 1. 准备环境
```shell script
# 下载相应扩展到指定目录 /usr/src/php/ext/
cd /usr/src/php/ext/
wget http://pecl.php.net/get/yaf-3.2.5.tgz && tar zxf yaf-3.2.5.tgz && mv yaf-3.2.5 yaf
docker-php-ext-install yaf
# 查看扩展安装情况
php --ri yaf
yaf
yaf support => enabled
Version => 3.2.5
Supports => http://pecl.php.net/package/yaf
Directive => Local Value => Master Value
# 全局类库的目录路径
yaf.library => no value => no value
# 环境名称, 当用INI作为Yaf的配置文件时, 这个指明了Yaf将要在INI配置中读取的节的名字
yaf.environ => product => dev
yaf.forward_limit => 5 => 5
# 开启的情况下, Yaf将会使用命名空间方式注册自己的类, 比如Yaf_Application将会变成Yaf\Application
yaf.use_namespace => 1 => 1
yaf.action_prefer => 0 => 0
yaf.lowcase_path => 0 => 0
# 开启的情况下, Yaf在加载不成功的情况下, 会继续让PHP的自动加载函数加载, 从性能考虑, 除非特殊情况, 否则保持这个选项关闭
yaf.use_spl_autoload => 0 => 0
# 在处理Controller, Action, Plugin, Model的时候, 类名中关键信息是否是后缀式
yaf.name_suffix => 1 => 1
# 在处理Controller, Action, Plugin, Model的时候, 前缀和名字之间的分隔符, 默认为空
yaf.name_separator => no value => no value
# 后续清理
rm yaf-3.2.5.tgz
# 配置IDE代码提示(该操作是在宿主机中执行)
cd ~/IDESupports && git clone https://github.com/xudianyang/yaf.auto.complete.git
```
##### 2. 创建项目
* 遵循官方要求, 创建如下目录结构形式
```
public
   index.php //入口文件
   .htaccess //重写规则    
   css
   img
   js
conf
   app.ini //配置文件
bootstrap // 自定义Bootstrap目录
app
   controllers
      Index.php //默认控制器
   views    
      index   //控制器
        index.phtml //默认视图
   modules //其他模块
   library //本地类库
   models  //model目录
   plugins //插件目录
```
* 配置nginx
```
server {
    listen       8004;
    listen  [::]:8004;
    #charset koi8-r;
    access_log  /var/log/nginx/access.yaf.log;
    error_log  /var/log/nginx/error.yaf.log;
    root /var/www/html/STU_YAF/public;
    index index.php;
    include fpm73.conf;
    location / {
 	    index index.php;
        if (!-e $request_filename) {
            rewrite ^/(.*)  /index.php/$1 last;
        }
    }
}
```
* 配置IDE语法支持(本处使用PHPStorm)
   * 下载对应插件 https://github.com/xudianyang/yaf.auto.complete;
   * 打开phpstorm中的项目, 点击`External Libraries`, 选择`Configure PHP Include Paths`;
   * 在`Inlude Path`添加一行记录, 选择对应插件目录(已解压);
   * 重启IDE生效(如果为linux系统, 需要设置对应插件目录及内部文件所属者为登陆账户, 或设置744权限);


##### 3. 框架使用
   1. 配置
      * 全局配置, 在php配置文件中添加, 主要有`php --ri yaf`查看到的配置, 在上面已经有所介绍;
      * 项目配置(在conf/app.ini中配置)
         * application.directory 项目绝对路径, 这个是必须配置的, 否则会报致命错误;
         * application.ext php脚本的扩展名称, 默认值为php, 这个一般不用管;
         * application.bootstrap Bootstrap路径(绝对路径), 如果需要自定义实现, 这个倒是可以使用到的;
         * application.library 本地(自身)类库的绝对目录地址, 默认值application.directory + "/library";
         * application.baseUri 在路由中, 需要忽略的路径前缀, 一般不需要设置, Yaf会自动判断;
         * application.dispatcher.defaultModule 默认访问模块, 默认值Index;
         * application.dispatcher.defaultController 默认控制器, 默认值IndexController;
         * application.dispatcher.defaultAction 默认动作, 默认值indexAction;
         * application.dispatcher.throwException 在出错的时候, 是否抛出异常, 默认值True;
         * application.dispatcher.catchException 是否使用默认的异常捕获Controller, 如果开启, 在有未捕获的异常的时候, 控制权会交给ErrorController的errorAction方法, 可以通过$request->getException()获得此异常对象, 默认值False;
         * application.view.ext 视图文件后缀;
         * application.modules 声明存在的模块名, 请注意, 如果你要定义这个值, 一定要定义Index Module, 默认值Index;
         * application.system.* 通过这个属性, 可以修改yaf的runtime configure, 比如application.system.lowcase_path, 但是请注意只有PHP_INI_ALL的配置项才可以在这里被修改, 此选项从2.2.0开始引入;
      * 可以使用:语法继承相关配置节点, 比如dev:mysql, 同名覆盖, 采用dev当前节点下的值;
      * @todo ini配置数组值, 好像不怎么好使;
      * 可通过 `\Yaf\Application::app()->getConfig()` 获取当前框架启动注册的配置, 后续也可使用对象注册表(`\Yaf\Registry`)进行存取;
      * 在添加配置时, 尽量按实际需求单独设置节点(可灵活组合), 具体环境继承实现(同名覆盖), 如下:
      ```
      [app]
      application.directory=ROOT_PATH "/app"
      ;application.library=ROOT_PATH "/app/library"
      ;redis节点
      [redis]
      port="3306"
      host="127.0.0.1"
      ;mysql节点
      [mysql]
      host="localhost"
      ;其他配置节点
      [conf]
      si="conf"
      ;应用节点 位于前面的配置项会覆盖后面同级同名配置项
      ;按照规则, dev节点中的host应为redis节点的host
      [dev:conf:redis:mysql:app]
      ```
   2. 自定义Bootstrap类实现
   
      ?> 为什么要自定义实现? 这是一个很简单的问题, 框架的初始化, 需要大量的初始化配置, 不可能全部怼在 `public/index.php`, 既然框架提供了自定义启动的功能, 就没有不用的道理, 比如数据库连接/缓存初始化/独立配置文件引入, 以及路由等具有特殊化的处理. 毕竟每个项目都有不同的业务架构, 这种扩展框架不可能设计太多内容的, 所以极大部分还是靠开发的自定义实现.
       
      ?> Bootstrap类的规则, 具体类可通过`application.bootstrap`指定, 类名固定`Bootstrap`, 在应用run之前, 执行(依次)自定义类中的`__init`打头的方法, 并且这类方法都可以接收一个`\Yaf\Dispatcher`实例.
       
      * 在对应配置中设置 `application.bootstrap=ROOT_PATH "/bootstrap/AppBootstrap.php"`, 继承 `\Yaf\Bootstrap_Abstract`;
      * 将 `public/index.php` 中的 `$app->run()` 改为 `$app->bootstrap()->run()`
      * 自定义Bootstrap类demo, 依次输出 `int(111) int(222) `:
      ```php
      <?php
      /**
       * Project: STU_YAF
       * File: AppBootstrap.php
       * User: ${USER}
       * Email: Your Email
       * date: 2020-12-2020/12/30 14:43:08
       */
      declare(strict_types=1);
      /**
       * Class Bootstrap
       * @description 自定义Bootstrap类
       * 初始化操作
       * * 引入 vendor/autoload.php
       * * 注册各种配置到对象注册树
       * * 载入本地类库
       * * 开启session
       * * 初始化mysql/redis等连接实例
       * * 初始化插件(中间件)
       * * 初始化路由
       * * 初始化分发器
       */
      class Bootstrap extends Bootstrap_Abstract
      {
          public function _initVendor()
          {
              /** 可进行文件存在性检测 */
              Loader::import(ROOT_PATH.'/vendor/autoload.php');
          }
      
          public function _initConf()
          {
              /** 将config注册到Registry */
              /** @var Ini $appConf */
              $appConf = app()->getConfig();
              Registry::set('ini.conf', $appConf);
          }
      
          public function _initSession()
          {
              Registry::set('session', Session::getInstance()->start());
          }
      
          public function _initLocalClass()
          {
              /** @var Ini $conf */
              $conf = Registry::get('ini.conf');
              Loader::getInstance()->registerLocalNamespace(explode(',', $conf->get('library.local.prefix')));
          }
      
          public function _initServices()
          {
              /** @var Ini $conf */
              $conf = Registry::get('ini.conf');
              /** 注册mysql连接实例 */
              $mysqlArr = $conf->get('mysql');
              foreach ($mysqlArr as $key => $mysql) {
                  Global_LocalMysql::setDB($mysql->toArray(), $key, true);
              }
              unset($mysqlArr);
          }
      }
      ```
   3. 设置数据库(mysql)(redis同理)连接实例
      * mysql
      ```
      # 不违背轻量级框架的特性, 采用Medoo类, 安装如下
      composer require catfan/medoo
      # 这里仅引入了该类, 但为了操作的便捷性, 需要进行一层封装(引入的大多数第三方都需要作处理)
      ```
      ```php
      <?php
      /**
       * Project: STU_YAF
       * File: LocalMysql.php
       * User: }
       * Email: 
       * date: 2020-12-2020/12/30 16:46:44
       */
      // app\library\Global\LocalMysql.php
      declare(strict_types=1);
      use Medoo\Medoo;
      use Yaf\Registry;
      /**
       * Class Global_LocalMysql
       * 必须在类名前加上路径, 因为这是本地类目录下的Global, 
       */
      class Global_LocalMysql
      {
          /** @var string 默认注册名称 */
          private static $defaultRegistryName = 'mysql';
      
          /**
           * @param array $conf
           * @param string $name
           * @param bool $isForceInit
           */
          public static function setDB(array $conf, string $name = 'mysql', bool $isForceInit = false):void
          {
              $name = $name?:self::$defaultRegistryName;
              if ($isForceInit || !self::getDB($name) instanceof Medoo) {
                  Registry::set($name, new Medoo($conf));
              }
          }
      
          /**
           * @param string $name
           * @return Medoo|null
           */
          public static function getDB(string $name = 'mysql'):?Medoo
          {
              return Registry::get($name?:self::$defaultRegistryName)??null;
          }
      }
      ```
   4. 插件(Plugin)
   
   ?> 插件, 类见中间件, 只不过稍微要多一些控制节点. 可在 Bootstrap 中进行注册 `$dispatcher->registerPlugin(new IndexPlugin());`, 对应类文件放在默认插件目录下 `app/plugins`, 需要注意的时, `preDispatch`和`postDispatch`可能存在多次调用, 如果动作里面有`$this->forward()`. 如果动作存在输出, 会及时返回, 并不会在`dispatchLoopShutdown`后面. `preResponse`暂时没走到.
   
   ```php
   <?php
   /**
    * Project: STU_YAF
    * File: Index.php
    * User: 
    * Email: 
    * date: 2020-12-2020/12/31 13:40:04
    */
   declare(strict_types=1);
   use Yaf\{Plugin_Abstract, Request_Abstract, Response_Abstract};
   /**
    * Class IndexPlugin
    * 针对IndexController 🙈不分模块
    */
   class IndexPlugin extends Plugin_Abstract
   {
   
       /**
        * 路由之前触发
        * @param Request_Abstract $request
        * @param Response_Abstract $response
        * @return mixed|void
        */
       public function routerStartup(Request_Abstract $request, Response_Abstract $response)
       {
           var_dump(__METHOD__.PHP_EOL);
       }
   
       /**
        * 路由结束后触发
        * @param Request_Abstract $request
        * @param Response_Abstract $response
        * @return mixed|void
        */
       public function routerShutdown(Request_Abstract $request, Response_Abstract $response)
       {
           var_dump(__METHOD__.PHP_EOL);
       }
   
       /**
        * 分发循环开始之前被触发
        * @param Request_Abstract $request
        * @param Response_Abstract $response
        * @return mixed|void
        */
       public function dispatchLoopStartup(Request_Abstract $request, Response_Abstract $response)
       {
           var_dump(__METHOD__.PHP_EOL);
       }
   
       /**
        * 分发之前触发
        * @param Request_Abstract $request
        * @param Response_Abstract $response
        * @return mixed|void
        */
       public function preDispatch(Request_Abstract $request, Response_Abstract $response)
       {
           var_dump(__METHOD__.PHP_EOL);
       }
   
       /**
        * 分发结束之后触发
        * @param Request_Abstract $request
        * @param Response_Abstract $response
        * @return mixed|void
        */
       public function postDispatch(Request_Abstract $request, Response_Abstract $response)
       {
           var_dump(__METHOD__.PHP_EOL);
       }
   
       /**
        * 分发循环结束之后触发 此时表示所有的业务逻辑都已经运行完成, 但是响应还没有发送
        * @param Request_Abstract $request
        * @param Response_Abstract $response
        * @return mixed|void
        */
       public function dispatchLoopShutdown(Request_Abstract $request, Response_Abstract $response)
       {
           var_dump(__METHOD__.PHP_EOL);
       }
   
       /**
        * 这个方法暂时没跑起来, 不知道是什么原因
        */
       public function preResponse(Request_Abstract $request, Response_Abstract $response)
       {
           var_dump(__METHOD__.PHP_EOL);
       }
   }
   ```
      
         
### 相关站点
1. [PHP官方站点](https://www.php.net)
2. [PHP扩展站点](https://pecl.php.net/)
3. [PHPComposer站点](https://packagist.org/)
4. [Yet Another Framework](https://www.laruence.com/manual/)
5. [Medoo](https://medoo.in/)

