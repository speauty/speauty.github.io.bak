#### Linux下的压缩和解压 {docsify-ignore}

#### gzip
> <font color=gray size=2>针对 `.gz` 后缀文件使用</font>
##### 相关参数
```shell script
Usage: gzip [OPTION]... [FILE]...
Compress or uncompress FILEs (by default, compress FILES in-place).

Mandatory arguments to long options are mandatory for short options too.

  -c, --stdout      结果写到标准输出, 原文件保持不变.
  -d, --decompress  解压.
  -f, --force       强制覆写输出文件, 并压缩链接.
  -h, --help        查看帮助.
  -k, --keep        压缩或者解压过程中, 保留原文件.
  -l, --list        列出压缩文件的相关信息.
  -L, --license     显示软件证书.
  -n, --no-name     不保存或还原原始名称和时间戳.
  -N, --name        保存或还原原始名称和时间戳.
  -q, --quiet       静默处理, 屏蔽所有警告信息.
  -r, --recursive   递归处理, 将指定目录下的所有文件及子目录一并处理.
  -S, --suffix=SUF  压缩文件使用后缀 SUF.
  -t, --test        检查压缩文件的完整性.
  -v, --verbose     详细模式.
  -V, --version     显示版本号.
  -1, --fast        快速压缩.
  -9, --best        深度压缩.
  --rsyncable       生成rsync友好存档.

With no FILE, or when FILE is -, read standard input.

```

##### 压缩
* 单个文件 `gzip a.txt`
* 多个文件 `gzip a.txt b.txt`
* 压缩多个文件到一个文件
   * `cat a.txt b.txt |gzip > test.gz`
   * `gzip -c a.txt b.txt > test.gz`
   
##### 解压
* 单个文件 `gzip -d a.gz`
* 多个文件 `gzip -d a.gz b.gz`

##### 实例
* 解压一个sql备份文件 `gzip -dkN backup_20200212_030001.sql.gz`
   * `-d` 解压, `-k` 保留原文件, `-N` 保留原始名称和时间戳.