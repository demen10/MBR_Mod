; #FUNCTION# ====================================================================================================================
; Name ..........: applyConfig.au3
; Description ...: Applies all of the  variable to the GUI
; Syntax ........: applyConfig()
; Parameters ....: $bRedrawAtExit = True, redraws bot window after config was applied
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

Func ApplyConfig_Mod($TypeReadSave)
	Switch $TypeReadSave
		Case "Read"
			; SwitchAcc - Demen_SA_#9001
			GUICtrlSetState($g_hChkSwitchAcc, $g_bChkSwitchAcc ? $GUI_CHECKED : $GUI_UNCHECKED)
			GUICtrlSetState($g_hChkSmartSwitch, $g_bChkSmartSwitch ? $GUI_CHECKED : $GUI_UNCHECKED)
			_GUICtrlComboBox_SetCurSel($g_hCmbTotalAccount, $g_iTotalAcc - 1)
			For $i = 0 To 7
				GUICtrlSetState($g_ahChkAccount[$i], $g_abAccountNo[$i] ? $GUI_CHECKED : $GUI_UNCHECKED)
				_GUICtrlComboBox_SetCurSel($g_ahCmbProfile[$i], $g_aiProfileNo[$i])
				GUICtrlSetState($g_ahChkDonate[$i], $g_abDonateOnly[$i] ? $GUI_CHECKED : $GUI_UNCHECKED)
			Next
			_GUICtrlComboBox_SetCurSel($g_hCmbTrainTimeToSkip, $g_iTrainTimeToSkip)
			chkSwitchAcc()

			; SwitchProfile - Demen_SP_#9011
			For $i = 0 To 3
				GUICtrlSetState($g_ahChk_SwitchMax[$i], $g_abChkSwitchMax[$i] ? $GUI_CHECKED : $GUI_UNCHECKED)
				GUICtrlSetState($g_ahChk_SwitchMin[$i], $g_abChkSwitchMin[$i] ? $GUI_CHECKED : $GUI_UNCHECKED)
				_GUICtrlComboBox_SetCurSel($g_ahCmb_SwitchMax[$i], $g_aiCmbSwitchMax[$i])
				_GUICtrlComboBox_SetCurSel($g_ahCmb_SwitchMin[$i], $g_aiCmbSwitchMin[$i])

				GUICtrlSetState($g_ahChk_BotTypeMax[$i], $g_abChkBotTypeMax[$i] ? $GUI_CHECKED : $GUI_UNCHECKED)
				GUICtrlSetState($g_ahChk_BotTypeMin[$i], $g_abChkBotTypeMin[$i] ? $GUI_CHECKED : $GUI_UNCHECKED)
				_GUICtrlComboBox_SetCurSel($g_ahCmb_BotTypeMax[$i], $g_aiCmbBotTypeMax[$i])
				_GUICtrlComboBox_SetCurSel($g_ahCmb_BotTypeMin[$i], $g_aiCmbBotTypeMin[$i])

				GUICtrlSetData($g_ahTxt_ConditionMax[$i], $g_aiConditionMax[$i])
				GUICtrlSetData($g_ahTxt_ConditionMin[$i], $g_aiConditionMin[$i])
			Next
			chkSwitchProfile()
			chkSwitchBotType()

			; 	QuickTrainCombo (Checkbox) - Demen_QT_#9006
			GUICtrlSetState($g_hChkUseQuickTrain, $g_bQuickTrainEnable ? $GUI_CHECKED : $GUI_UNCHECKED)
			GUICtrlSetState($g_ahChkArmy[0], $g_bQuickTrainArmy[0] ? $GUI_CHECKED : $GUI_UNCHECKED)
			GUICtrlSetState($g_ahChkArmy[1], $g_bQuickTrainArmy[1] ? $GUI_CHECKED : $GUI_UNCHECKED)
			GUICtrlSetState($g_ahChkArmy[2], $g_bQuickTrainArmy[2] ? $GUI_CHECKED : $GUI_UNCHECKED)
			GUICtrlSetState($g_hChkMultiClick, $g_bChkMultiClick ? $GUI_CHECKED : $GUI_UNCHECKED)
			chkUseQTrain()

			; SmartTrain - Demen_ST_#9002
			GUICtrlSetState($g_hchkSmartTrain, $ichkSmartTrain = 1 ? $GUI_CHECKED : $GUI_UNCHECKED)
			GUICtrlSetState($g_hchkPreciseTroops, $ichkPreciseTroops = 1 ? $GUI_CHECKED : $GUI_UNCHECKED)
			GUICtrlSetState($g_hchkFillArcher, $ichkFillArcher = 1 ? $GUI_CHECKED : $GUI_UNCHECKED)
			GUICtrlSetData($g_htxtFillArcher, $iFillArcher)
			GUICtrlSetState($g_hchkFillEQ, $ichkFillEQ = 1 ? $GUI_CHECKED : $GUI_UNCHECKED)
			chkSmartTrain()

			; ExtendedAttackBar - Demen_S11+_#9003
			GUICtrlSetState($g_hChkExtendedAttackBarDB, $g_abChkExtendedAttackBar[$DB] ? $GUI_CHECKED : $GUI_UNCHECKED)
			GUICtrlSetState($g_hChkExtendedAttackBarLB, $g_abChkExtendedAttackBar[$LB] ? $GUI_CHECKED : $GUI_UNCHECKED)

			; CheckCCTroops - Demen_CC_#9004
			GUICtrlSetState($g_hChkTroopsCC, $g_bChkCC ? $GUI_CHECKED : $GUI_UNCHECKED)
			_GUICtrlComboBox_SetCurSel($g_hCmbCastleCapacityT, $g_iCmbCastleCapacityT)
			_GUICtrlComboBox_SetCurSel($g_hCmbCastleCapacityS, $g_iCmbCastleCapacityS)
			For $i = 0 To 4
				_GUICtrlComboBox_SetCurSel($g_ahCmbCCSlot[$i], $g_aiCmbCCSlot[$i])
				GUICtrlSetData($g_ahTxtCCSlot[$i], $g_aiTxtCCSlot[$i])
			Next
			GUIControlCheckCC()

		Case "Save"
			; SwitchAcc - Demen_SA_#9001
			$g_bChkSwitchAcc = GUICtrlRead($g_hChkSwitchAcc) = $GUI_CHECKED
			$g_bChkSmartSwitch = GUICtrlRead($g_hChkSmartSwitch) = $GUI_CHECKED
			$g_iTotalAcc = _GUICtrlComboBox_GetCurSel($g_hCmbTotalAccount) + 1 ; at least 2 accounts needed
			For $i = 0 To 7
				$g_abAccountNo[$i] = GUICtrlRead($g_ahChkAccount[$i]) = $GUI_CHECKED
				$g_aiProfileNo[$i] = _GUICtrlComboBox_GetCurSel($g_ahCmbProfile[$i])
				$g_abDonateOnly[$i] = GUICtrlRead($g_ahChkDonate[$i]) = $GUI_CHECKED
			Next
			$g_iTrainTimeToSkip = _GUICtrlComboBox_GetCurSel($g_hCmbTrainTimeToSkip)

			; SwitchProfile - Demen_SP_#9011
			For $i = 0 To 3
				$g_abChkSwitchMax[$i] = GUICtrlRead($g_ahChk_SwitchMax[$i]) = $GUI_CHECKED
				$g_abChkSwitchMin[$i] = GUICtrlRead($g_ahChk_SwitchMin[$i]) = $GUI_CHECKED
				$g_aiCmbSwitchMax[$i] = _GUICtrlComboBox_GetCurSel($g_ahCmb_SwitchMax[$i])
				$g_aiCmbSwitchMin[$i] = _GUICtrlComboBox_GetCurSel($g_ahCmb_SwitchMin[$i])

				$g_abChkBotTypeMax[$i] = GUICtrlRead($g_ahChk_BotTypeMax[$i]) = $GUI_CHECKED
				$g_abChkBotTypeMin[$i] = GUICtrlRead($g_ahChk_BotTypeMin[$i]) = $GUI_CHECKED
				$g_aiCmbBotTypeMax[$i] = _GUICtrlComboBox_GetCurSel($g_ahCmb_BotTypeMax[$i])
				$g_aiCmbBotTypeMin[$i] = _GUICtrlComboBox_GetCurSel($g_ahCmb_BotTypeMin[$i])

				$g_aiConditionMax[$i] = GUICtrlRead($g_ahTxt_ConditionMax[$i])
				$g_aiConditionMin[$i] = GUICtrlRead($g_ahTxt_ConditionMin[$i])
			Next

			; 	QuickTrainCombo (Checkbox) - Demen_QT_#9006
			$g_bQuickTrainEnable = (GUICtrlRead($g_hChkUseQuickTrain) = $GUI_CHECKED)
			$g_bQuickTrainArmy[0] = (GUICtrlRead($g_ahChkArmy[0]) = $GUI_CHECKED)
			$g_bQuickTrainArmy[1] = (GUICtrlRead($g_ahChkArmy[1]) = $GUI_CHECKED)
			$g_bQuickTrainArmy[2] = (GUICtrlRead($g_ahChkArmy[2]) = $GUI_CHECKED)
			$g_bChkMultiClick = (GUICtrlRead($g_hChkMultiClick) = $GUI_CHECKED)

			;SmartTrain - Demen_ST_#9002
			$ichkSmartTrain = GUICtrlRead($g_hchkSmartTrain) = $GUI_CHECKED ? 1 : 0
			$ichkPreciseTroops = GUICtrlRead($g_hchkPreciseTroops) = $GUI_CHECKED ? 1 : 0
			$ichkFillArcher = GUICtrlRead($g_hchkFillArcher) = $GUI_CHECKED ? 1 : 0
			$iFillArcher = GUICtrlRead($g_htxtFillArcher)
			$ichkFillEQ = GUICtrlRead($g_hchkFillEQ) = $GUI_CHECKED ? 1 : 0

			; ExtendedAttackBar - Demen_S11+_#9003
			$g_abChkExtendedAttackBar[$DB] = GUICtrlRead($g_hChkExtendedAttackBarDB) = $GUI_CHECKED ? True : False
			$g_abChkExtendedAttackBar[$LB] = GUICtrlRead($g_hChkExtendedAttackBarLB) = $GUI_CHECKED ? True : False

			; CheckCCTroops - Demen_CC_#9004
			$g_bChkCC = GUICtrlRead($g_hChkTroopsCC) = $GUI_CHECKED ? True : False
			$g_iCmbCastleCapacityT = _GUICtrlComboBox_GetCurSel($g_hCmbCastleCapacityT)
			$g_iCmbCastleCapacityS = _GUICtrlComboBox_GetCurSel($g_hCmbCastleCapacityS)
			For $i = 0 To 4
				$g_aiCmbCCSlot[$i] = _GUICtrlComboBox_GetCurSel($g_ahCmbCCSlot[$i])
				$g_aiTxtCCSlot[$i] = GUICtrlRead($g_ahTxtCCSlot[$i])
			Next

	EndSwitch
EndFunc   ;==>ApplyConfig_Mod

