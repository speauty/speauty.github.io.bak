# 开发杂记 {docsify-ignore}

1. 在Jetbrains IDE中设置php脚本文件头部描述
   * 快捷键 `Ctrl+Alt+s` 打开设置(也可通过菜单`File => Settings`打开), 搜索 `File and Code Templates`;
   * 点击 `Inlude` 选中 `PHP File Header` 设置, 下面有各种变量注释, 我这里分享一个个人常用配置, 保存应用即可:
   ```
   /**
     * Project: ${PROJECT_NAME}
     * File: ${FILE_NAME}
     * User: ${USER}
     * Email: Your Email
     * date: ${YEAR}-${MONTH}-${DATE} ${HOUR}:${MINUTE}:${SECOND}
     */
     // 开启严格模式
     declare(strict_types=1);
   ```
   
2. 在Ubuntu安装redis
```shell script
# 下载redis安装包
wget https://download.redis.io/releases/redis-6.0.9.tar.gz
# 解压在当前目录
tar -zxf redis-6.0.9.tar.gz
sudo mv redis-6.0.9 /usr/local/redis
cd /usr/local/redis/utils
vim install_server.sh
# 注释以下代码
#bail if this system is managed by systemd
#_pid_1_exe="$(readlink -f /proc/1/exe)"
#if [ "${_pid_1_exe##*/}" = systemd ]
#then
#       echo "This systems seems to use systemd."
#       echo "Please take a look at the provided example service unit files in this directory, and adapt and install them. Sorry!"
#       exit 1
#fi
#unset _pid_1_exe

```