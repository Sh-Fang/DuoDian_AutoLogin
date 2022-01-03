# 前言

本教程分为“路由器代理登录”和“IOS设备快捷指令登录”两种方式

矿大的无线WiFi认证是在Web网页中输入账号密码认证的
![image](https://user-images.githubusercontent.com/46022639/147895530-70e0ac17-b454-48fd-9195-7ffbce602b51.png)

在chrome浏览器中按F12打开开发者模式，选择Network和preserve log为接下来的抓包做准备
![image](https://user-images.githubusercontent.com/46022639/147895587-a9b0fbac-b4de-47cb-b72c-26060d321391.png)

接下来输入账号和密码运营商点击登录，浏览器就会在后台抓包，在抓到的包里面找含有login的字样的包
![image](https://user-images.githubusercontent.com/46022639/147895689-bffc1e30-0cff-4628-b537-6f50d71c06da.png)

点进去看发现是一个包含了账号密码运营商的GET请求，中间用红框标出来的是当前的UNIX时间戳，这个可以不用管
![image](https://user-images.githubusercontent.com/46022639/147895768-e67f2674-c4c6-4254-b0cb-5b2e9d2e67c6.png)

在链接中我们删除ip和mac的标注
![image](https://user-images.githubusercontent.com/46022639/147895940-146c0cdf-b0d4-4d93-888b-7e2988e605ef.png)

得到下面这样的链接
![image](https://user-images.githubusercontent.com/46022639/147896244-1dc78bee-1bdc-48ab-a923-acbabfc3ac0c.png)



至此，我们就得到了一个可以直接登录认证的链接（如果不想折腾，在连上了校园WiFi后，点击一下这个链接就能联网了）


# 一、IOS设备使用自带的“快捷指令”登录
## 新建快捷指令
点击新建快捷指令，按照如下流程图添加模块（如果懒得添加模块，我已经把快捷指令文件上传到项目中了，在shortcut文件夹中，下载到iOS设备上就可以直接导入了）
![image](https://user-images.githubusercontent.com/46022639/147897476-ceeaa0db-7559-4e26-b1e7-e9688fc4a32e.png)

（此处也可以使用快捷指令中的“自动化”：当连接到wifi时，执行GET网页请求）

## 将快捷指令添加到辅助触控
依次点击：设置-辅助功能-触控-辅助触控-自定顶层菜单，随便选择一个顺手的位置，拖到最底下，就能看到刚才新建的快捷指令
![image](https://user-images.githubusercontent.com/46022639/147897635-a71ab18f-2366-4df3-9b14-6e2c7e4fbd51.png)

这样，下次在iOS设备上联网时，就可以直接在辅助触控里轻点一下，无需再输入账号密码联网。

# 二、路由器代理登录
>该部分需要一个刷入了OpenWrt的路由器，刷机方法和openwrt后台配置可参照于：[矿大哆点网络路由器自动登陆教程](https://github.com/Pandalzy/cumtddnet)

## 使用curl模拟GET请求登录
使用ssh连接路由器，输入`opkg update && opkg install curl`，安装curl

输入`vim autologin.sh`打开vi编辑器，按i进入输入模式，在里面输入`curl '此处将刚才得到的认证链接复制过来'`，然后按ESC并输入`:wq`保存并退出vi编辑器

输入`./autologin.sh`执行该bash文件，如果一切顺利的话，会在屏幕上输出登录成功的信息，此时就可以正常上网了
![image](https://user-images.githubusercontent.com/46022639/147896871-f45d3c27-0253-4cd0-953f-1b9cfdc6e318.png)

### PS
>在执行curl的时候，因为链接里面有一个%，导致执行失败，每次都连不上网，解决办法是把那个%换成&就可以了
![image](https://user-images.githubusercontent.com/46022639/147896983-713c7e76-61bb-4d13-b025-0acc4045b1a2.png)

## openwrt设置定时任务
进入openwrt后台，点击system->Scheduled Tasks

![image](https://user-images.githubusercontent.com/46022639/147897078-b4f7882f-7419-4b80-bc32-d609aaedf1e7.png)

在输入栏中输入`* * * * * /root/autologin.sh`，并点击Submit提交（此处是crontab表达式,代表每分钟执行一次，具体可参照[Linux crontab 命令](https://www.runoob.com/linux/linux-comm-crontab.html)），然后重启路由器


现在，电脑手机等设备就可以之间连接路由器的热点，无需登录就可直接上网


# 三、使用win的“任务计划程序”自动登录
新建一个`.bat`的批处理文件，文件内输入
```
@echo off
set wifi_name=None
@for /f "tokens=1,2,3" %%i in ('netsh WLAN show interfaces') do (   ::获取当前电脑连接的WiFi的名称
if [%%i]==[SSID] set wifi_name=%%k
)
if %wifi_name%==CUMT_Stu curl "刚才得到的链接" & msg * "登录成功!"   ::如果此时连接的WiFi的名称是CUMT_Stu，那么就执行curl并且弹窗提示登录成功
```

搜索输入“任务计划程序”，打开该程序，在左栏新建一个文件夹“我的定时任务”，右键该文件夹，选择“创建任务”

在弹出的窗口内自定义名称，接下来选择“触发器-新建”，开始任务处选择“工作站解锁时”（这样在每次解锁电脑时，都会自动联网）
![image](https://user-images.githubusercontent.com/46022639/147898214-bd9d9183-82e2-4bb3-9fef-0a6b5a9a1129.png)

选择“操作-新建-启动程序-浏览”，选择刚才的.bat脚本，选择确定

选择“条件-取消勾选‘只有在计算机使用交流电时才执行此任务’”，选择确定

此时已经完成了win的自动计划任务，按win+L锁屏，再输入密码解锁电脑时，桌面会黑框闪一下，代表执行了刚才的批处理程序
