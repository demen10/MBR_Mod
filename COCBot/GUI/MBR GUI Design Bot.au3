; #FUNCTION# ====================================================================================================================
; Name ..........: MBR GUI Design
; Description ...: This file creates the "Bot" tab
; Syntax ........:
; Parameters ....: None
; Return values .: None
; Author ........:
; Modified ......: CodeSlinger69 (2017)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2017
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
#include-once

Global $g_hGUI_BOT = 0

#include "MBR GUI Design Child Bot - Options.au3"
#include "MBR GUI Design Child Bot - Android.au3"
#include "MBR GUI Design Child Bot - Debug.au3"
#include "MBR GUI Design Child Bot - Profiles.au3"
#include "MBR GUI Design Child Bot - Stats.au3"

Global $g_hGUI_BOT_TAB = 0, $g_hGUI_BOT_TAB_ITEM1 = 0, $g_hGUI_BOT_TAB_ITEM2 = 0, $g_hGUI_BOT_TAB_ITEM3 = 0, $g_hGUI_BOT_TAB_ITEM4 = 0, $g_hGUI_BOT_TAB_ITEM5 = 0
Global $g_hGUI_BOT_TAB_ITEM6 = 0 ; MultiStats For SwitchAcc - Demen_SA_#9001
Global $g_hGUI_LOG_SA ; Set SwitchAcc Log - Demen_SA_#9001

Func CreateBotTab()
	$g_hGUI_BOT = _GUICreate("", $g_iSizeWGrpTab1, $g_iSizeHGrpTab1, $_GUI_CHILD_LEFT, $_GUI_CHILD_TOP, BitOR($WS_CHILD, $WS_TABSTOP), -1, $g_hFrmBotEx)
	;GUISetBkColor($COLOR_WHITE, $g_hGUI_BOT)

	$g_hGUI_LOG_SA = _GUICreate("", 200, 230, 238, 193, BitOR($WS_CHILD, 0), -1, $g_hGUI_BOT)

	$g_hGUI_STATS = _GUICreate("", $g_iSizeWGrpTab2, $g_iSizeHGrpTab2, 5, 25, BitOR($WS_CHILD, $WS_TABSTOP), -1, $g_hGUI_BOT)

	GUISwitch($g_hGUI_BOT)
	$g_hGUI_BOT_TAB = GUICtrlCreateTab(0, 0, $g_iSizeWGrpTab1, $g_iSizeHGrpTab1, BitOR($TCS_MULTILINE, $TCS_RIGHTJUSTIFY))
	$g_hGUI_BOT_TAB_ITEM1 = GUICtrlCreateTabItem(GetTranslatedFileIni("MBR Main GUI", "Tab_04_STab_01", "Options"))
	CreateBotOptions()
	$g_hGUI_BOT_TAB_ITEM2 = GUICtrlCreateTabItem(GetTranslatedFileIni("MBR Main GUI", "Tab_04_STab_02", "Android"))
	CreateBotAndroid()
	$g_hGUI_BOT_TAB_ITEM3 = GUICtrlCreateTabItem(GetTranslatedFileIni("MBR Main GUI", "Tab_04_STab_03", "Debug"))
	CreateBotDebug()
	$g_hGUI_BOT_TAB_ITEM4 = GUICtrlCreateTabItem(GetTranslatedFileIni("MBR Main GUI", "Tab_04_STab_04", "Profiles"))
	CreateBotProfiles()
	CreateBotSwitchAcc() ; SwitchAcc GUI Design - Demen_SA_#9001
	$g_hGUI_BOT_TAB_ITEM5 = GUICtrlCreateTabItem(GetTranslatedFileIni("MBR Main GUI", "Tab_04_STab_05", "Stats"))
	$g_hGUI_BOT_TAB_ITEM6 = GUICtrlCreateTabItem("Multi Stats") ; MultiStats - SwitchAcc - Demen

	; This dummy is used in btnStart and btnStop to disable/enable all labels, text, buttons etc. on all tabs.
	$g_hLastControlToHide = GUICtrlCreateDummy()
	ReDim $g_aiControlPrevState[$g_hLastControlToHide + 1]

	CreateBotSwitchAccLog()  ; Set SwitchAcc Log - Demen_SA_#9001
	CreateMultiStats() ; MultiStats - SwitchAcc - Demen_SA_#9001

	CreateBotStats()
	GUICtrlCreateTabItem("")
EndFunc   ;==>CreateBotTab
