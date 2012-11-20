;backup.au3
#include <Array.au3>
#include <Constants.au3>
Func BackupMySql()
If $alldb = "true" Then
	$argalldb = " --all-databases"
Else
	$argalldb = " --databases " & $db
EndIf
Sleep($delay)
$filename = @MDAY & @MON & @YEAR & @HOUR & @MIN & @SEC
$backup_file = $backup_dir & $filename & ".sql"
$arguments = "--user=" & $user & " --password=" & $password & $argalldb & ' --quick --result-file="' & $backup_file & '" ' & $otherArg
$argzip = '"' & $backup_dir & $filename & '.zip" "' & $backup_dir & '*.sql"'

ConsoleWrite("Creating backup file... " & @CRLF)
;ShellExecuteWait("mysql\bin\mysqldump", $arguments, $xampp)
Local $foo = Run($xampp & "mysql\bin\mysqldump " & $arguments, $xampp, @SW_HIDE, $STDERR_CHILD + $STDOUT_CHILD)
ReadStdout($foo)
ConsoleWrite("Compress database..." & @CRLF)
;ShellExecuteWait("7za.exe"," a -tzip " & $argzip)
Local $foo = Run(@ScriptDir & "\7za.exe a -tzip " & $argzip, @ScriptDir, @SW_HIDE, $STDERR_CHILD + $STDOUT_CHILD)
ReadStdout($foo)

FileDelete($backup_dir & '*.sql')
EndFunc   

Func ReadStdout($pid)
	Local $line
While 1
    $line = StdoutRead($pid)
    If @error Then ExitLoop
	if $line <> "" Then ConsoleWrite($line & @CRLF)
WEnd
While 1
    $line = StderrRead($pid)
    If @error Then ExitLoop
    if $line <> "" Then ConsoleWrite($line & @CRLF)
WEnd
EndFunc

Func GetServerRunning()
ConsoleWrite("Preparing server....." & @CRLF)
	If ProcessExists("mysqld.exe") = 0 Then
	ConsoleWrite("Please wait, mysql starting..." & @CRLF)
	ShellExecute("mysql\bin\mysqld","--defaults-file=mysql\bin\my.ini", $xampp, "",@SW_HIDE)		
	ConsoleWrite("mysql server started." & @CRLF)
EndIf
If ProcessExists("httpd.exe") = 0 Then
	ConsoleWrite("Please wait, apache starting..." & @CRLF)
	ShellExecute("apache\bin\httpd.exe","", $xampp, "",@SW_HIDE)	
	ConsoleWrite("apache server started" & @CRLF)
EndIf
ConsoleWrite("Server initialized." & @CRLF)
EndFunc


Func ShutDownServer()
ConsoleWrite("ShutDown server....." & @CRLF)
	ConsoleWrite("Please wait, stop mysql...." & @CRLF)
	ShellExecute("apache\bin\pv","-f -k mysqld.exe -q", $xampp, "",@SW_HIDE)		
	ConsoleWrite("mysql server stoped." & @CRLF)
	ConsoleWrite("Please wait, stop apache..." & @CRLF)
	ShellExecute("apache\bin\pv","-f -k httpd.exe -q", $xampp, "",@SW_HIDE)	
	ConsoleWrite("apache server stoped" & @CRLF)
ConsoleWrite("Server has been shutdown. Thanks...." & @CRLF)
EndFunc