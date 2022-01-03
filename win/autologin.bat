@echo off

set wifi_name=None

@for /f "tokens=1,2,3" %%i in ('netsh WLAN show interfaces') do (

if [%%i]==[SSID] set wifi_name=%%k

)


if %wifi_name%==CUMT_Stu curl "http://xxxxxx" &msg * "µÇÂ¼³É¹¦!"



