#### 在深度系统上安装和简单配置GIT {docsify-ignore}
###### 查看当前系统
```bash
> uname -a
> Linux speauty-PC 4.15.0-30deepin-generic #31 SMP Fri Nov 30 04:29:02 UTC 2018 x86_64 GNU/Linux
> cat /etc/debian_version
> 9.0
```
![uname.png](../source/uname.png)

###### 安装GIT
```bash
> sudo apt install git
> ...
> git --version
> git version 2.11.0
```
![git-install.png](../source/git-install.png)

###### 生成秘钥和公钥
![ssh-keygen.png](../source/ssh-keygen.png)

###### 解决一个密钥错误的问题

![ssh-test-github.png](../source/ssh-test-github.png)

![ssh-err-v-check.png](../source/ssh-err-v-check.png)

![ssh-err-v-check-02.png](../source/ssh-err-v-check-02.png)

由于跟踪有点长, 只好分成了两张, 其中重新生成了秘钥很多, 甚至采用过dsa格式, 不过github那边似乎不支持. 导致该问题的主要原因是未将自定义名称的秘钥加入ssh中, 检索失败. 可使用ssh-add 秘钥地址 `ssh-add ~/.ssh/id_rsa`, 然后使用 `ssh-add -l` 查看秘钥列表.

![ssh-list.png](../source/ssh-list.png)

###### SSH测试

![ssh-test-github-ok.png](../source/ssh-test-github-ok.png)

###### 在github上添加公钥

![github-add-public-key.png](../source/github-add-public-key.png)

###### 配置本地GIT的名称和邮箱

![git-sets.png](../source/git-sets.png)




