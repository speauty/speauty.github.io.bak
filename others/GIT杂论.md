#### GIT 杂论 {docsify-ignore}

##### 1. 在win10操作系统上无法使用 `ssh-add` 命令
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