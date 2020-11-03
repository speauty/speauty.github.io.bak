# [GIT](https://git-scm.com/) 杂论 {docsify-ignore}

## Git 是什么?
> Git 是一种免费开源的版本控制系统. 基于此, 有 Gitlab / Github 等软件源代码托管服务平台.

## 有关 Git 的安装
* ### Windows操作系统
 
    需单独下载[安装包(点击可进入下载页面)](https://git-scm.com/download/win)进行安装, 我这里已经下好了安装包, 因为每次下载都相对较慢, 所以本地一直保留了安装包. 如果遇到什么解决不了的问题, 可以直接卸载重新安装, 大多都可以这样处理, 就和Windows出毛病一样. 具体指导, 隔两天空了再行补充.
   1. 下载安装包并点击执行, 阅读相关信息后, 点击 `Next` 进入下一步选择安装路径;
   2. 在选择安装路径时, 为了避免重装系统的数据丢失, 尽量选择系统盘之外的其他盘, 本机采用的是SSD+HDD, 为了提高运行速度, 我这里特意将该软件安装了 `D` 盘(从SSD分离出来的, 具有高效的读写), 全路径 `D:\Git`. 我这里是安装过才卸载, 目录没删除干净, 安装程序会提醒目录已存在是否强制覆盖, 点击确定就好了, 如果不确定的话, 就选择新建一个目录;
   3. 这一步是在选择需要安装组件, 我这边只需要 `git` 命令, 其他都不需要, 所以只勾了三个, 一个是大文件支持( `Git LFS` )和两个文件关联的组件, 不熟悉的朋友建议勾选 `Git Bash Here` 和 `Git GUI Here`, 可以支持界面操作;
   4. 是否创建启动目录, 还是为了节约和没有太高的重要性, 我勾选了 `Don't create a Start Menu floder`, 这个不太重要, 看自己需要;
   5. 选择默认编辑器, 我这里使用了默认的vim编辑器, 不熟悉的话, 可以选择自己熟悉的编辑器, 不过还是推荐使用的默认编辑器(vim), 文本编辑器, 快, 而且在使用 `Linux` 操作系统必备的一个技能;
   6. 调整环境变量, 我选择了第二个
      * `Use Git from Git Bash only`: 仅支持在 `Git Bash` 中使用 `Git`? 这是开玩笑的吧, 可以直接过掉的.
      * `Git from command line and also from 3rd-party software`: 这个选项的话, 支持在 `Git Bash` , 终端以及 `PowerShell` 中使用, 似乎这一层都足够了;
      * `Use Git and optional Unix tools from the Command Prompt`: 会加到系统环境, 并且会对自带的一些命令造成影响, 不建议使用.
   7. 为 `Git` 选择 `HTTPS` 的后台通道, 这块不太熟悉, 我采用了默认的选项
      * `Use the OpenSSL library`: 使用 `OpenSSL` 类库;
      * `Use the native Windows Secure Channel library`: 选择 `Windows` 原生的.
   8. 选择每行结束符的处理方式, 我这里是在 `Windows` 系统上使用, 那自然选择的是第一种, 也就是默认值
      * `Checkout Windows-style, commit Unix-style line endings`: 拉下来的代码会转成 `CRLF`, 提交会转成 `LF`;
      * `Checkout as-is, commit Unix-style line endings`: 不会对拉下来的代码做什么处理, 但是在提交的时候, `CRLF(Windows-style)` 会转成`LF(Unix-style)`;
      * `Checkout as-is, commit as-is`: 是什么样就什么样的, 跨系统时很容易出问题.
   9. 配置在使用 `Git Bash` 的仿真器, 我选择了瘟都死的控制台
      * `Use MinTTY(the default terminal of MSYS2)`: 使用 `Cygwin` 或 `MSYS2` 环境的终端虚拟器, 怎么行呢? 要单独下载安装? 我是拒绝的;
      * `Use Windows's default console windows`: 使用 `Windows` 自带的终端 `Terminal`.
   10. 配置其他选项, 不熟悉, 基本上采用默认的, 然后点击 `Install`, 执行安装.
      * `Enable file system caching`: 激活文件系统缓存;
      * `Enable Git Credential Manager`: 激活凭证存储;
      * `Enable symbolic links`: 激活符号链接?
   11. 测试一下, 随便打开一个 `Windows Terminal`, 键入 `git --version`, 可显示当前版本, 如果没有找到对应命令的话, 建议看下系统环境变量中是否包含 `D:\Git\cmd` (指向安装目录下的 `cmd` 目录), 没有的话, 及时加上. 已存在的情况, 可以尝试重启, 可能环境变量更新未生效. 
* ### Linux操作系统
    
    众所周知, Linux系的操作系统真是太多了, 我也才用过几个, 基本上是Ubuntu那类的具有良好桌面的. 当然不同的Linux操作系统可能具备不同的包管理器, 我这里主要说一下apt的安装方法, 其他大体相似的, 就一条命令 `(sudo) apt install git`, 等程序跑完就可以通过 `git --versioin`检测一下当前是否安装成功, 顺便也可以看一下当前安装的版本号.

* ## `GIT` 配置

?> `GIT` 配置有三种层次: `system(系统级别)` `global(用户级别)` `local(仓库级别)`, 优先级: `local` > `global` > `system`, 本节主要用到的命令: `ssh-keygen` `ssh-add` `ssh-agent` `ssh` `git`.

* 常用的设置相关命令
   * 查看所有设置 `git config --global[system|local] --list`;
   * 查看指定设置 `git config --global[system|local] key`;
      * 查看用户名称(邮箱) `git config --global user.name[email]`;
   * 更新设置 `git config --globale key "value"`
      * 更新用户名称(邮箱) `git config --global user.name[email] "name or email"`

* 生成密钥对
```
ssh-keygen -b 1024 -t RSA -f ~/.ssh/new_id_rsa -C "speauty"
 -b  密钥长度, 采用1024bit得密钥对, 最长为4096
 -t  密钥类型, 可以选择 DSA|ECDSA|ED25519|RSA
 -f  密钥文件路径及名称
 -C  备注信息
```
* 向目标机发送公钥
   * `ssh-copy-id -i ~/.ssh/id_rsa.pub -p 22 root@ip(目标主机和账号)`
* 密钥对管理: 把专用密钥添加到 `ssh-agent` 的高速缓存中
   * `ssh-add -l[L]`: 查看 `ssh-agent` 中所有密钥(公钥);
   * `ssh-add -d ~/.ssh/id_rsa`: 从 `ssh-agent` 中删除指定密钥;
   * `ssh-add -D`: 从 `ssh-agent` 中删除所有密钥;
   * `ssh-add ~/.ssh/id_rsa`: 添加密钥;
   * `ssh-add -xX`: 对 `ssh-agent` 进行加锁(解锁);
   * `ssh-add -t time ~/.ssh/id_rsa`: 对加载的密钥设置超时时间, 对于超时的密钥, 将自动从 `ssh-agent` 卸载
   * `ssh-add -e[s] pkcs11`: 删除(添加)PKCS#11共享库pkcs11提供的钥匙.
* `ssh-agent`: 控制用来保存公钥身份验证所使用的私钥的程序, 如果直接在终端输入 `ssh-agent` 可显示当前使用的环境和变量, `ssh-agent bash` 可将当前bash挂到`ssh-agent`下, 可解决找不到对应ssh-agent程序的问题.
* 完整实践流程
```cmd
# (开启Windows Terminal)生成密钥文件
ssh-keygen -t rsa -f ~/.ssh/your_rsa -C 'your@email.com'
# 将指定密钥文件加入 ssh-agent
# 如果失败 Could not open a connection to your authentication agent, 那就直接输入 ssh-agent bash, 然后再进行与ssh-add相关的操作
ssh-add ~/.ssh/your_rsa
# 查看是否加入成功, 没有的话, 重新加一次
ssh-add -l
# 将相应公钥考到对应目标站点 ~/.ssh/your_rsa.pub
# 检测是否配对成功(这里以github为例)
ssh -vT git@github.com
# 假设这里已存在一个目录 Res, 进行初始化操作
git init
git remote add origin git@domain:res.git
git fetch --all
# 如果这里出现 ssh: connect to host domain port 22: Connection timed out, 那问题应该就是无法锁定ssh-agent程序, 可以 ssh-agent bash后再进行操作
# 不过这里有个超级麻烦的问题, 就是每次进入ssh-agent都要反复设置密钥, 好像之前设置的没有保留.
# 的确是个大问题.
```

* 解决乱码问题
   * `git status` 乱码: `git config --global core.quotepath false` `git config --global i18n.logoutputencoding utf-8`
   * `git log` 乱码: `git config --global i18n.commitencoding utf-8`
   * 如果是Linux系统，需要设置环境变量 `export LESSCHARSET=utf-8`
