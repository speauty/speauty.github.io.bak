#### 有关redis的一些安全配置 {docsify-ignore}

使用redis默认配置是非常危险的, 我开发过的一个网站就因使用了默认配置而被轻易中了挖矿病毒. 所以为了避免此类事情再次发生, 还是有必要修改默认配置的.

##### 指定redis运行用户
* `sudo useradd -s /bash/false -M redis`
##### 设置允许访问IP
* `bind 127.0.0.1`
##### 设置密码
* `requirepass your-password`
##### 禁止或更改命令名称
* `rename`
* `rename-command FLUSHALL ""`
* 需要注意的命令 `FLUSHALL`, `FLUSHDB`, `CONFIG`, `KEYS`, `SHUTDOWN`, `DEL`, `EVAL`
* 如果想使用被重命名的命令, 可以使用[`rawCommand`](https://github.com/phpredis/phpredis/#rawcommand)
##### 修改配置文件的权限
* `sudo chmod 600 redis.conf`
* `sudo chown redis redis.conf`
* 如果重启redis遇到 `Can't open the log file: Permission denied`, 就去更新下日志文件的所属者.