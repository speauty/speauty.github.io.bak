# [GIT](https://git-scm.com/) 杂论 {docsify-ignore}

## Git 是什么?
> Git 是一种免费开源的版本控制系统. 基于此, 有 Gitlab / Github 等软件源代码托管服务平台.

## 有关 Git 的安装



## 在win10操作系统上无法使用 `ssh-add` 命令
具体表现是在终端下, 添加ssh-key回显为`Error connecting to agent: No such file or directory`, 我们就来看下具体服务.

在终端下键入 `get-server ssh*`:
```cmd
Status   Name               DisplayName
------   ----               -----------
```
显然, 没有对应服务, 需要使用`Set-Service -Name ssh-agent -StartupType Manual`进行配置, 并启动`Start-Service ssh-agent`, 这两步需要在具有管理员权限的终端下操作.

再看一下 `get-service ssh*`:
```cmd
Status   Name               DisplayName
------   ----               -----------
Running  ssh-agent          OpenSSH Authentication Agent
```
基本上就好了, 可以使用`ssh-add`添加新的配置, 可以使用`ssh-add -l`查看已有的配置项.

不过最终还是挂掉, 采用`git bash`替代windows terminal, 可以解决`ssh-agent`进程无法锁定的问题. 关于`ssh-agent`引发的问题可以参考[在 PowerShell 中正确配置 git 与 OpenSSH](https://www.cielyang.com/%E5%9C%A8-powershell-%E4%B8%AD%E6%AD%A3%E7%A1%AE%E9%85%8D%E7%BD%AE-git-%E4%B8%8E-openssh/)
