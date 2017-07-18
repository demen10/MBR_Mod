; #FUNCTION# ====================================================================================================================
; Name ..........: LaunchConsole
; Description ...: Runs console application and returns output of STDIN and STDOUT
; Syntax ........:
; Parameters ....: $cmd, $param, ByRef $process_killed, $timeout = 0, $bUseSemaphore = False
; Return values .: None
; Author ........: Cosote (2015-12)
; Modified ......: Cosote (2016-08)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2017
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

#include-once
#include "Synchronization.au3"
#include "WmiAPI.au3"
#include <WindowsConstants.au3>
#include <NamedPipes.au3>

Global $g_RunPipe_StdIn = [0, 0] ; pipe read/write handles
Global $g_RunPipe_StdOut = [0, 0] ; pipe read/write handles
Global $g_RunPipe_hProcess = 0
Global $g_RunPipe_hThread = 0

Func LaunchConsole($cmd, $param, ByRef $process_killed, $timeout = 10000, $bUseSemaphore = False)

	If $bUseSemaphore = True Then
		Local $hSemaphore = LockSemaphore(StringReplace($cmd, "\", "/"), "Waiting to launch: " & $cmd)
	EndIf

	Local $data, $pid, $hStdIn[2], $hStdOut[2], $hTimer, $hProcess, $hThread


	If StringLen($param) > 0 Then $cmd &= " " & $param

	$hTimer = __TimerInit()
	$process_killed = False

	If $g_iDebugSetlog = 1 Then Setlog("Func LaunchConsole: " & $cmd, $COLOR_DEBUG) ; Debug Run
	$pid = RunPipe($cmd, "", @SW_HIDE, $STDERR_MERGED, $hStdIn, $hStdOut, $hProcess, $hThread)
	If $g_iDebugSetlog = 1 Then Setlog("Func LaunchConsole: command launched", $COLOR_DEBUG)
	If $pid = 0 Then
		SetLog("Launch faild: " & $cmd, $COLOR_ERROR)
		If $bUseSemaphore = True Then UnlockSemaphore($hSemaphore)
		Return
	EndIf

	Local $timeout_sec = Round($timeout / 1000)
	Local $iWaitResult

	Do
		$iWaitResult = _WinAPI_WaitForSingleObject($hProcess, $DELAYSLEEP)
		$data &= ReadPipe($hStdOut[0])
	Until ($timeout > 0 And __TimerDiff($hTimer) > $timeout) Or $iWaitResult <> $WAIT_TIMEOUT

	If ProcessExists($pid) Then
		If ClosePipe($pid, $hStdIn, $hStdOut, $hProcess, $hThread) = 1 Then
			If $g_iDebugSetlog = 1 Then SetLog("Process killed: " & $cmd, $COLOR_ERROR)
			$process_killed = True
		EndIf
	Else
		ClosePipe($pid, $hStdIn, $hStdOut, $hProcess, $hThread)
	EndIf
	$g_RunPipe_hProcess = 0
	$g_RunPipe_hThread = 0
	CleanLaunchOutput($data)

	If $g_iDebugSetlog = 1 Then Setlog("Func LaunchConsole Output: " & $data, $COLOR_DEBUG) ; Debug Run Output
	If $bUseSemaphore = True Then UnlockSemaphore($hSemaphore)
	Return $data
EndFunc   ;==>LaunchConsole

; Special version of ProcessExists that checks process based on full process image path AND parameters
; Supports also PID as $ProgramPath parameter
; $CompareMode = 0 Path with parameter is compared (" ", '"' and "'" removed!)
; $CompareMode = 1 Any Command Line containing path and parameter is used
; $SearchMode = 0 Search only for $ProgramPath
; $SearchMode = 1 Search for $ProgramPath and $ProgramParameter
; $CompareParameterFunc is func that returns True or False if parameter is matching, "" not used
Func ProcessExists2($ProgramPath, $ProgramParameter = Default, $CompareMode = Default, $SearchMode = 0, $CompareCommandLineFunc = "")

	If IsInt($ProgramPath) Then ;Return ProcessExists($ProgramPath) ; Be compatible with ProcessExists
		Local $hProcess, $pid = Int($ProgramPath)
		If _WinAPI_GetVersion() >= 6.0 Then
			$hProcess = _WinAPI_OpenProcess($PROCESS_QUERY_LIMITED_INFORMATION, 0, $pid)
		Else
			$hProcess = _WinAPI_OpenProcess($PROCESS_QUERY_INFORMATION, 0, $pid)
		EndIf
		Local $iExitCode = 0
		If $hProcess And @error = 0 Then
			$iExitCode = _WinAPI_GetExitCodeProcess($hProcess)
			_WinAPI_CloseHandle($hProcess)
		EndIf
		Return (($iExitCode = 259) ? $pid : 0)
	EndIf

	If $ProgramParameter = Default Then
		$ProgramParameter = ""
		If $CompareMode = Default Then $CompareMode = 1
	EndIf

	If $CompareMode = Default Then
		$CompareMode = 0
	EndIf

	Local $exe = $ProgramPath
	Local $iLastBS = StringInStr($exe, "\", 0, -1)
	If $iLastBS > 0 Then $exe = StringMid($exe, $iLastBS + 1)
	Local $commandLine = ($ProgramPath <> "" ? ('"' & $ProgramPath & '"' & ($ProgramParameter = "" ? "" : " " & $ProgramParameter)) : $ProgramParameter)
	Local $commandLineCompare = StringReplace(StringReplace(StringReplace(StringReplace($commandLine, ".exe", "", 1), " ", ""), '"', ""), "'", "")
	Local $query = "Select " & GetWmiSelectFields() & " from Win32_Process" ; replaced CommandLine with ExecutablePath
	If StringLen($commandLine) > 0 Then
		$query &= " where "
		If StringLen($ProgramPath) > 0 Then
			$query &= "ExecutablePath like '%" & StringReplace($ProgramPath, "\", "\\") & "%'"
			If $SearchMode = 1 And StringLen($ProgramParameter) > 0 Then $query &= " And "
		EndIf
		If $SearchMode = 1 And StringLen($ProgramParameter) > 0 Then $query &= "CommandLine like '%" & StringReplace($ProgramParameter, "\", "\\") & "%'"
	EndIf

	Local $pid = 0, $i = 0
	For $Process In WmiQuery($query)
		SetDebugLog($Process[0] & " = " & $Process[1] & " (" & $Process[2] & ")")
		If $pid = 0 Then
			Local $processCommandLineCompare = StringReplace(StringReplace(StringReplace(StringReplace($Process[2], ".exe", "", 1), " ", ""), '"', ""), "'", "")
			If ($CompareMode = 0 And $commandLineCompare = $processCommandLineCompare) Or _
					($CompareMode = 0 And StringRight($commandLineCompare, StringLen($processCommandLineCompare)) = $processCommandLineCompare) Or _
					($CompareMode = 0 And $CompareCommandLineFunc <> "" And Execute($CompareCommandLineFunc & "(""" & StringReplace($Process[2], """", "") & """)") = True) Or _
					$CompareMode = 1 Then
				$pid = Number($Process[0])
				;ExitLoop
			EndIf
		EndIf
		$i += 1
		$Process = 0
	Next
	If $pid = 0 Then
		SetDebugLog("Process by CommandLine not found: " & $ProgramPath & ($ProgramParameter = "" ? "" : ($ProgramPath <> "" ? " " : "") & $ProgramParameter))
	Else
		SetDebugLog("Found Process " & $pid & " by CommandLine: " & $ProgramPath & ($ProgramParameter = "" ? "" : ($ProgramPath <> "" ? " " : "") & $ProgramParameter))
	EndIf
	CloseWmiObject()
	Return $pid
EndFunc   ;==>ProcessExists2

; Special version of ProcessExists2 that returns Array of all processes found
Func ProcessesExist($ProgramPath, $ProgramParameter = Default, $CompareMode = Default, $SearchMode = Default, $CompareCommandLineFunc = Default, $bReturnDetailedArray = Default, $strComputer = ".")

	If $ProgramParameter = Default Then $ProgramParameter = ""
	If $CompareMode = Default Then $CompareMode = 0
	If $SearchMode = Default Then $SearchMode = 0
	If $CompareCommandLineFunc = Default Then $CompareCommandLineFunc = ""
	If $bReturnDetailedArray = Default Then $bReturnDetailedArray = False

	If IsNumber($ProgramPath) Then
		Local $a[1] = [ProcessExists($ProgramPath)] ; Be compatible with ProcessExists
		Return $a
	EndIf
	Local $exe = $ProgramPath
	Local $iLastBS = StringInStr($exe, "\", 0, -1)
	If $iLastBS > 0 Then $exe = StringMid($exe, $iLastBS + 1)
	Local $commandLine = ($ProgramPath <> "" ? ('"' & $ProgramPath & '"' & ($ProgramParameter = "" ? "" : " " & $ProgramParameter)) : $ProgramParameter)
	Local $commandLineCompare = StringReplace(StringReplace(StringReplace(StringReplace($commandLine, ".exe", "", 1), " ", ""), '"', ""), "'", "")
	Local $query = "Select " & GetWmiSelectFields() & " from Win32_Process" ; replaced CommandLine with ExecutablePath
	If StringLen($commandLine) > 0 Then
		$query &= " where "
		If StringLen($ProgramPath) > 0 Then
			$query &= "ExecutablePath like '%" & StringReplace($ProgramPath, "\", "\\") & "%'"
			If $SearchMode = 1 And StringLen($ProgramParameter) > 0 Then $query &= " And "
		EndIf
		If $SearchMode = 1 And StringLen($ProgramParameter) > 0 Then $query &= "CommandLine like '%" & StringReplace($ProgramParameter, "\", "\\") & "%'"
	EndIf
	Local $Process, $pid = 0, $i = 0
	Local $PIDs[0]

	For $Process In WmiQuery($query)
		SetDebugLog($Process[0] & " = " & $Process[1])
		Local $processCommandLineCompare = StringReplace(StringReplace(StringReplace(StringReplace($Process[2], ".exe", "", 1), " ", ""), '"', ""), "'", "")
		If ($CompareMode = 0 And $commandLineCompare = $processCommandLineCompare) Or _
				($CompareMode = 0 And StringRight($commandLineCompare, StringLen($processCommandLineCompare)) = $processCommandLineCompare) Or _
				($CompareMode = 0 And $CompareCommandLineFunc <> "" And Execute($CompareCommandLineFunc & "(""" & StringReplace($Process[2], """", "") & """)") = True) Or _
				$CompareMode = 1 Then

			$pid = Number($Process[0])
			ReDim $PIDs[$i + 1]
			Local $a = $pid
			If $bReturnDetailedArray Then
				Local $a = [$pid, $Process[1], $Process[2]]
			EndIf
			$PIDs[$i] = $a
			$i += 1

			$Process = 0
		EndIf
	Next
	If $i = 0 Then
		SetDebugLog("No process found by CommandLine: " & $ProgramPath & ($ProgramParameter = "" ? "" : " " & $ProgramParameter))
	Else
		SetDebugLog("Found " & $i & " process(es) with " & $ProgramPath & ($ProgramParameter = "" ? "" : " " & $ProgramParameter))
	EndIf
	CloseWmiObject()
	Return $PIDs
EndFunc   ;==>ProcessesExist

; Get complete Command Line by PID
Func ProcessGetCommandLine($pid, $strComputer = ".")

	If Not IsNumber($pid) Then Return SetError(2, 0, -1)

	Local $commandLine
	Local $query = "Select " & GetWmiSelectFields() & " from Win32_Process where Handle = " & $pid
	Local $i = 0

	For $Process In WmiQuery($query)
		SetDebugLog($Process[0] & " = " & $Process[2])
		SetError(0, 0, 0)
		Local $sProcessCommandLine = $Process[2]
		$Process = 0
		CloseWmiObject()
		Return $sProcessCommandLine
	Next
	SetDebugLog("Process not found with PID " & $pid)
	$Process = 0
	CloseWmiObject()
	Return SetError(1, 0, -1)
EndFunc   ;==>ProcessGetCommandLine

; Get Wmi Process Object for process
Func ProcessGetWmiProcess($pid, $strComputer = ".")

	If Not IsNumber($pid) Then Return SetError(2, 0, -1)

	Local $commandLine
	Local $query = "Select " & GetWmiSelectFields() & " from Win32_Process where Handle = " & $pid
	Local $i = 0

	For $Process In WmiQuery($query)
		SetDebugLog($Process[0] & " = " & $Process[2])
		SetError(0, 0, 0)
		$Process = 0
		CloseWmiObject()
		Return $Process
	Next
	SetDebugLog("Process not found with PID " & $pid)
	$Process = 0
	CloseWmiObject()
	Return SetError(1, 0, -1)
EndFunc   ;==>ProcessGetWmiProcess

Func CleanLaunchOutput(ByRef $output)
	;$output = StringReplace($output, @LF & @LF, "")
	$output = StringReplace($output, @CR & @CR, "")
	$output = StringReplace($output, @CRLF & @CRLF, "")
	If StringRight($output, 1) = @LF Then $output = StringLeft($output, StringLen($output) - 1)
	If StringRight($output, 1) = @CR Then $output = StringLeft($output, StringLen($output) - 1)
EndFunc   ;==>CleanLaunchOutput

Func RunPipe($program, $workdir, $show_flag, $opt_flag, ByRef $hStdIn, ByRef $hStdOut, ByRef $hProcess, ByRef $hThread)

	If UBound($hStdIn) < 2 Then
		Local $a = [0, 0]
		$hStdIn = $a
	EndIf
	If UBound($hStdOut) < 2 Then
		Local $a = [0, 0]
		$hStdOut = $a
	EndIf

	Local $tSecurity = DllStructCreate($tagSECURITY_ATTRIBUTES)
	DllStructSetData($tSecurity, "Length", DllStructGetSize($tSecurity))
	DllStructSetData($tSecurity, "InheritHandle", True)
	_NamedPipes_CreatePipe($hStdIn[0], $hStdIn[1], $tSecurity)
	_WinAPI_SetHandleInformation($hStdIn[1], $HANDLE_FLAG_INHERIT, 0)
	_NamedPipes_CreatePipe($hStdOut[0], $hStdOut[1], $tSecurity)
	_WinAPI_SetHandleInformation($hStdOut[0], $HANDLE_FLAG_INHERIT, 0)

	Local $StartupInfo = DllStructCreate($tagSTARTUPINFO)
	DllStructSetData($StartupInfo, "Size", DllStructGetSize($StartupInfo))
	DllStructSetData($StartupInfo, "Flags", $STARTF_USESTDHANDLES + $STARTF_USESHOWWINDOW)
	DllStructSetData($StartupInfo, "StdInput", $hStdIn[0])
	DllStructSetData($StartupInfo, "StdOutput", $hStdOut[1])
	DllStructSetData($StartupInfo, "StdError", $hStdOut[1])
	DllStructSetData($StartupInfo, "ShowWindow", $show_flag)

	Local $lpStartupInfo = DllStructGetPtr($StartupInfo)
	Local $ProcessInformation = DllStructCreate($tagPROCESS_INFORMATION)
	Local $lpProcessInformation = DllStructGetPtr($ProcessInformation)

	If __WinAPI_CreateProcess("", $program, 0, 0, True, 0, 0, $workdir, $lpStartupInfo, $lpProcessInformation) Then
		Local $pid = DllStructGetData($ProcessInformation, "ProcessID")
		$hProcess = DllStructGetData($ProcessInformation, "hProcess")
		$hThread = DllStructGetData($ProcessInformation, "hThread")
		;_WinAPI_CloseHandle($hStdOut[1])
		Return $pid
	EndIf

	; close handles
	ClosePipe(0, $hStdIn, $hStdOut, 0, 0)

EndFunc   ;==>RunPipe

Func ClosePipe($pid, $hStdIn, $hStdOut, $hProcess, $hThread)

	_WinAPI_CloseHandle($hStdIn[0])
	_WinAPI_CloseHandle($hStdIn[1])
	_WinAPI_CloseHandle($hStdOut[0])
	_WinAPI_CloseHandle($hStdOut[1])
	If $hProcess Then _WinAPI_CloseHandle($hProcess)
	If $hThread Then _WinAPI_CloseHandle($hThread)
	Return ProcessClose($pid)

EndFunc   ;==>ClosePipe

Func ReadPipe(ByRef $hPipe)
	If DataInPipe($hPipe) = 0 Then Return SetError(@error, @extended, "")
	Local $tBuffer = DllStructCreate("char Text[4096]")
	Local $iRead
	If _WinAPI_ReadFile($hPipe, DllStructGetPtr($tBuffer), 4096, $iRead) Then
		Return SetError(0, 0, DllStructGetData($tBuffer, "Text"))
	EndIf
	Return SetError(@error, @extended, "")
EndFunc   ;==>ReadPipe

Func WritePipe(ByRef $hPipe, Const $s)
	Local $tBuffer = DllStructCreate("char Text[4096]")
	DllStructSetData($tBuffer, "Text", $s)
	Local $iToWrite = StringLen($s)
	Local $iWritten = 0
	If _WinAPI_WriteFile($hPipe, DllStructGetPtr($tBuffer), $iToWrite, $iWritten) Then
		Return SetError(0, 0, $iWritten)
	EndIf
	Return SetError(@error, @extended, 0)
EndFunc   ;==>WritePipe

Func DataInPipe(ByRef $hPipe)
	Local $aResult = DllCall("kernel32.dll", "bool", "PeekNamedPipe", "handle", $hPipe, "ptr", 0, "int", 0, "dword*", 0, "dword*", 0, "dword*", 0)
	If @error Then Return SetError(@error, @extended, 0)
	Return SetError(0, 0, $aResult[5])
EndFunc   ;==>DataInPipe

Func __WinAPI_CreateProcess($sAppName, $sCommand, $tSecurity, $tThread, $bInherit, $iFlags, $pEnviron, $sDir, $tStartupInfo, $tProcess)
	Local $tCommand = 0
	Local $sAppNameType = "wstr", $sDirType = "wstr"
	If $sAppName = "" Then
		$sAppNameType = "ptr"
		$sAppName = 0
	EndIf
	If $sCommand <> "" Then
		; must be MAX_PATH characters, can be updated by CreateProcessW
		$tCommand = DllStructCreate("wchar Text[" & 4096 + 1 & "]")
		DllStructSetData($tCommand, "Text", $sCommand)
	EndIf
	If $sDir = "" Then
		$sDirType = "ptr"
		$sDir = 0
	EndIf

	Local $aResult = DllCall("kernel32.dll", "bool", "CreateProcessW", $sAppNameType, $sAppName, "struct*", $tCommand, _
			"struct*", $tSecurity, "struct*", $tThread, "bool", $bInherit, "dword", $iFlags, "struct*", $pEnviron, $sDirType, $sDir, _
			"struct*", $tStartupInfo, "struct*", $tProcess)
	If @error Then Return SetError(@error, @extended, False)

	Return $aResult[0]
EndFunc   ;==>__WinAPI_CreateProcess
