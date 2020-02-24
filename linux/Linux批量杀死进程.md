#### Linux批量杀死进程 {docsify-ignore}

关于这个有好几种方式, 不过有一个共同点, 就是要获取进程号, 然后再进行杀死或其他操作的.

##### 输出命令执行
* 具体命令 `ps aux|grep key|grep -v grep|awk '{print "sudo kill -9 " $2}'|sh`
   * 重点在 `awk`, 请细品, 其他几种, 似乎也是基于这个之上, 当然你用 `cut` , 我也没话说.