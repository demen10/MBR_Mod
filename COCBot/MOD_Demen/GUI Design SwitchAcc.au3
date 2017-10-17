; #FUNCTION# ====================================================================================================================
; Name ..........: GUI Design SwitchAcc - Demen_SA_#9001
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

Global $g_hChkSwitchAcc = 0, $g_hCmbTotalAccount = 0, $g_hChkSmartSwitch = 0, $g_hCmbTrainTimeToSkip = 0
Global $g_ahChkAccount[8], $g_ahCmbProfile[8], $g_ahChkDonate[8]
Global $g_hTxtSALog

Func CreateBotSwitchAcc()

	Local $x = 10, $y = 30

;	GUICtrlCreateGroup("Switch Account", $x - 10, $y - 20, 433, 337)

		$g_hChkSwitchAcc = GUICtrlCreateCheckbox("Enable Switch Account", $x, $y, -1, -1)
		GUICtrlSetOnEvent(-1, "chkSwitchAcc")

		$g_hCmbTotalAccount = GUICtrlCreateCombo("", $x + 340, $y - 1, 77, -1, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
		GUICtrlSetData(-1, "2 accounts|3 accounts|4 accounts|5 accounts|6 accounts|7 accounts|8 accounts", "2 accounts")
		GUICtrlSetOnEvent(-1, "cmbTotalAcc")
		GUICtrlCreateLabel("Total CoC Account:", $x + 220, $y + 3, -1, -1)

		$y += 25
		$g_hChkSmartSwitch = GUICtrlCreateCheckbox("Smart switch", $x, $y, -1, -1)
		GUICtrlSetTip(-1, "Switch to account with the shortest remain training time")
		GUICtrlSetState(-1, $GUI_UNCHECKED)

		GUICtrlCreateLabel("Skip switch if train time < ", $x + 220, $y + 3, -1, -1)
		$g_hCmbTrainTimeToSkip = GUICtrlCreateCombo("", $x + 340, $y - 1, 77, -1, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
		GUICtrlSetData(-1, "0 minute|1 minute|2 minutes|3 minutes|4 minutes|5 minutes|6 minutes|7 minutes|8 minutes|9 minutes", "1 minute")

		$y += 32
		GUICtrlCreateLabel("Account", $x - 5, $y, 60, -1, $SS_CENTER)
		GUICtrlCreateLabel("Profile name", $x + 82, $y, 70, -1, $SS_CENTER)
		GUICtrlCreateLabel("Donate only", $x + 170, $y, 60, -1, $SS_CENTER)
		GUICtrlCreateLabel("SwitchAcc log", $x + 280, $y, -1, -1, $SS_CENTER)

		$y += 18
		GUICtrlCreateGraphic($x, $y, 417, 1, $SS_GRAYRECT)

		$y += 8
		For $i = 0 To 7
			$g_ahChkAccount[$i] = GUICtrlCreateCheckbox("Acc " & $i + 1 & ".", $x, $y + ($i) * 25, -1, -1)
			GUICtrlSetOnEvent(-1, "chkAccount" & $i)
			$g_ahCmbProfile[$i] = GUICtrlCreateCombo("", $x + 65, $y + ($i) * 25, 110, 25, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
			GUICtrlSetData(-1, _GUICtrlComboBox_GetList($g_hCmbProfile))
			$g_ahChkDonate[$i] = GUICtrlCreateCheckbox("", $x + 190, $y + ($i) * 25 - 3, -1, 25)
		Next

;	GUICtrlCreateGroup("", -99, -99, 1, 1)

EndFunc   ;==>CreateBotSwitchAcc

Func CreateBotSwitchAccLog()
	Local $x = 0, $y = 0

	Local $activeHWnD1 = WinGetHandle("") ; RichEdit Controls tamper with active window

	$g_hTxtSALog = _GUICtrlRichEdit_Create($g_hGUI_LOG_SA, "", $x, $y, 203, 227, BitOR($ES_MULTILINE, $ES_READONLY, $WS_VSCROLL, $WS_HSCROLL, $ES_UPPERCASE, $ES_AUTOHSCROLL, $ES_AUTOVSCROLL, $ES_NUMBER, 0x200), $WS_EX_STATICEDGE)

	WinActivate($activeHWnD1) ; restore current active window
EndFunc



