#### Go实习生 {docsify-ignore}

##### 00. 上回说道
假的, 一切都是假的. 

> 当前使用系统 `Linux version 4.15.0-76-generic (buildd@lcy01-amd64-029) (gcc version 7.4.0 (Ubuntu 7.4.0-1ubuntu1~18.04.1)) #86-Ubuntu SMP Fri Jan 17 17:24:28 UTC 2020`

##### 01. 安装Go环境
* 下载源码包 `sudo wget https://studygolang.com/dl/golang/go1.13.6.linux-amd64.tar.gz`
* 解压至指定文件夹 `sudo tar -zxf go1.13.6.linux-amd64.tar.gz -C /usr/local`
* 配置环境变量
   * 编辑 `/etc/profile` 添加以下内容 `export GO_ROOT=/usr/local/go; export PATH=$PATH:$GO_ROOT/bin;` 需要重启生效;
   * 编辑 `~/.bashrc` 添加和上面一样的内容, 然后执行 `source ~/.bashrc` 即可生效;
* 测试一下
```shell script
go version
# go version go1.13.6 linux/amd64
```
* 和世界打声招呼
   * 编辑脚本 hello.go, 执行 `go run hello.go`, 即可.
   ```
   package main
   
   import "fmt"
   
   func main() {
     fmt.Println("hello world")
   }
   ```

##### 02. 安装GoLand
* 下载 `wget https://download.jetbrains.8686c.com/go/goland-2019.3.2.tar.gz`
* 解压 `tar -zxf goland-2019.3.1.tar.gz GoLand-2019.3.1/`
* 转移文件 `sudo mv GoLand-2019.3.1 /opt/GoLand`
* 准备破解包, [点击下载](../source/jetbrains-agent.jar ':include :type=code :ignore');
* 更新 `goland.vmoptions` 和 `goland64.vmoptions` 文件, 在 `/opt/GoLand/bin` 下. 分别在两个文件末尾加上这样一句 `-javaagent:jetbrains-agent.jar`
* 先就命令执行一下 `/opt/GoLand/bin/goland.sh`, 选择 `Activation code`, 并填入激活码, 这个就自行百度了, 我这里有一个, [点击查看](../source/active.txt ':include :type=code :ignore');
* 设置快捷方式, 主要有两种:
   * 设置软链接 `sudo ln -s /opt/GoLand/bin/goland.sh /usr/bin/goland` , 在搜索框一搜就出来了, 可以拖动图标到桌面或任务栏;
   * 软件提供的工具 `tools => create desktop entry`, 也可实现.
* [详细破解参考](https://zhile.io/2018/08/19/jetbrains-license-server-crack.html).