# IconChanger

[English](./README.md) | [Version française](./README-fr.md)

IconChanger是一个可以更换App图标的应用程序。它简化了你更换图标的流程。
<br><br>
![](./Github/Github-Iconchanger.png)

## 如何使用

1. 前往GitHub的Release界面
2. 下载最新版App
3. 将App移动到应用程序文件夹

## 如果IconChanger对于某些软件没有展示可替换图标

1. 右键App图标
2. 选择 `Set the Alias Name`
3. 为这个App设置一个合适的别名 (例如 Adobe Illustrator -> Illustrator)


## 如何获得 query api (可选择)

![](./Github/Api.png)

1. 打开Safari
2. 打开https://macosicons.com/#/
3. 搜索任意图标
4. 打开开发者工具
5. 选择网络标签栏
6. 搜索 `algolianet`
7. 复制链接类似于 `p1txh7zfb3-3.algolianet.com`
8. 打开IconChanger的设置
9. 输入链接

## 关于系统App

非常抱歉，目前我们无法更改系统应用程序的图标。由于 SIP，用户或 root 无法向此应用写入内容。而Bridge App的想法需要修改一下 `Info.plist`，所以是行不通的。

## 如何贡献

1. Fork这个项目
2. 下载
3. 在Xcode13.3以上的版本打开
4. 开始贡献吧

## 承谢

* [macOSicons](https://macosicons.com/#/)
* [fileicon](https://github.com/mklement0/fileicon)
* [Atom](https://github.com/atomtoto)
