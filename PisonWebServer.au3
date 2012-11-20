;*****************************************
;PisonWebServer.au3 by novebeta
;Created with ISN AutoIt Studio v. 0.88 BETA
;*****************************************
#include <Array.au3>
#include <Constants.au3>
Global Const $APPTITLE = IniRead("setting.ini", "app", "name", "Pison Web Server") 
_WinAPI_SetConsoleTitle($APPTITLE)
ConsoleWrite("Wait a minute..." & @CRLF)
Global Const $xampp = IniRead("setting.ini", "xampp", "dir", ".\xampp\")
Global Const $delay = IniRead("setting.ini", "backup", "delay", 5000)
Global Const $backup_dir = IniRead("setting.ini", "backup", "dir", ".\DATABACKUP\")
Global Const $user = IniRead("setting.ini", "mysql", "user", 'root')
Global Const $password = IniRead("setting.ini", "mysql", "pass", 'root')
Global Const $alldb = IniRead("setting.ini", "dumpsql", "alldb", 'true')
Global Const $db = IniRead("setting.ini", "dumpsql", "db", 'gkkd')
Global Const $otherArg = IniRead("setting.ini", "dumpsql", "otherarg", '')
Global Const $BrowserExe = IniRead("setting.ini", "browser", "exe", "iron.exe")
Global Const $BrowserParam = IniRead("setting.ini", "browser", "param", "")
Global Const $BrowserWorkingDir = IniRead("setting.ini", "browser", "workingdir", ".")
#include <backup.au3>
ConsoleWrite("Initialize done..." & @CRLF)
GetServerRunning()
;BackupMysql()
ConsoleWrite("Starting application..." & @CRLF)
_HideCUI()
ShellExecuteWait($BrowserExe, $BrowserParam, $BrowserWorkingDir, "", @SW_MAXIMIZE)
_ShowCUI()
ConsoleWrite("Closing application..." & @CRLF)
BackupMysql()
ShutDownServer()

Func _WinAPI_SetConsoleTitle($sTitle, $hDLL = "Kernel32.dll")
	Local $iRet = DllCall($hDLL, "bool", "SetConsoleTitle", "str", $sTitle)
	If $iRet[0] < 1 Then Return False
	Return True
EndFunc

Func _HideCUI()
	$var = WinList()
	For $i = 1 To $var[0][0]
		If $var[$i][0] <> "" And BitAND(WinGetState($var[$i][1]), 2) Then
			If WinGetProcess($var[$i][0], "") = @AutoItPID Then
				WinSetState($var[$i][1], "", @SW_HIDE)
				ExitLoop
			EndIf
		EndIf
	Next
EndFunc

Func _ShowCUI()
	$var = WinList()
	For $i = 1 To $var[0][0]
		;If $var[$i][0] <> "" And WinGetState($var[$i][1]) = 13 Then
		If WinGetProcess("[TITLE:" & $APPTITLE & "; CLASS:ConsoleWindowClass;]") = @AutoItPID Then
			WinSetState("[TITLE:" & $APPTITLE & "; CLASS:ConsoleWindowClass;]", "", @SW_SHOW)
			ExitLoop
		EndIf
		;EndIf
	Next
EndFunc
