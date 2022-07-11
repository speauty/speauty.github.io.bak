::脚本说明
::windows go项目 构建通用脚本
::使用: 双击该脚本运行即可
::设置: 可直接修改该脚本相关变量值, 比如app/mod等
::也可以在运行时输入相应参数, 不过每次都要输, 稍微有点麻烦

@echo off
chcp 65001

::曾遇到有alias的存在, 所以这里采用变量存储go指令
set goCmd=go

set GOOS=windows
set GOARCH=amd64
::-s 去掉符号表 -w 去掉调试信息
set ldFlags="-s -w"

::构建目标名称
set app=app
set /p "app=设置构建目标文件名称(默认值:%app%): "
::构建目标模块
set mod=mod
set /p "mod=设置构建目标模块(默认值:%mod%): "

echo 当前支持操作如下:
echo init-初始化模块, run-运行, build-编译

set /p opt=请输入操作:
if "%opt%" == "init" (
    call:init
    echo 初始化完成
) else if "%opt%" == "run" (
    call:run
) else if "%opt%" == "build" (
    call:build
    echo 构建完成: %app%
) else (
    echo 检索操作异常
)

pause

:init
%goCmd% mod tidy
goto:eof

:run
%goCmd% run %mod%
goto:eof

:build
::GOOS/GOARCH对 参考 https://github.com/goreleaser/goreleaser/issues/142
set /p "GOOS=设置构建目标操作系统(默认值:%GOOS%): "
set /p "GOARCH=设置构建目标架构(默认值:%GOARCH%): "
set /p "ldFlags=设置构建链接参数(默认值:%ldFlags%): "
set "app=%app%-%GOOS%-%GOARCH%"
if "%GOOS%" == "windows" (
    set "app=%app%.exe"
) else (
    ::是否启用CGO模块, 不过交叉编译时, 建议禁用该参数, 避免移植出现问题.
    set CGO_ENABLED=0
)

%goCmd% build -ldflags %ldFlags% -o "%app%"
goto:eof