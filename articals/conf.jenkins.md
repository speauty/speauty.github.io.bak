# Jenkins配置 {docsify-ignore}

### 构建服务
#### Docker构建
1. 拉取镜像 `docker pull jenkins/jenkins`
2. 创建容器 `docker run -d -u root -p 10240:8080 -p 10241:50000 --name jenkins --network dev --network-alias jenkins jenkins/jenkins:latest`
3. 查看密码 `docker logs jenkins`
    ```text
    Jenkins initial setup is required. An admin user has been created and a password generated.
    Please use the following password to proceed to installation:
    
    82f3c048d704402c86f90f384e9e3d9a
    
    This may also be found at: /var/jenkins_home/secrets/initialAdminPassword
    ```
4. 默认推荐配置安装即可，不过由于网络原因，会导致大部分插件下载失败。这里需要改个配置，在 `系统管理 => 插件管理 => 高级 => 升级站点` 中，输入 `http://mirrors.tuna.tsinghua.edu.cn/jenkins/updates/update-center.json` 即可，重新选择相应插件更新重启即可。

### 相关问题
相关命令未找到。
```shell
#!/bin/bash -ilex
source /etc/profile
```