##### 如何搭建本地文档服务
1. 全局安装`docsify`: `npm i docsify-cli -g`
2. 创建保存文档的目录, 这里以 `docs` 为例
3. 进入目录, 进行初始化: `docsify init`
4. 启动服务: `docsify serve -p port[default: 3000]`
5. 通过`http://localhost:port`访问

##### Docker构建环境
1. 安装基础镜像: `docker pull alpine:latest`
2. 创建容器: `docker -d -p 3000:3000 -v DOC_DIR:/projects --name docsify alpine:latest`
3. 更新源: `sed -i 's/dl-cdn.alpinelinux.org/mirrors.aliyun.com/g' /etc/apk/repositories`
4. 安装`npm`: `apk add npm`
5. 后续步骤就和在本地构建文档服务一样的

[docsify传送门](https://docsify.js.org/#/zh-cn/)