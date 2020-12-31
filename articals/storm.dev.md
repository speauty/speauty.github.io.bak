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