set ws=WScript.CreateObject("WScript.Shell")

Set SFO = CreateObject("Scripting.FileSystemObject") '获取当前脚本路径  
currentpath = SFO.GetFolder(".").Path

ws.Run currentpath+"\autologin.bat",0
