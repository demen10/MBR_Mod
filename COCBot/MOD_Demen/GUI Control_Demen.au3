; #FUNCTION# ====================================================================================================================
; Name ..........: MBR GUI Control
; Description ...: This file controls the "MOD" tab
; Syntax ........:
; Parameters ....: None
; Return values .: None
; Author ........: Demen
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2017
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
#include-once

; QuickTrainCombo - Demen_QT_#9006
Func chkQuickTrainCombo()
	If GUICtrlRead($g_ahChkArmy[0]) = $GUI_UNCHECKED And GUICtrlRead($g_ahChkArmy[1]) = $GUI_UNCHECKED And GUICtrlRead($g_ahChkArmy[2]) = $GUI_UNCHECKED Then
		GUICtrlSetState($g_ahChkArmy[0], $GUI_CHECKED)
		ToolTip("QuickTrainCombo: " & @CRLF & "At least 1 Army Check is required! Default Army1.")
		Sleep(2000)
		ToolTip('')
	EndIf

	If GUICtrlRead($g_ahChkArmy[2]) = $GUI_CHECKED And GUICtrlRead($g_hChkUseQuickTrain) = $GUI_CHECKED Then
		_GUI_Value_STATE("HIDE", $g_hLblRemoveArmy & "#" & $g_hBtnRemoveArmy)
		_GUI_Value_STATE("SHOW", $g_hChkMultiClick)
	Else
		_GUI_Value_STATE("HIDE", $g_hChkMultiClick)
		_GUI_Value_STATE("SHOW", $g_hLblRemoveArmy & "#" & $g_hBtnRemoveArmy)
	EndIf

EndFunc   ;==>chkQuickTrainCombo

; SmartTrain - Demen_ST_#9002
Func chkSmartTrain()
	If GUICtrlRead($g_hchkSmartTrain) = $GUI_CHECKED Then
		If GUICtrlRead($g_hChkUseQuickTrain) = $GUI_UNCHECKED Then _GUI_Value_STATE("ENABLE", $g_hchkPreciseTroops)
		_GUI_Value_STATE("ENABLE", $g_hchkFillArcher & "#" & $g_hchkFillEQ)
		chkPreciseTroops()
		chkFillArcher()
	Else
		_GUI_Value_STATE("DISABLE", $g_hchkPreciseTroops & "#" & $g_hchkFillArcher & "#" & $g_htxtFillArcher & "#" & $g_hchkFillEQ)
		_GUI_Value_STATE("UNCHECKED", $g_hchkPreciseTroops & "#" & $g_hchkFillArcher & "#" & $g_hchkFillEQ)
	EndIf
EndFunc   ;==>chkSmartTrain

Func chkPreciseTroops()
	If GUICtrlRead($g_hchkPreciseTroops) = $GUI_CHECKED Then
		_GUI_Value_STATE("DISABLE", $g_hchkFillArcher & "#" & $g_hchkFillEQ)
		_GUI_Value_STATE("UNCHECKED", $g_hchkFillArcher & "#" & $g_hchkFillEQ)
		chkFillArcher()
	Else
		_GUI_Value_STATE("ENABLE", $g_hchkFillArcher & "#" & $g_hchkFillEQ)
	EndIf
EndFunc   ;==>chkPreciseTroops

Func chkFillArcher()
	If GUICtrlRead($g_hchkFillArcher) = $GUI_CHECKED Then
		_GUI_Value_STATE("ENABLE", $g_htxtFillArcher)
	Else
		_GUI_Value_STATE("DISABLE", $g_htxtFillArcher)
	EndIf
EndFunc   ;==>chkFillArcher

; SwitchAcc - Demen_SA_#9001
Func UpdateMultiStats()
	Local $bEnableSwitchAcc = GUICtrlRead($g_hChkSwitchAcc) = $GUI_CHECKED
	Local $iCmbTotalAcc = _GUICtrlComboBox_GetCurSel($g_hCmbTotalAccount) + 1 ; combobox data starts with 2
	For $i = 0 To 7
		If $bEnableSwitchAcc And $i <= $iCmbTotalAcc Then
			For $j = $g_ahGrpVillageAcc[$i] To $g_ahLblHourlyStatsTrophyAcc[$i]
				GUICtrlSetState($j, $GUI_SHOW)
			Next
			If GUICtrlRead($g_ahChkAccount[$i]) = $GUI_CHECKED Then
				If GUICtrlRead($g_ahChkDonate[$i]) = $GUI_UNCHECKED Then
					GUICtrlSetData($g_ahGrpVillageAcc[$i], GUICtrlRead($g_ahCmbProfile[$i]) & " (Active)")
				Else
					GUICtrlSetData($g_ahGrpVillageAcc[$i], GUICtrlRead($g_ahCmbProfile[$i]) & " (Donate)")
				EndIf

			Else
				GUICtrlSetData($g_ahGrpVillageAcc[$i], GUICtrlRead($g_ahCmbProfile[$i]) & " (Idle)")
			EndIf
		Else
			For $j = $g_ahGrpVillageAcc[$i] To $g_ahLblHourlyStatsTrophyAcc[$i]
				GUICtrlSetState($j, $GUI_HIDE)
			Next
		EndIf
	Next
EndFunc   ;==>UpdateMultiStats

Func chkSwitchAcc()
	If GUICtrlRead($g_hChkSwitchAcc) = $GUI_CHECKED Then
		For $i = $g_hCmbTotalAccount To $g_ahChkDonate[7]
			GUICtrlSetState($i, $GUI_ENABLE)
		Next
		For $i = 0 To 7 ; FarmSchedule - Demen_FS_#9012
			GUICtrlSetState($g_ahChkSetFarm[$i], $GUI_ENABLE)
		Next
		cmbTotalAcc()
	Else
		For $i = $g_hCmbTotalAccount To $g_ahChkDonate[7]
			GUICtrlSetState($i, $GUI_DISABLE)
		Next
		For $i = 0 To 7 ; FarmSchedule - Demen_FS_#9012
			GUICtrlSetState($g_ahChkSetFarm[$i], $GUI_UNCHECKED + $GUI_DISABLE)
		Next
	EndIf
EndFunc   ;==>chkSwitchAcc

Func cmbTotalAcc()
	Local $iCmbTotalAcc = _GUICtrlComboBox_GetCurSel($g_hCmbTotalAccount) + 1 ; combobox data starts with 2
	For $i = 0 To 7
		If $iCmbTotalAcc >= 0 And $i <= $iCmbTotalAcc Then
			_GUI_Value_STATE("SHOW", $g_ahChkAccount[$i] & "#" & $g_ahCmbProfile[$i] & "#" & $g_ahChkDonate[$i])
			For $j = $g_ahChkSetFarm[$i] To $g_ahCmbTime2[$i]
				GUICtrlSetState($j, $GUI_SHOW)
			Next
		ElseIf $i > $iCmbTotalAcc Then
			GUICtrlSetState($g_ahChkAccount[$i], $GUI_UNCHECKED)
			_GUI_Value_STATE("HIDE", $g_ahChkAccount[$i] & "#" & $g_ahCmbProfile[$i] & "#" & $g_ahChkDonate[$i])
			For $j = $g_ahChkSetFarm[$i] To $g_ahCmbTime2[$i]
				GUICtrlSetState($j, $GUI_HIDE)
			Next
		EndIf
		chkAccount($i)
	Next
	cmbChkSetFarm()
EndFunc   ;==>cmbTotalAcc

Func chkAccount($i)
	If GUICtrlRead($g_ahChkAccount[$i]) = $GUI_CHECKED Then
		_GUI_Value_STATE("ENABLE", $g_ahCmbProfile[$i] & "#" & $g_ahChkDonate[$i])
	Else
		GUICtrlSetState($g_ahChkDonate[$i], $GUI_UNCHECKED)
		_GUI_Value_STATE("DISABLE", $g_ahCmbProfile[$i] & "#" & $g_ahChkDonate[$i])
	EndIf
EndFunc   ;==>chkAccount

Func chkAccount0()
	chkAccount(0)
EndFunc   ;==>chkAccount0
Func chkAccount1()
	chkAccount(1)
EndFunc   ;==>chkAccount1
Func chkAccount2()
	chkAccount(2)
EndFunc   ;==>chkAccount2
Func chkAccount3()
	chkAccount(3)
EndFunc   ;==>chkAccount3
Func chkAccount4()
	chkAccount(4)
EndFunc   ;==>chkAccount4
Func chkAccount5()
	chkAccount(5)
EndFunc   ;==>chkAccount5
Func chkAccount6()
	chkAccount(6)
EndFunc   ;==>chkAccount6
Func chkAccount7()
	chkAccount(7)
EndFunc   ;==>chkAccount7

; Classic FourFinger - Demen_FF_#9007
Func cmbStandardDropSidesAB() ; avoid conflict between FourFinger and SmartAttack
	If _GUICtrlComboBox_GetCurSel($g_hCmbStandardDropSidesAB) = 4 Then
		GUICtrlSetState($g_hChkSmartAttackRedAreaAB, $GUI_UNCHECKED)
		GUICtrlSetState($g_hChkSmartAttackRedAreaAB, $GUI_DISABLE)
	Else
		GUICtrlSetState($g_hChkSmartAttackRedAreaAB, $GUI_ENABLE)
	EndIf
	chkSmartAttackRedAreaAB()
EndFunc   ;==>cmbStandardDropSidesAB

Func cmbStandardDropSidesDB() ; avoid conflict between FourFinger and SmartAttack
	If _GUICtrlComboBox_GetCurSel($g_hCmbStandardDropSidesDB) = 4 Then
		GUICtrlSetState($g_hChkSmartAttackRedAreaDB, $GUI_UNCHECKED)
		GUICtrlSetState($g_hChkSmartAttackRedAreaDB, $GUI_DISABLE)
	Else
		GUICtrlSetState($g_hChkSmartAttackRedAreaDB, $GUI_ENABLE)
	EndIf
	chkSmartAttackRedAreaDB()
EndFunc   ;==>cmbStandardDropSidesDB
