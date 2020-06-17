#### PHP源码学习 {docsify-ignore}

空闲之余, 持续学习《PHP 7底层设计与源码实现》. 虽然最近PHP 8的消息不少, 不过了解PHP 7的设计也是可以理解. 早有此打算, 断断续续的, 没个正形.

##### 00. 提前准备
* 创建运行容器和本地目录
```bash
// 个人本地源码映射目录为: /E/Docker/SourceCode
docker run -it --privileged=true -p 99:80 -v /E/Docker/SourceCode:/usr/local/src --name PHPSourceCode --init -d --restart=always centos:7
// 下载PHP安装包
cd /usr/local/src
wget http://cn2.php.net/distributions/php-7.1.0.tar.gz
tar -zxf php-7.1.0.tar.gz
```
* 编译安装PHP
```bash
cd php-7.1.0
yum install -y make gcc gcc-devel libxml2-devel
./configure --prefix=/usr/local/src/php-7.1.0/output --enable-fpm
make && make install
cp php.ini-development ./output/lib/php.ini
```
* 安装源码查看软件`Source Insight`, 网上自行查找安装

##### 01. 整体认识

* PHP是一种弱类型**解释型**语言. 弱类型表明, 变量类型不固定, 比如可以将数组赋给原先保存字符串的变量, 这样在计算比较时, 会发生一些类型的隐式转换. 解释型语言是指在源代码不会直接转成机器码, 而是要经过特定的虚拟机翻译, 并且该过程发生在运行过程中. 相对于编译型语言来说, 慢也在这里, 但也比较灵活.

* 执行原理, 主要有以下这几步:

  1. 词法分析([Re2c](http://re2c.org/)): 将源代码转换成Token(有意义的标识, 在PHP源码中php-7.1.0\Zend\zend_language_parser.h可查看对应Token值);
  2. 语法分析([Bison](https://www.gnu.org/software/bison/)): 将Token和合符文法规则(BNF, 巴科斯范式)的代码生成抽象语法树(AST);
  3. AST生成opcode(指令标识, 存在与之对应的句柄, 虚拟机实际执行的是opcode对应的句柄), 被虚拟机执行.

  这里便有这么一个关系: 源代码 => Token => AST => Opcode => 虚拟机 => 机器码.