set ws=WScript.CreateObject("WScript.Shell")

Set SFO = CreateObject("Scripting.FileSystemObject") '��ȡ��ǰ�ű�·��  
currentpath = SFO.GetFolder(".").Path

ws.Run currentpath+"\autologin.bat",0
