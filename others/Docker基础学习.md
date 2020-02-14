> 在ubuntu 18.04尝试的

##### 安装 Docker {docsify-ignore}
```bash
> # 安装docker
> sudo apt-get install docker
> sudo apt-get install docker.io

> # 检测docker版本信息
> docker version 
Client:
 Version:           18.09.7
 API version:       1.39
 Go version:        go1.10.4
 Git commit:        2d0083d
 Built:             Fri Aug 16 14:19:38 2019
 OS/Arch:           linux/amd64
 Experimental:      false

Server:
 Engine:
  Version:          18.09.7
  API version:      1.39 (minimum version 1.12)
  Go version:       go1.10.4
  Git commit:       2d0083d
  Built:            Thu Aug 15 15:12:41 2019
  OS/Arch:          linux/amd64
  Experimental:     false
> # 简单查看docker版本号.
> docker -v
Docker version 18.09.7, build 2d0083d

> # 使用systemctl管理docker服务
```

##### 免sudo使用补充 {docsify-ignore}
```bash
> # 添加docker用户组
> sudo groupadd docker
> # 将当前用户加入docker组
> sudo gpasswd -a ${USER} docker
> # 重启docker
> sudo systemctl restart docker 或 sudo service docker restart
> # 切换用户, 使配置生效
> su root && su {USER}
```

##### 获取镜像 {docsify-ignore}
```bash
> # 从Docker Hub镜像源下载镜像
> # registry-注册服务器, 默认使用Docker Hub服务.
> # NAME-镜像名 TAG-镜像标签,默认为latest.
> docker pull [registry]NAME[:TAG]
> # -a, --all-tags=true|false: 是否获取仓库中的所有镜像, 默认false.
> # 比如, 下载centos 7.6.1810版本.
> docker pull centos:7.6.1810
7.6.1810: Pulling from library/centos
ac9208207ada: Pull complete 
Digest: sha256:62d9e1c2daa91166139b51577fe4f4f6b4cc41a3a2c7fc36bd895e2a17a3e4e6
Status: Downloaded newer image for centos:7.6.1810
> 
```
##### 查看镜像信息 {docsify-ignore}
```bash
> # 查看已有镜像的信息
> docker images
> # 更多参数, 使用 man docker images查看.

> # 使用docker tag为本地镜像任意添加新的标签, 相当于链接(快捷方式)
> # NEWNAME必须全为小写字母, 否则会报错.
Error parsing reference: "localCentOS:76" is not a valid repository/tag: invalid reference format: repository name must be lowercase
> docker tag NAME:TAG NEWNAME:NEWTAG
> docker tag centos:7.6.1810 local-centos:76
> # 上面那个镜像的镜像ID还是保持一致的, 可以看出docker tag只是添加了一个快捷方式, 并不影响实际文件.

> # 使用inspect查看详细信
> # 使用docker inspect可以获取该镜像的详细信息, 包括制作者/适应架构/各层的数字摘要等.
> docker inspect NAME:TAG
> # 可使用参数-f指定其中一项内容.
> docker inspect local-centos:76 -f {{".Architecture"}}

> # 查看镜像历史
> # 使用history列出各层的创建信息.
> docker history local-centos:76
> # 不过由于过长被自动截断, 可添加--no-trunc显示完整.

> # 搜索镜像
> # 带keyword关键字的镜像
> docker search keyword
> --filter 增加过滤项.
> is-automated=true 仅显示自动创建的镜像, 默认false.
> stars=3 指定仅显示评价为指定星级以上的镜像, 默认0.
> --no-trunc=true 输出信息不截断显示 默认false.
> docker search --filter=is-automated=true --no-trunc=true nginx
> docker search --filter=stars=3 --no-trunc=true nginx
```

##### 删除镜像 {docsify-ignore}
```bash
> # 使用标签删除镜像
> docker rmi NAME:TAG
> # 该操作只是删除对应镜像多个标签中的指定标签, 并不影响镜像文件.

> 使用ID删除镜像
> docker rmi ID

> 如果有依赖该镜像创建的容器, 需要先进行删除, 再删除相应镜像, 尽量不要使用-f进行强行删除.
```

##### 创建镜像 {docsify-ignore}
```bash
> 基于已有镜像的容器创建
> docker run -it local-centos:76 /bin/bash
> # 先启动一个容器, 做点操作, 然后记住容器ID, 退出即可.
> docker commit -m '提交信息' -a '作者信息' 容器ID NAME:TAG
> # -m 提交信息 -a 作者信息 -p 提交时暂停容器运行.
> docker commit -m 'add a file' -a 'Speauty' 3c4eaad406c4 test:0.1
> sha256:352aafab413b1177cb779d58b88666ac2305a1c6d5bfcc357c8ea8d237b6d26f
> # 创建成功的话, 会返回新镜像的一个Id值.

> 基于本地模板导入
> # 要直接导入一个镜像, 可以使用[OpenVZ](http://openvz.org/Download/templates/precreated)提供的模板来创建, 或者用其他已导出的镜像模板创建.
> cat ubuntu-14.04-x86_64-minimal.tar.gz | docker import - ubuntu:14.04
```

##### 存出和载入镜像 {docsify-ignore}
```bash
> # 存出镜像
> docker save -o image.tar NAME:TAG
> docker save -o centos76.tar local-centos:76

> # 导入镜像
> docker load --input image.tar
> docker load < image.tar
> docker load < centos76.tar
> Loaded image: local-centos:76
```

##### 上传镜像 {docsify-ignore}
```bash
> docker push NAME:TAG [registry]NAME:TAG
> # 在上传之前, 可以先使用 docker tag 为镜像添加新标签.
> docker tag local-centos:76 hub-user-name/remote-repository-name:tag
> docker push hub-user-name/remote-repository-name:tag
> # 如果没登录, 会提示被拒绝, 使用 docker login 进行登录, 再重新上传, 一般问题都不大.
> # 默认上传到 [hub-docker](https://hub.docker.com/)
```

##### 创建容器 {docsify-ignore}
```bash
> # 新建容器
> docker create -it NAME:TAG
> # 使用 docker create新建的容器处于停止状态, 需要使用docker run来进行启动.

> # 启动容器
> docker run 容器ID

> # 新建并启动容器
> docker run local-centos:76 /bin/echo 'hello world'
> # -t 让docker分配一个伪终端(pseduo-tty)并绑定到容器的标准输入上,
> # -i 让容器的标准输入保持打开
> # -d 可在后台运行
> docker run -it local-centos:76 /bin/bash
> # Ctrl+d或输入exit退出容器

> # 停止容器
> docker stop 容器ID
> # docker ps -qa 可看到所有容器的ID.
> # 处于终止态的容器, 可使用docker start 来启动.
> # docker restart 会将一个运行态的容器先终止, 然后再重新启动它.
```

##### 进入容器 {docsify-ignore}
```bash
> # attach进入
> docker attach CONTAINER-ID
> # --detach-keys=[] 指定退出attach,模式的快捷键序列, 默认时Ctrl+p Ctrl+q.
> # --no-stdin=true|false 是否关闭标准输入, 默认是保持打开.
> # --sig-proxy=true|false 是否代理收到系统信号给应用程序, 默认为true.
> # 当多个窗口同时使用attach命令连到一个容器的时候, 所有窗口都会同步显示.
> # 当某个窗口因命令阻塞时, 其他窗口也无法执行操作.

> # exec进入
> docker exec -it CONTAINER-ID COMMAND
> # -i 打开标准输入接受用户输入命令, 默认false.
> # --privileged=true|false 是否给执行命令以高权限 默认false.
> # -t 分配伪终端 默认 false.
> # -u,--user='' 执行命令的用户名或ID.
> docker exec -it 16c78f8e3e11 /bin/bash
```

##### 删除容器 {docsify-ignore}
```bash
> # 删除处于终止态或退出状态的容器
> docker rm [-f] [-l] [-v] CONTAINER-ID
> # -f 是否强行终止并删除一个运行中的容器;
> # -l 删除容器的连接, 但保留容器;
> # -v 删除容器挂载的数据卷;
> # 默认情况下, docker rm 命令只能删除处于终止或退出状态的容器, 并不能删除处于运行状态的容器;
> # 如果要删除一个运行中的容器, 可以添加-f参数. docker会先发送SIGNKILL信号给容器, 终止其中的应用, 之后强行删除.
``` 

##### 导入和导出容器 {docsify-ignore}
```bash
> # 导出容器
> # -o 指定导出的tar文件名
> docker export -o tarPath CONTAINER-ID
> # 直接通过重定向存到文件
> docker export CONTAINER-ID > tarPath

> # 导入容器
> docker import tarPath - REPOSITORY/NAME:TAG
> # 将导出的文件使用docker import导入变成镜像
```
##### Docker Hub 公共镜像市场 {docsify-ignore}
```bash
> # 登录
> docker login
> # 用户在登录后可通过docker push将本地镜像推送到docker hub

> # 配置自动创建
> # 1. 创建并登录docker hub, 以及目标网站;在目标网站中连接账户到docker;
> # 2. 在docker hub中配置一个自动创建;
> # 3. 选取一个目标网站中的项目(需要含docker file)和分支;
> # 4. 指定dockerfile的位置, 并提交创建

> # 时速云的注册服务器地址 index.tenxcloud.com
```

##### 创建本地私有仓库 {docsify-ignore}
```bash
> # 使用Registry镜像创建私有仓库
> # 自动下载并启动一个registry容器, 创建本地的私有仓库服务
> docker run -d -p 5000:5000 registry
> # 默认情况下, 会将仓库创建在容器的/tmp/registry目录下, 可以通过-v参数来将镜像文件存放在本地的指定路径(必须为小写字母)
> docker run -d -p 5000:5000 -v /opt/data/registry:/tmp/registry registry
```

##### 数据卷 {docsify-ignore}
```bash
> # 容器中管理数据主要的两种方式
> 数据卷: 容器内数据直接映射到本地主机环境
> 数据卷容器: 使用特定容器维护数据卷

> # 1. 在容器内创建一个数据卷
> # 使用-v标记可以在容器内创建一个数据卷, 可重复使用
> # -P是将容器服务暴露的端口, 是自动映射到本地主机的临时端口
> docker run -d -P --name test -v /testwww local-centos:76
> # 创建一个容器, 并创建一个数据卷挂在到容器的/testwww目录

> # 2. 挂载一个主机目录作为数据卷
> # 使用-v标记也可以指定挂载一个本地的已有目录到容器中去作为数据卷
> docker run -d -P --name test -v /src/testwww:/opt/testwww local-centos:76
> # 加载主机的/src/testwww目录到容器的/opt/testwww目录
> # 本地目录的路径必须是绝对路径, 如果目录不存在, docker会自动创建
> # docker挂在数据卷的默认权限是读写(rw), 也可通过ro指定为只读, 容器内对所挂载数据卷内的数据就无法修改了
> docker run -d -P --name test -v /src/testwww:/opt/testwww:ro local-centos:76

> # 3. 挂载一个本地主机文件作为数据卷
> # -v标记也可以从主机挂载单个文件到容器中作为数据卷
> docker run --rm -it -v ~/.bash_history:/.bash_history local-centos:76 /bin/bash
```

##### 数据卷容器 {docsify-ignore}
```bash
> # 数据卷容器也是一个容器, 但是它的目的是专门用来提供数据卷供其他容器挂载

> # 创建一个数据卷容器, 并创建一个数据卷挂载
> # 在其他容器中使用-volumes-from可以挂载数据卷容器的数据卷
> docker run -it -v /dbdata --name db local-centos:76 /bin/bash
> # 创建两个挂载数据卷容器数据卷的其他容器容器
> docker run -it --volumes-from db --name test_db1 local-centos:76 
> docker run -it --volumes-from db --name test_db2 local-centos:76
> # 可以多次使用--volumes-from从多个容器挂载多个数据卷. 还可以从其他已挂载的容器卷的容器来挂载数据卷

> # 使用--volumes-from参数所挂载数据卷的容器自身并不需要保持在运行状态
> # 如果删除了挂载的容器(包括db/test_db1/test_db2), 数据卷并不会被自动删除. 如果要一个数据卷, 必须在删除最后一个还挂载着它的容器时显示使用docker rm -v命令来指定同时删除关联的容器
> # 使用数据卷容器可以让用户在容器之间自由地升级和移动数据卷

> # 利用数据卷容器来迁移数据
> # 1. 备份
> docker run --columes-from db -v $(pwd):/backup --name worker local-centos:76 tar cvf /backup/backup.tar /dbdata
> # $(pwd) 当前路径
> # tar cvf 仅打包不压缩, 这里是将/dbdata目录打包到/backup/backup.tar文件中, 通过数据卷共享到本地

> # 2. 恢复
> # 先创建一个带数据卷的容器
> docker run -v /dbdata --name db local-centos:76 /bin/bash
> # 再创建一个新容器, 挂载db的容器, 并使用untar解压备份文件到所挂载的容器卷中
> docker run --volumes-from db -v $(pwd):/backup busybox tar xvf /backup/backup.tar
```

docker允许映射容器内应用的服务端口到本地宿主主机

互联机制实现多个容器间通过容器名来快速访问

##### 端口映射实现访问容器 {docsify-ignore}
```bash
> # 1. 从外部访问容器应用
> # 在启动容器时, 如果不指定对应的参数, 在容器外部是无法通过网络来访问容器内的网络应用和服务的
> # 可以通过-P或-p参数来指定端口映射, 当使用-P标记时, Docker会随机映射一个49000~49900的端口到内部容器开放的网络端口
> # -p 可以指定要映射的端口, 并且在一个指定端口上只可以绑定一个容器, 支持的格式:
> # IP:Hostport:ContainerPort | IP::ContainerPort | HostPort:ContainerPort
> docker run -it -d -P --name test local-centos:76
> docker run -it -d -p 127.0.0.1:54335:54335 --name testp local-centos:76
> # 可以使用 docker logs -f container-name

> # 2. 映射所有接口地址
> # 使用HostPort:ContainerPort格式将本地的5000端口映射到容器的5000端口
> docker run -it -d -p 5000:5000 --name testp local-centos:76
> # 默认会绑定本地所有接口上的所有地址, 可多次使用-p标记绑定多个接口

> # 3. 映射到指定地址的指定端口
> # 使用IP:Hostport:ContainerPort格式指定映射使用一个特定地址
> docker run -it -d -p 127.0.0.1:54335:54335 --name testp local-centos:76

> # 4. 映射到指定地址的任意端口
> # 使用IP::ContainerPort绑定localhost的任意端口到容器的5000端口, 本地主机会自动分配一个端口
> docker run -it -d -p 127.0.0.1::5000 --name testp local-centos:76
> # 还可以使用udp标记来指定udp端口
> docker run -it -d -p 127.0.0.1::5000/udp --name testp local-centos:76

> # 5. 查看端口配置
> docker port Container-name [ContainerPort]

> # 容器有自己的内部网络和IP地址, 使用docker inspect ContainerId可以获取容器的具体信息
```

##### 互联机制实现便捷互访 {docsify-ignore}
```bash
> # 容器的互联是一种让多个容器中应用进行快速交互的方式
> # 它会在源和接受容器之间创建连接关系, 接受容器可以通过容器名快速访问到源容器, 而不用指定具体的IP地址

> # 1. 自定义容器命名
> # 连接系统依据容器的名称来执行, 容器的名称是唯一的
> # 使用--name标记可以为容器自定义命名
> # 可以使用docker inspect -f "{{.Name}}" ContainerId来查看容器的名字

> # 在执行docker run的时候如果添加--rm标记, 则容器在终止后会立刻删除. 注意, --rm和-d参数不能同时使用

> # 2. 容器互联
> # 使用--link参数可以让容器之间安全地进行交互
> # 还是和之前操作一样, 创建一个数据库容器
> docker run -it -d --name db local-centos:76
> # 创建一个新的容器, 并将它连接到db容器
> docker run -it -d -P --name web --link db:db local-centos:76
> # --link name:alias, 其中name是要连接的容器名称, alias是这个连接的别名
> # 使用env命令来查看web容器的环境变量
> # 其中DB_开头的环境变量是提供web容器连接db容器使用的, 前缀采用大写的连接别名
> # 除了环境变量外, docker还添加了host信息到父容器的/etc/hosts文件

> # 用户可以连接多个子容器到父容器, 比如可以连接多个web到同一个db容器上
```

##### Dockerfile {docsify-ignore}
```bash
> # Dockerfile是一个文本格式的配置文件, 用户可以使用Dockerfile来快速创建自定义镜像
> # Dockerfile由一行行命令语句组成, 并且支持以#开头的注释行, 一般分为四部分
> # 基础镜像信息, 维护者信息, 镜像操作指令和容器启动时执行指令

> # 1. 指令说明
> # 1.1 FROM
> # 指定所创建镜像的基础镜像, 如果本地不存在, 则默认会去Docker Hub下载指定镜像
> # 格式 FROM <image> 或 FROM <image>:<tag> 或 FROM <image>@<digest>
> # 任何Dockerfile中的第一条指令必须为FROM指令. 如果在同一个Dockerfile中创建多个镜像, 可以使用多个FROM指令(每个镜像一次)
> # 1.2 MAINTAINER
> # 指定维护者信息, 格式为 MAINTAINER <name>, 该信息会写入生成镜像的Author属性域中
> # 1.3 RUN
> # 运行指定命令
> # 格式RUN <command> 或 RUN ["executable", "param1", "param2"], 后一个指定会被解析为Json数组, 因此必须用双引号
> # 前者默认将在shell终端(bin/sh -c)中运行命令; 后者使用exec执行, 不会启动shell环境. 指定使用其他终端类型可以通过第二种方式实现
> # 每条RUN指令将在当前镜像的基础上执行指定命令, 并提交为新的镜像. 当命令较长时可以使用\来换行
> # 1.4 CMD
> # CMD指令用来指定启动容器时默认执行的命令, 主要有三种格式
> # CMD ["executable", "param1", "param2"]使用exec执行
> # CMD command param1 param2在/bin/sh中执行, 提供给需要交互的应用
> # CMD ["param1", "param2"]提供给ENTRYPONIT的默认参数
> # 每个Dockerfile只有有一条CMD命令. 如果指定了多条命令, 只有最后一条会被执行
> # 如果用户启动容器时手动指定了运行的命令(作为run的参数), 则会覆盖掉CMD指定的命令
> # 1.5 LABEL
> # LABEL指令用来指定生成镜像的元数据标签信息
> # 格式 LABEL <key>=<value> <key>=<value>...
> # 1.6 EXPOSE
> # 声明镜像内服务所监听的端口, EXPOSE <port> [<port>...]
> # 该指令只是起到声明作用, 并不会自动完成端口映射
> # 在启动容器时需要使用-P, Docker主机会自动分配一个宿主机的临时端口转发到指定的端口; 使用-p, 则可以具体指定哪个宿主机的本地端口会映射过来
> # 1.7 ENV
> # 指定环境变量, 在镜像生成过程中会被后续RUN指令使用, 在镜像启动的容器中也会存在
> # 格式 ENV <key><value>或ENV <key>=<value>
> # 指令指定的环境变量在运行时可以被覆盖掉, 如docker run --env <key>=<value> test
> # 1.8 ADD
> # 该命令将复制指定的<src>路径下的内容到容器中的<dest>路径下, ADD <src> <dest>
> # 其中<src>可以是Dockerfile所在目录的一个相对路径(文件或目录), 也可以是一个URL, 也可以是一个tar文件(如果为tar文件, 会自动解压到<dest>路径下).
> # <dest>可以是镜像内的绝对路径, 或相对于工作目录(WORKDIR)的相对路径
> # <src>路径支持正则格式
> # 1.9 COPY
> # 将本地<src>路径下的内容复制到镜像中<dest>路径下, COPY <src> <dest>
> # 复制本地主机的<src>(为Dockerfile所在目录的相对路径,文件或目录)下的内容到镜像中的<dest>下,. 目标路径不存在时, 会自动创建
> # 1.10 ENTRYPOINT
> # 指定镜像的默认入口命令, 该入口命令会在启动容器时作为根命令执行, 所有传入值作为该命令的参数, 支持两种格式
> # ENTRYPOINT ["executable", "param1", "param2"] (exec调用执行)
> # ENTRYPOINT command param1 param2 (shell中执行)
> # 此时, CMD指令指定值作为根命令的参数
> # 每个Dockerfile中只能有一个ENTRYPOINT, 当指定多个时, 只有最后一个有效
> # 在运行时, 可以被--entrypoint参数覆盖掉, 如docker run --entrypoint
> # 1.11 VOLUME
> # 创建一个数据卷挂载点, VOLUME ["/data"]
> # 可以从本地主机或其他容器挂载数据卷, 一般用来存放数据库和需要保存的数据等
> # 1.12 USER
> # 指定运行容器时的用户名后UID, 后续的RUN等指令也会使用指定的用户身份, USER daemon
> # 当服务不需要管理员权限时, 可以通过该命令指定运行用户, 并且可以在之前创建所需要的用户
> # RUN groupadd -r test && useradd -r -g test test
> # 要临时获取管理员权限可以使用gosu或sodu
> # 1.13 WORKDIR
> # 为后续的RUN,CMD和ENTRYPOINT指令配置工作目录, WORKDIR /path/to/workdir
> # 可以使用多个WORKDIR指令, 后续命令如果参数是相对路径, 则会基于之前命令指定的路径\
> # 1.14 ARG
> # 指定一些镜像内使用的参数, 这些参数在执行docker build命令时才以--build-arg<varname>=<vallue>格式传入, ARG <name>[=<default value>]
> # 可以用docker build --build-arg<name>=<value>, 来指定参数值
> # 1.15 ONBUILD
> # 配置当所创建的镜像作为其他镜像的基础镜像时, 所执行的创建操作指令, ONBUILD [INSTRUCTION]
> # 使用ONBUILD指令的镜像, 最好在标签中注明, name-onbuild
> # 1.16 STOPSIGNAL
> # 指定所创建镜像启动的容器接收退出的信号值, STOPSIGNAL=signal
> # 1.17 HEALTHCHECK
> # 配置所启动容器如何进行健康检查, 主要有两种格式
> # HEALTHCHECK [OPTIONS] CMD command: 根据所执行命令返回值是否为0来判断
> # HEALTHCHECK NONE: 禁止基础镜像中的健康检查
> # --interval=DURATION(默认30s), 检查周期
> # --timeout=N(默认30s), 每次检查等待结果的超时
> # --reties=N(默认为3), 重试次数
> # 1.18 SHELL
> # 指定其他命令使用shell时的默认shell类型, SHELL ["/bin/sh", "-c"]

> # 对于windows系统, 建议在Dockerfule开头添加# escape=`来指定转义信息

> # 2. 创建镜像
> # 编写完Dockerfile之后, 可以通过docker buid命令来创建镜像, 基本格式为docker build [选项] 内容路径
> # 该命令将读取指定路径下(包括子目录)的Dockerfile, 并将该路径下的所有内容发送给Docker服务端, 由服务端来创建镜像.
> # 因此, 除非生成镜像需要, 否则一般建议放置Dockerfile的目录为空目录
> # 如果使用非内容路径下的Dockerfile吗可以通过-f选项来指定其路径
> # 要指定生成镜像的标签信息, 可以使用-t选项

> # 3. 使用.dockerignore文件
> # 可以通过.dockerignore文件(每一行添加一条匹配模式)来让Docker忽略匹配模式路径下的目录和文件
```

##### 操作系统 {docsify-ignore}
```bash

> # BusyBox "Linux系统的瑞士军刀"
> # busybox是一个集成了一百多个最常用Linux命令和工具(如cat, echo, grep,mount,telnet等)的精简工具箱, 只有几MB的大小, 可以很方便的进行各种快速验证
> # 可运行于多款POSIX环境的操作系统中, 如Linux()包括Android, Hurd, FreeBSD等
> docker pull busybox:latest

> # Alpine
> # Alpine操作系统是一个面向安全的轻型Linux发行版, 不同于通常的Linux发行版, Alpine采用了musl libc和BusyBox以减小系统的体积和运行时资源消耗, 但功能上比BusyBox又完善得多
> # 在保持瘦身的同时, Alpine还提供了自己的包管理工具apk, 具体软件安装包可在https://pkgs.alpinelinux.org/packages查询

> # Debian/Ubuntu
> # Debian是由GPL和其他自由软件许可协议授权的自由软件组成的操作, 由Debian Project组织维护
> # Ubuntu是一个以桌面应用为主的GUN/Linux操作系统, 其名称来自非洲南部祖鲁语或豪萨语的"ubuntu"一词, 基于Debian发行版和GNOME/Unity桌面环境
> # 与Debian的不同在于它每6个月会发布一个新版本, 每2年会推出一个长期支持版本, 一般支持3年

> # CentOS/Fedora
> # CentOS和Fedora都是基于Redhat的常见Linux分支. CentOS是目前企业级服务器的常用操作系统; Fedora主要面向个人桌面用户
```

##### 为镜像添加SSH服务 {docsify-ignore}
```bash
> # 1. 基于commit命令创建
> docker run -it -d --privileged=true --name tsshd local-centos:76 /usr/sbin/init
> # 此处加入特权模式，否则容器中systemctl命令使用时会有D-Bus服务连接失败的报错
> docker exec -it ContainerId /bin/bash
> # 进入系统后, 更新yum, \
> yum update
> yum install openssh-server openssh-clients -y
> vi /etc/ssh/sshd_config
> # UsePAM yes => UsePAM no
> # UsePAM yes => UsePAM no
> # 注释HostKey /etc/ssh/ssh_host_ecdsa_key
> # 注释HostKey /etc/ssh/ssh_host_ed25519_key
> # 设置容器root用户密码
> systemctl start sshd.service
> systemctl enable sshd.service
> # 处理好了,就退出, 照之前的操作提交镜像

> 2. 使用Dockerfile创建
> Dockerfile centos
FROM centos:latest
MAINTAINER speauty (speauty@163.com)
RUN yum install openssh-server openssh-clients -y \
    && yum clean all \
    && sed -i 's/UsePAM yes/UsePAM no/g' /etc/ssh/sshd_config \
    && sed -i 's/HostKey \/etc\/ssh\/ssh_host_ecdsa_key/#HostKey \/etc\/ssh\/ssh_host_ecdsa_key/g' /etc/ssh/sshd_config \
    && sed -i 's/HostKey \/etc\/ssh\/ssh_host_ed25519_key/#HostKey \/etc\/ssh\/ssh_host_ed25519_key/g' /etc/ssh/sshd_config \
    && ssh-keygen -t rsa -b 2048 -f /etc/ssh/ssh_host_rsa_key \
    && echo "root:0000"|chpasswd
EXPOSE 22
CMD ["/usr/sbin/sshd", "-D"]

> Dockerfile ubuntu
FROM ubuntu:latest
MAINTAINER speauty <speauty@163.com>
RUN apt-get update \
    && apt-get install -y openssh-server \
    && mkdir -p /var/run/sshd \
    && echo 'root:12345' | chpasswd \
    && sed -i 's/PermitRootLogin without-password/PermitRootLogin yes/' /etc/ssh/sshd_config \
    && sed -ri 's/session required pam_loginuid.so/#session required pam_loginuid.so/g' /etc/pam.d/sshd
EXPOSE 22
CMD ["/usr/sbin/sshd", "-D"]

> # 更多参考 https://www.docker.com/blog/intro-guide-to-dockerfile-best-practices
```

##### 构建WEB服务和应用 {docsify-ignore}
```bash
> # apache
> # 创建Dockerfile和项目目录
FROM httpd:2.4
COPY ./wwwroot /usr/local/apache2/htdocs/
> docker build -t apache2-image .
> docker run -it --rm --name apache-container -p 80:80 apache2-image
> # 也可以不创建镜像, 直接映射目录
> docker run -it --rm --name apache-ap -p 80:80 -v "$PWD":/usr/local/apache2/htdocs httpd:2.4

> # nginx
> # 直接使用官方镜像
> docker run -d -p 80:80 --name nginx-server nginx
> # 挂载本地目录
> docker run -d --name nginx-container -p 80:80 -v index.html:/usr/share/nginx/html:ro -d nginx

> # lamp/lnmp
> # 使用linode/lamp镜像
> docker run -p 80:80 -it linode/lamp /bin/bash
> 进入该镜像后, 使用 service开启apache2和mysql服务

> # 使用tutum/lamp镜像
> docker run -d -p 80:80 -p 3306:3306 tutum/lamp

> # CMS-WordPress
> docker pull wordpress
> docker run -d --name my-wordpress --link local-mysql:mysql wordpress
> 使用compose搭建wordpress应用
> 新建docker-compose.yml
wordpress:
    image: wordpress
    links:
        -db:mysql
    ports:
        -8080:80
db:
    image: mariadb
    environment:
        MYSQL_ROOT_PASSWORD: root
> docker-compose up
> # 如果没有docker-compose可使用pip install docker-compose

CMS-Ghost
> docker run --name ghost-container -d -p 80:2368 ghost
```

##### 持续开发与管理 {docsify-ignore}
```bash
> # 持续集成(Continuous integration, CI)
> # 集成通过自动化的构建来完成, 包括自动编译, 发布和测试, 从而尽快的发现错误
> # 特点: 从检出代码, 编译构建, 运行测试, 结果记录, 测试统计等都是自动完成的, 减少人工干预.
> # 需要有持续集成系统的支持, 包括代码托管机制支持, 以及集成服务器等

> # 持续交付(Continuous delivery CD): 强调产品在修改后到部署上线的流程要敏捷化, 自动化

> # Jenkins 开放易用的持续集成平台
> # 实时监控集成中存在的错误, 提供详细的日志文件和提醒功能, 并用图标的形式形象的展示项目构建的趋势和稳定性
> # 特点: 安装配置简单, 支持详细的测试报表, 分布式构建等
> # 使用官方发布的docker镜像一键部署
> docker run -p 8080:8080 -p 5000:5000 jenkins

> # Gitlab 开源源码管理系统
> # 支持基于GIT的源码管理, 代码评测, issue跟踪, 活动管理, wiki页面, 持续集成和测试等功能
> # 使用官方提供的社区dockerhub镜像
docker run --detack --hostname gitlab.example.com --publish 443:443 --publish 80:80 --publish 23:23 --name gitlab \
--restart always \
--volumn /srv/gitlab/config:/etc/gitlab \
--volumn /srv/gitlab/logs:/var/log/gitlab \
--volumn /srv/gitlab/data:/var/opt/gitlab \
gitlab/gitlab-ce:latest
```

##### 临时更正, 现在改有ubuntu18.04系统, 之前大部分在deepin系统上操作的, 特此, 说明一下. {docsify-ignore}

##### 进行到了数据库应用, 主要包括关系型和非关系型两种数据库 {docsify-ignore}

##### 数据库应用-MySQL {docsify-ignore}
```
> # 使用官方镜像快速启动一个MySQL实例
> docker run --name mysql_one -e MYSQL_ROOT_PASSWORD=0000 -d mysql:latest
> # 上面这个只是配置了ROOT密码

> # 将官方MySQL镜像作为客户端使用
> docker run -it --rm mysql mysql -hhost -uuser -p

> # 查看MySQL日志
> docker logs mysql_one

> # 自定义配置文件, 采用挂载目录实现
> docker run --name mysql-exp -v /home/user/mysql_cnf:/etc/mysql/conf.d -e MYSQL_ROOT_PASSWORD=your_passwd -d mysql:tag

> # 脱离cnf文件进行配置
> # 通过标签(flags)将配置选项传入mysqld进程, 用户可脱离配置文件对容器进行弹性定制
> docker run --name mysql-exp -e MYSQL_ROOT_PASSWORD=0000 -d mysql:tag --character-set-server=utf8mb4 --collation-server=utf8mb4_unicode_ci
> # 查看可用选项的完整列表: docker run -it --rm mysql:tag --verbose --help

> 主机访问的话, 最好做个端口映射, -p
```

##### 数据库应用-MongoDB: 可扩展/高性能 文档数据库 C++开发 支持复杂的数据类型和强大的查询语言 {docsify-ignore}
```
> # 从官方镜像创建容器
> docker run --name mongo-test -d mongo

> # 启动bash
> docker exec -it container-id sh
> # 使用mongo指令启动mongodb交互命令行
> # env 可查看环境变量配置, 默认暴露了mongodb的服务端口: 27017

> # 连接mongodb容器
> docker run -it --link mongo-test:db alpine sh
> # 进入后, 可使用ping db 测试mongo容器的连通性

> 直接使用mongo cli指令
> docker run -it --link mongo-test:test --entrypoint mongo mongo --host db

> # 可以使用--storageEngine设置储存引擎
> docker run --name mongo-test -d mongo --storageEngine wiredTiger

> 利用环境变量指定密码或无密码访问
> docker run -d -p 27017:27917 -e MONGODB_PASS="0000" mongo
> docker run -d -p 27017:27917 -e AUTH=no mongo
```

##### 数据库应用-Redis: 开源的基于内存的数据结构存储系统 ANSI C实现, 可以用作数据库/缓存/消息中间件 {docsify-ignore}
```
> # 通过官方镜像创建容器
> docker run -d --name redis-test redis

> # 连接redis容器
> docker run -it --link redis-test:db alpine sh
> # 可使用nc指令检测redis服务可用性: nc db 6379

> # 使用redis客户端
> docker run -it --link redis-test:db --entrypoint redis-cli redis -h db

> # 使用自定义配置还是通过挂载数据卷实现的, 目的路径: /usr/local/etc/redis/redis.cnf
> # 启动时需要指定配置文件
```

##### 数据库应用-Memcached: 高性能/分布式的开源内存对象缓存系统 {docsify-ignore}
```
# Memcached守护进程基于C语言实现, 基于libevent的事件处理可以实现很高的性能. 由于数据仅存在于内存中, 因此重启memcached或重启操作系统会导致数据全部丢失.

> docker run -d --name memcached-test memcached
> # 可以指定内存使用量
> docker run -d --name memcached-test -2-d memcached memcached -m 64

> # 用户可在宿主机上直接telnet测试访问memcached容器. 并直接输入客户端命令
```

##### 在使用数据库容器时, 建议将数据库文件映射到宿主主机, 一方面减少容器文件系统带来的性能损耗, 另一方面实现数据的持久化. {docsify-ignore}

##### 容器和云服务 {docsify-ignore}
```
# 公有云容器服务
# AWS, GCP, Azure, 腾讯云, 阿里云, 华为云, UCloud

# 容器云服务
# 容器即服务(Contaner as as Service, CaaS)可以按需提供容器化环境和应用服务
# Caas基本要素
# 容器调度: 调度和管理容器
# 服务发现: 将容器化的服务, 注册到服务发现工具, 确保服务之间的通信
# 网络配置: 用户可访问容器, 并实现主机容器通信
# 安全配置: 只开放容器监听的端口
# 负载均衡: 避免单点过载
# 数据持久化: 容器内数据云端持久化
# 容错与高可用: 日志与管理, 容器监控
```

学习Docker到这儿, 就先告一段落, 接下来, 就是有关Docker实践, 最近在本地也换上了Docker MySQL, 安装之类挺方便, 我想, 之后的编程环境, 也慢慢向Docker靠拢之类的. 加油.









