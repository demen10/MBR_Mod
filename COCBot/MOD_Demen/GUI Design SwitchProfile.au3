; #FUNCTION# ====================================================================================================================
; Name ..........: MBR GUI Design
; Description ...: This file creates the "Profiles" tab under the "Bot" tab
; Syntax ........:
; Parameters ....: None
; Return values .: None
; Author ........: NguyenAnhHD (2017)
; Modified ......: Team AiO MOD++ (2017)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2017
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
#include-once

; SwitchProfile - Demen_SP_#9011
Global $g_ahChk_SwitchMax[4], $g_ahChk_SwitchMin[4], $g_ahCmb_SwitchMax[4], $g_ahCmb_SwitchMin[4]
Global $g_ahChk_BotTypeMax[4], $g_ahChk_BotTypeMin[4], $g_ahCmb_BotTypeMax[4], $g_ahCmb_BotTypeMin[4]
Global $g_ahTxt_ConditionMax[4], $g_ahTxt_ConditionMin[4]


Func CreateBotSwitchProfile()

	Local $asText[4] = ["Gold", "Elixir", "DarkE", "Trophy"]
	Local $aIcon[4] = [$eIcnGold, $eIcnElixir, $eIcnDark, $eIcnTrophy]
	Local $aiMax[4] = ["6000000", "6000000", "180000", "5000"]
	Local $aiMin[4] = ["1000000", "1000000", "20000", "3000"]


	Local $x = 25, $y = 41
	Local $profileString = _GUICtrlComboBox_GetList($g_hCmbProfile)

	For $i = 0 To 3
		GUICtrlCreateGroup($asText[$i] & " conditions", $x - 20, $y - 16 + $i * 80, 435, 75)
			$g_ahChk_SwitchMax[$i] = GUICtrlCreateCheckbox("Switch to..", $x - 10, $y + $i * 80, -1, -1)
				GUICtrlSetOnEvent(-1, "chkSwitchProfile")
			$g_ahCmb_SwitchMax[$i] = GUICtrlCreateCombo("", $x + 60, $y + $i * 80, 75, -1, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
				GUICtrlSetData(-1, $profileString, "<No Profiles>")
			$g_ahChk_SwitchMin[$i] = GUICtrlCreateCheckbox("Switch to..", $x - 10, $y + 30 + $i * 80, -1, -1)
				GUICtrlSetOnEvent(-1, "chkSwitchProfile")
			$g_ahCmb_SwitchMin[$i] = GUICtrlCreateCombo("", $x + 60, $y + 30 + $i * 80, 75, -1, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
				GUICtrlSetData(-1, $profileString, "<No Profiles>")

			$g_ahChk_BotTypeMax[$i] = GUICtrlCreateCheckbox("Turn..", $x + 145, $y + $i * 80, -1, -1)
				GUICtrlSetOnEvent(-1, "chkSwitchBotType")
			$g_ahCmb_BotTypeMax[$i] = GUICtrlCreateCombo("", $x + 195, $y + $i * 80, 58, -1, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
				GUICtrlSetData(-1, "Off|Donate|Active", "Donate")
			$g_ahChk_BotTypeMin[$i] = GUICtrlCreateCheckbox("Turn..", $x + 145, $y + 30 + $i * 80, -1, -1)
				GUICtrlSetOnEvent(-1, "chkSwitchBotType")
			$g_ahCmb_BotTypeMin[$i] = GUICtrlCreateCombo("", $x + 195, $y + 30 + $i * 80, 58, -1, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
				GUICtrlSetData(-1, "Off|Donate|Active", "Active")

			GUICtrlCreateLabel("when " & $asText[$i] & " >", $x + 263, $y + 4 + $i * 80, -1, -1)
			$g_ahTxt_ConditionMax[$i] = GUICtrlCreateInput($aiMax[$i], $x + 340, $y + 2 + $i * 80, 50, 18, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
				_GUICtrlSetTip(-1, "Set the amount of " & $asText[$i] & " to trigger switching Profile & Bot Type.")
				GUICtrlCreateIcon($g_sLibIconPath, $aIcon[$i], $x + 393, $y + 3 + $i * 80, 16, 16)

			GUICtrlCreateLabel("when " & $asText[$i] & " <", $x + 263, $y + 34 + $i * 80, -1, -1)
			$g_ahTxt_ConditionMin[$i] = GUICtrlCreateInput($aiMin[$i], $x + 340, $y + 32 + $i * 80, 50, 18, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
				_GUICtrlSetTip(-1, "Set the amount of " & $asText[$i] & " to trigger switching Profile & Bot Type.")
				GUICtrlCreateIcon($g_sLibIconPath, $aIcon[$i], $x + 393, $y + 33 + $i * 80, 16, 16)
			GUICtrlSetLimit(-1, 7)

		GUICtrlCreateGroup("", -99, -99, 1, 1)
	Next

EndFunc