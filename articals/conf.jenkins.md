# Jenkins配置 {docsify-ignore}

### 构建服务
#### Docker构建
1. 拉取镜像 `docker pull jenkins/jenkins`
2. 创建容器 `docker run -d -p 10240:8080 -p 10241:50000 --name jenkins --network dev --network-alias jenkins jenkins/jenkins:latest`
3. 查看密码 `docker logs jenkins`
    ```text
    Jenkins initial setup is required. An admin user has been created and a password generated.
    Please use the following password to proceed to installation:
    
    27062936d5f3428c8e0c63121a035bc3
    
    This may also be found at: /var/jenkins_home/secrets/initialAdminPassword
    ```
4. 默认推荐配置安装即可