; #FUNCTION# ====================================================================================================================
; Name ..........: CheckQueue
; Description ...: This file contains the Sequence that runs all MBR Bot
; Author ........: DEMEN
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2016
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

Func CheckQueue($sText = "troop")
	Local $CheckTroop[4] = [810, 186, 0xCFCFC8, 15] ; the gray background
	Local $directory = @ScriptDir & "\imgxml\Train\Queue_" & $sText
	Local $aeResult[2] = [$g_eNoTrain, $g_eNoTrain]
	Local $iTotalQueue = 0

	; Reset $g_aiQueueTroops Or $g_aiQueueSpells data
	If $sText = "troop" Then
		For $i = 0 To $eTroopCount - 1
			$g_aiQueueTroops[$i] = 0
		Next
	EndIf

	If $sText = "spell" Then
		For $i = 0 To $eSpellCount - 1
			$g_aiQueueSpells[$i] = 0
		Next
	EndIf

	Setlog("  » Checking queue " & $sText)

	; Delete slot 11 anyway
	If _ColorCheck(_GetPixelColor($CheckTroop[0] - 11 * 70, $CheckTroop[1], True), Hex($CheckTroop[2], 6), $CheckTroop[3]) = False Then ; Pink bkground found
		Setlog("  » So many troops queued, removing queues at the last slot")
		Local $x = 0
		While _ColorCheck(_GetPixelColor($CheckTroop[0] - 11 * 70, $CheckTroop[1], True), Hex($CheckTroop[2], 6), $CheckTroop[3]) = False
			If _Sleep(20) Then Return
			If $g_bRunState = False Then Return
			PureClick($CheckTroop[0] - 11 * 70, 202, 2, 50)
			$x += 1
			If $x = 250 Then ExitLoop
		WEnd
	EndIf

	; Check queue troops/spells & quantity
	For $i = 0 To 10
		If _ColorCheck(_GetPixelColor($CheckTroop[0] - $i * 70, $CheckTroop[1], True), Hex($CheckTroop[2], 6), $CheckTroop[3]) = False Then ; Pink bkground found
			_CaptureRegion2(Int(795 - 70.5 * $i), 210, Int(815 - 70.5 * $i), 230)
			Local $Res = DllCall($g_hLibMyBot, "str", "SearchMultipleTilesBetweenLevels", "handle", $g_hHBitmap2, "str", $directory, "str", "FV", "Int", 0, "str", "FV", "Int", 0, "Int", 1000)
			If $Res[0] = "" Or $Res[0] = "0" Then
				Setlog("Some kind of error, no image file return for slot: " & $i, $COLOR_RED)
			ElseIf StringInStr($Res[0], "-1") <> 0 Then
				SetLog("DLL Error", $COLOR_RED)
			Else ; name of first file found
				Local $aResult = StringSplit($Res[0], "_") ; $aResult[1] = troop short name "Barb" or "Arch"
				Local $iQty = getQueueTroopsQuantity(Int(772 - (70.5 * $i)), 190)

				Local $eIndex = Eval("e" & $aResult[1])

				If $sText = "troop" Then
					$g_aiQueueTroops[$eIndex] += $iQty
				ElseIf $sText = "spell" Then
					$g_aiQueueSpells[$eIndex - $eLSpell] += $iQty
				EndIf
			EndIf
		EndIf
	Next

	If $sText = "troop" Then
		For $j = 0 To $eTroopCount - 1
			If $g_aiQueueTroops[$j] > 0 Then
				Setlog("    - " & NameOfTroop($j, $g_aiQueueTroops[$j] > 1 ? 1 : 0) & " x" & $g_aiQueueTroops[$j])
				$iTotalQueue += $g_aiQueueTroops[$j] * $g_aiTroopSpace[$j]
			EndIf
		Next

	ElseIf $sText = "spell" Then
		For $j = 0 To $eSpellCount - 1
			If $g_aiQueueSpells[$j] > 0 Then
				Setlog("    - " & NameOfTroop($j + $eLSpell, $g_aiQueueSpells[$j] > 1 ? 1 : 0) & " x" & $g_aiQueueSpells[$j])
				$iTotalQueue += $g_aiQueueSpells[$j] * $g_aiSpellSpace[$j]
			EndIf
		Next

	EndIf

	; Check block troop
	Local $NewCampOCR = GetOCRCurrent(43, 160)
	If $NewCampOCR[0] < $NewCampOCR[1] + $iTotalQueue Then
		Setlog("  » A big guy blocks our camp.")
		ClearTrainingTroops()
		If CheckBlockTroops($sText) = False Then ; check if camp is not full after clear training
			$aeResult[1] = $g_eFull
		Else
			$aeResult[0] = $g_eRemained ; need check wrong army, then train remain
			$aeResult[1] = $g_eFull
		EndIf

	Else ; check wrong queue
		Local $bWrongQueue = False
		If $sText = "troop" Then
			For $i = 0 To ($eTroopCount - 1)
				If $g_aiQueueTroops[$i] - $g_aiArmyCompTroops[$i] > 0 Then $bWrongQueue = True
				If $bWrongQueue Then ExitLoop
			Next

		ElseIf $sText = "spell" Then
			For $i = 0 To ($eSpellCount - 1)
				If $g_aiQueueSpells[$i] - $g_aiArmyCompSpells[$i] > 0 Then $bWrongQueue = True
				If $bWrongQueue Then ExitLoop
			Next
		EndIf

		If $bWrongQueue Then
			Setlog("  » Queue is not correct")
			DeleteQueue($sText)
			$aeResult[1] = $g_eFull ; train full
		Else
			$aeResult[1] = $g_eRemained ; train remain queue
		EndIf
	EndIf

	If _Sleep(250) Then Return

	Return $aeResult

EndFunc   ;==>CheckQueue

Func DeleteQueue($sText = "troop")
	Local $CheckTroop[4] = [810, 186, 0xCFCFC8, 15] ; the gray background
	Setlog("  » Removing all queue " & $sText)
	For $i = 0 To 11
		If _ColorCheck(_GetPixelColor($CheckTroop[0] - $i * 70, $CheckTroop[1], True), Hex($CheckTroop[2], 6), $CheckTroop[3]) = False Then
			Local $x = 0
			While _ColorCheck(_GetPixelColor($CheckTroop[0] - $i * 70, $CheckTroop[1], True), Hex($CheckTroop[2], 6), $CheckTroop[3]) = False
				If _Sleep(20) Then Return
				If $g_bRunState = False Then Return
				PureClick($CheckTroop[0] - $i * 70, 202, 2, 50)
				$x += 1
				If $sText = "troop" Then
					If $x = 250 Then ExitLoop
				ElseIf $sText = "spell" Then
					If $x = 22 Then ExitLoop
				EndIf
			WEnd
			ExitLoop
		EndIf
	Next
	If _Sleep(250) Then Return
EndFunc   ;==>DeleteQueue
