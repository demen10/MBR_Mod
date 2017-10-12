; #FUNCTION# ====================================================================================================================
; Name ..........: readConfig.au3
; Description ...: Reads config file and sets variables
; Syntax ........: readConfig()
; Parameters ....: NA
; Return values .: NA
; Author ........: Demen
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2017
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
#include-once

Func ReadConfig_Mod()

	; SwitchAcc - Demen_SA_#9001
	ReadConfig_SwitchAcc()

	; FarmSchedule - Demen_FS_#9012
	For $i = 0 To 7
		IniReadS($g_abChkSetFarm[$i], $g_sProfilePath & "\Profile.ini", "FarmStrategy", "ChkSetFarm" & $i, False, "Bool")

		IniReadS($g_aiCmbAction1[$i], $g_sProfilePath & "\Profile.ini", "FarmStrategy", "CmbAction1" & $i, 0, "Int")
		IniReadS($g_aiCmbCriteria1[$i], $g_sProfilePath & "\Profile.ini", "FarmStrategy", "CmbCriteria1" & $i, 0, "Int")
		IniReadS($g_aiTxtResource1[$i], $g_sProfilePath & "\Profile.ini", "FarmStrategy", "TxtResource1" & $i, "")
		IniReadS($g_aiCmbTime1[$i], $g_sProfilePath & "\Profile.ini", "FarmStrategy", "CmbTime1" & $i, -1, "Int")

		IniReadS($g_aiCmbAction2[$i], $g_sProfilePath & "\Profile.ini", "FarmStrategy", "CmbAction2" & $i, 0, "Int")
		IniReadS($g_aiCmbCriteria2[$i], $g_sProfilePath & "\Profile.ini", "FarmStrategy", "CmbCriteria2" & $i, 0, "Int")
		IniReadS($g_aiTxtResource2[$i], $g_sProfilePath & "\Profile.ini", "FarmStrategy", "TxtResource2" & $i, "")
		IniReadS($g_aiCmbTime2[$i], $g_sProfilePath & "\Profile.ini", "FarmStrategy", "CmbTime2" & $i, -1, "Int")
	Next

	; 	QuickTrainCombo (Checkbox) - Demen_QT_#9006
	$g_bQuickTrainEnable = (IniRead($g_sProfileConfigPath, "other", "ChkUseQTrain", "0") = "1")
	$g_bQuickTrainArmy[0] = (IniRead($g_sProfileConfigPath, "troop", "QuickTrainArmy1", "0") = "1")
	$g_bQuickTrainArmy[1] = (IniRead($g_sProfileConfigPath, "troop", "QuickTrainArmy2", "0") = "1")
	$g_bQuickTrainArmy[2] = (IniRead($g_sProfileConfigPath, "troop", "QuickTrainArmy3", "0") = "1")
	$g_bChkMultiClick = (IniRead($g_sProfileConfigPath, "other", "ChkMultiClick", "0") = "1")

	; SmartTrain - Demen_ST_#9002
	IniReadS($ichkSmartTrain, $g_sProfileConfigPath, "SmartTrain", "Enable", 0, "int")
	IniReadS($ichkPreciseTroops, $g_sProfileConfigPath, "SmartTrain", "PreciseTroops", 0, "int")
	IniReadS($ichkFillArcher, $g_sProfileConfigPath, "SmartTrain", "ChkFillArcher", 0, "int")
	IniReadS($iFillArcher, $g_sProfileConfigPath, "SmartTrain", "FillArcher", 5, "int")
	IniReadS($ichkFillEQ, $g_sProfileConfigPath, "SmartTrain", "FillEQ", 0, "int")

	; ExtendedAttackBar - Demen_S11+_#9003
	IniReadS($g_abChkExtendedAttackBar[$DB], $g_sProfileConfigPath, "attack", "ExtendedAttackBarDB", False, "Bool")
	IniReadS($g_abChkExtendedAttackBar[$LB], $g_sProfileConfigPath, "attack", "ExtendedAttackBarLB", False, "Bool")

	; CheckCCTroops - Demen_CC_#9004
	IniReadS($g_bChkCC, $g_sProfileConfigPath, "CheckCC", "Enable", False, "Bool")
	IniReadS($g_iCmbCastleCapacityT, $g_sProfileConfigPath, "CheckCC", "Troop Capacity", 5, "Int")
	IniReadS($g_iCmbCastleCapacityS, $g_sProfileConfigPath, "CheckCC", "Spell Capacity", 1, "Int")

	For $i = 0 To $eTroopCount - 1
		$g_aiCCTroopsExpected[$i] = 0
		If $i >= $eSpellCount Then ContinueLoop
		$g_aiCCSpellsExpected[$i] = 0
	Next
	$g_bChkCCTroops = False

	For $i = 0 To 4
		Local $default = 19
		If $i > 2 Then $default = 9
		IniReadS($g_aiCmbCCSlot[$i], $g_sProfileConfigPath, "CheckCC", "ExpectSlot" & $i, $default, "int")
		IniReadS($g_aiTxtCCSlot[$i], $g_sProfileConfigPath, "CheckCC", "ExpectQty" & $i, 0, "int")
		If $g_aiCmbCCSlot[$i] > -1 And $g_aiCmbCCSlot[$i] < $default Then
			Local $j = $g_aiCmbCCSlot[$i]
			If $i <= 2 Then
				$g_aiCCTroopsExpected[$j] += $g_aiTxtCCSlot[$i]
			Else
				If $j > $eSpellFreeze Then $j += 1 ; exclude Clone Spell
				$g_aiCCSpellsExpected[$j] += $g_aiTxtCCSlot[$i]
			EndIf
			If $g_bChkCC Then $g_bChkCCTroops = True
		EndIf
	Next

EndFunc   ;==>ReadConfig_Mod

Func ReadConfig_SwitchAcc()
	IniReadS($g_bChkSwitchAcc, $g_sProfilePath & "\Profile.ini", "SwitchAcc", "Enable", False, "Bool")
	IniReadS($g_bChkSmartSwitch, $g_sProfilePath & "\Profile.ini", "SwitchAcc", "SmartSwitch", False, "Bool")
	IniReadS($g_iTotalAcc, $g_sProfilePath & "\Profile.ini", "SwitchAcc", "Total Coc Account", -1, "int")
	For $i = 0 To 7
		IniReadS($g_abAccountNo[$i], $g_sProfilePath & "\Profile.ini", "SwitchAcc", "AccountNo." & $i, False, "Bool")
		IniReadS($g_aiProfileNo[$i], $g_sProfilePath & "\Profile.ini", "SwitchAcc", "ProfileNo." & $i, -1, "int")
		IniReadS($g_abDonateOnly[$i], $g_sProfilePath & "\Profile.ini", "SwitchAcc", "DonateOnly." & $i, False, "Bool")
	Next
	IniReadS($g_iTrainTimeToSkip, $g_sProfilePath & "\Profile.ini", "SwitchAcc", "Train Time To Skip", 1, "int")
EndFunc   ;==>ReadConfig_SwitchAcc