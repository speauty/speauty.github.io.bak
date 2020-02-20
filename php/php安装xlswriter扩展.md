#### php安装xlswriter扩展 {docsify-ignore}

由于之前英文, 所以就直接删了, 只好重新做一份关于php安装xlswriter扩展的记录, 其实在官方也有安装步骤.

##### 查看系统 {docsify-ignore}
* `uname -a` <font color=gray size=2>Linux speauty-computer 4.15.0-76-generic #86-Ubuntu SMP Fri Jan 17 17:24:28 UTC 2020 x86_64 x86_64 x86_64 GNU/Linux
</font>

##### 安装扩展 {docsify-ignore}
* 安装依赖 `sudo apt-get install zlib1g-dev`
* 采用拉取版本仓库下载安装包 `git clone https://github.com/viest/php-ext-excel-export.git`
* 更新子模块 `git submodule update --init`
* 建立外挂模块 `phpize`
* 配置安装 `./configure`
* 编译 `sudo make`
* 安装 `sudo make install`
* 在 `php.ini` 中, 新增 `extension=xlswriter`
* 测试 `php --ri=xlswriter`

具体使用, 参考[xlswriter官方文档](https://xlswriter-docs.viest.me/).