; #FUNCTION# ====================================================================================================================
; Name ..........: MBR GUI Design Child Bot - Profiles Switch Account
; Description ...:
; Syntax ........:
; Parameters ....: None
; Return values .: None
; Author ........: Demen
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2016
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
#include-once

; SwitchAcc_Demen
Global $lblProfileNo[8], $lblProfileName[8], $cmbAccountNo[8], $cmbProfileType[8]
Global $cmbTotalAccount = 0, $radNormalSwitch = 0, $radSmartSwitch = 0, $chkUseTrainingClose = 0, $radCloseCoC = 0, $radCloseAndroid = 0, $cmbLocateAcc = 0, $g_hCmbTrainTimeToSkip = 0
Global $g_hChkForceSwitch = 0, $g_txtForceSwitch = 0, $g_lblForceSwitch = 0, $g_hChkForceStayDonate = 0

; New
Global $g_hChkSwitchAcc = 0, $g_hCmbTotalAccount = 0, $g_hChkSmartSwitch = 0
Global $g_ahChkAccount[8], $g_ahCmbProfile[8], $g_ahChkDonate[8]
Global $g_hTxtSALog

Func CreateBotSwitchAcc()

	Local $sTxtTip = ""
	Local $x = 20, $y = 110

	GUICtrlCreateGroup("Switch Account", $x - 10, $y - 20, 225, 335)

		$g_hChkSwitchAcc = GUICtrlCreateCheckbox("Enable SwitchAccount", $x, $y, -1, -1)
		GUICtrlSetOnEvent(-1, "chkSwitchAcc")

		$g_hChkSmartSwitch = GUICtrlCreateCheckbox("Smart switch", $x + 135, $y, 75, -1)
		GUICtrlSetTip(-1, "Switch to account with the shortest remain training time")
		GUICtrlSetState(-1, $GUI_UNCHECKED)
;~ 		GUICtrlSetOnEvent(-1, "chkSmartSwitch")

		$y += 26
		GUICtrlCreateLabel("Skip switch if train time < ", $x + 15, $y, -1, -1)
		$g_hCmbTrainTimeToSkip = GUICtrlCreateCombo("", $x + 135, $y - 4, 60, -1, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
		GUICtrlSetData(-1, "0 min|1 min|2 mins|3 mins|4 mins|5 mins|6 mins|7 mins|8 mins|9 mins", "1 min")

		$y += 25
		GUICtrlCreateLabel("Total CoC Account:", $x + 15, $y, -1, -1)
		$g_hCmbTotalAccount = GUICtrlCreateCombo("", $x + 135, $y - 4, 60, -1, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
		GUICtrlSetData(-1, "2 Acc|3 Acc|4 Acc|5 Acc|6 Acc|7 Acc|8 Acc", "2 Acc")
		GUICtrlSetOnEvent(-1, "cmbTotalAcc")

		$y += 30
		GUICtrlCreateLabel("Account", $x - 10, $y, 60, -1, $SS_CENTER)
		GUICtrlCreateLabel("Profile name", $x + 70, $y, 70, -1, $SS_CENTER)
		GUICtrlCreateLabel("Donate only", $x + 150, $y, 60, -1, $SS_CENTER)

		$y += 20
		GUICtrlCreateGraphic($x, $y, 205, 1, $SS_GRAYRECT)

		$y += 8
		For $i = 0 To 7
			$g_ahChkAccount[$i] = GUICtrlCreateCheckbox("Acc. " & $i + 1 & ".", $x, $y + ($i) * 25, -1, -1)
			GUICtrlSetOnEvent(-1, "chkAccount" & $i)
			$g_ahCmbProfile[$i] = GUICtrlCreateCombo("", $x + 65, $y + ($i) * 25, 110, 25, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
			GUICtrlSetData(-1, _GUICtrlComboBox_GetList($g_hCmbProfile))
			$g_ahChkDonate[$i] = GUICtrlCreateCheckbox("", $x + 190, $y + ($i) * 25 - 3, -1, 25)
		Next

	GUICtrlCreateGroup("", -99, -99, 1, 1)

EndFunc   ;==>CreateBotSwitchAcc

Func CreateBotSwitchAccLog()
	Local $x = 0, $y = 0

	Local $activeHWnD1 = WinGetHandle("") ; RichEdit Controls tamper with active window

	$g_hTxtSALog = _GUICtrlRichEdit_Create($g_hGUI_LOG_SA, "", $x, $y, 203, 330, BitOR($ES_MULTILINE, $ES_READONLY, $WS_VSCROLL, $WS_HSCROLL, $ES_UPPERCASE, $ES_AUTOHSCROLL, $ES_AUTOVSCROLL, $ES_NUMBER, 0x200), $WS_EX_STATICEDGE)

	WinActivate($activeHWnD1) ; restore current active window
EndFunc



