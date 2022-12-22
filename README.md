# IconChanger

IconChanger is an app that can change you app's icon. It simplifies your icon changing process.
<br><br>
![](./Github/Github-Iconchanger.png)

<br>
[中文版](https://github.com/underthestars-zhy/IconChanger/blob/main/READMD-zh.md)
<br>

## How to use

1. Go to github release
2. Download the latest app
3. Move the App to the Application folder

## If IconChanger doens't show any icon for certain App

1. Right click the app's icon
2. Choose `Set the Alias Name`
3. Set a alias name for it (Like Adobe Illustrator -> Illustrator)

See #9 for more details


## How to get query api (optional)

![](./Github/Api.png)

1. Open the Safari
2. Open the https://macosicons.com/#/
3. Search anything
4. Open the Devloper Tool
5. Choose the Network tab
6. Search the `algolianet`
7. Copy the host like `p1txh7zfb3-3.algolianet.com`
8. Open the IconChanger Setting
9. Input the host.

## About System App

Very sorry to say, but currently, we cannot change the icon of System Apps. Because of the SIP, users or root cannot write things to this app. And the idea of the Bridge App needs to change the `Info.plist`, so it will not work.

## How to contribute

1. Fork the project
2. Download the fork
3. Open it in the xcode (>13.3)
4. Start contibution

## Acknowledgement

* [macOSIcon](https://macosicons.com/#/)
* [fileiocn](https://github.com/mklement0/fileicon)
