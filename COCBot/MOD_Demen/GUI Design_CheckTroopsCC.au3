; #FUNCTION# ====================================================================================================================
; Name ..........: GUI Design _ CheckTroopsCC
; Description ...: This file contains the Sequence that runs all MBR Bot
; Author ........: NguyenAnhHD, DEMEN
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2016
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

Global $g_hChkTroopsCC = 0
Global $g_ahPicCheckTroops[3] = [0, 0, 0], $g_ahPicCheckSpells[2] = [0, 0]
Global $g_ahCmbCheckTroops[3] = [0, 0, 0], $g_ahCmbCheckSpells[2] = [0, 0]
Global $g_ahTxtCheckTroops[3] = [0, 0, 0], $g_ahTxtCheckSpells[2] = [0, 0]

Local $sTroopText = _ArrayToString($g_asTroopNames)
$sTroopText &= "|Any"

Local $asDonSpell = $g_asSpellNames
_ArrayDelete($asDonSpell, 5) ; removing "Clone" as it does not fit for CC slots.
Local $sSpellText = _ArrayToString($asDonSpell)
$sSpellText &= "|Any"

Global $g_aiTroopsIcons[20] = [$eIcnDonBarbarian, $eIcnDonArcher, $eIcnDonGiant, $eIcnDonGoblin, $eIcnDonWallBreaker, $eIcnDonBalloon, $eIcnDonWizard, $eIcnDonHealer, _
		$eIcnDonDragon, $eIcnDonPekka, $eIcnDonBabyDragon, $eIcnDonMiner, $eIcnDonMinion, $eIcnDonHogRider, $eIcnDonValkyrie, $eIcnDonGolem, _
		$eIcnDonWitch, $eIcnDonLavaHound, $eIcnDonBowler, $eIcnDonBlank]

Global $g_aiSpellsIcons[10] = [$eIcnLightSpell, $eIcnHealSpell, $eIcnRageSpell, $eIcnJumpSpell, $eIcnFreezeSpell, _
		$eIcnDonPoisonSpell, $eIcnDonEarthQuakeSpell, $eIcnDonHasteSpell, $eIcnDonSkeletonSpell, $eIcnDonBlank]

Func cmbCheckTroopsCC()
	Local $Combo1 = _GUICtrlComboBox_GetCurSel($g_ahCmbCheckTroops[0])
	Local $Combo2 = _GUICtrlComboBox_GetCurSel($g_ahCmbCheckTroops[1])
	Local $Combo3 = _GUICtrlComboBox_GetCurSel($g_ahCmbCheckTroops[2])
	_GUICtrlSetImage($g_ahPicCheckTroops[0], $g_sLibIconPath, $g_aiTroopsIcons[$Combo1])
	_GUICtrlSetImage($g_ahPicCheckTroops[1], $g_sLibIconPath, $g_aiTroopsIcons[$Combo2])
	_GUICtrlSetImage($g_ahPicCheckTroops[2], $g_sLibIconPath, $g_aiTroopsIcons[$Combo3])
EndFunc   ;==>cmbCheckTroopsCC

Func cmbCheckSpellsCC()
	Local $Combo4 = _GUICtrlComboBox_GetCurSel($g_ahCmbCheckSpells[0])
	Local $Combo5 = _GUICtrlComboBox_GetCurSel($g_ahCmbCheckSpells[1])
	_GUICtrlSetImage($g_ahPicCheckSpells[0], $g_sLibIconPath, $g_aiSpellsIcons[$Combo4])
	_GUICtrlSetImage($g_ahPicCheckSpells[1], $g_sLibIconPath, $g_aiSpellsIcons[$Combo5])
EndFunc   ;==>cmbCheckSpellsCC

Func cmbCheckCC()
	If GUICtrlRead($g_hChkTroopsCC) = $GUI_CHECKED Then
		For $i = $g_ahPicCheckTroops[0] To $g_ahTxtCheckTroops[2]
			GUICtrlSetState($i, $GUI_ENABLE)
		Next
	Else
		For $i = $g_ahPicCheckTroops[0] To $g_ahTxtCheckTroops[2]
			GUICtrlSetState($i, $GUI_DISABLE)
		Next
	EndIf
EndFunc   ;==>cmbCheckCC

Func CheckTroopsCC()
	Local $x = 100, $y = 80
	$g_hChkTroopsCC = GUICtrlCreateCheckbox("Check Troops CC", $x, $y, -1, -1)
	_GUICtrlSetTip(-1, "......")
	GUICtrlSetOnEvent(-1, "cmbCheckCC")
	$y += 25
	$x -= 50
	For $i = 0 To 2
		$g_ahPicCheckTroops[$i] = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnDonBlank, $x + 5, $y + $i * 25, 24, 24)
		$g_ahCmbCheckTroops[$i] = GUICtrlCreateCombo("", $x + 35, $y + $i * 25, 90, 25, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
		GUICtrlSetData(-1, $sTroopText, "Any")
		GUICtrlSetOnEvent(-1, "cmbCheckTroopsCC")
		$g_ahTxtCheckTroops[$i] = GUICtrlCreateInput("0", $x + 135, $y + $i * 25, 30, 21, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
		GUICtrlSetLimit(-1, 1)
#cs
		If $i < 2 Then
			$g_ahPicCheckSpells[$i] = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnDonBlank, $x + 180, $y + $i * 25, 24, 24)
			$g_ahCmbCheckSpells[$i] = GUICtrlCreateCombo("", $x + 210, $y + $i * 25, 80, 25, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
			GUICtrlSetData(-1, $sSpellText, "Any")
			GUICtrlSetOnEvent(-1, "cmbCheckSpellsCC")
			$g_ahTxtCheckSpells[$i] = GUICtrlCreateInput("0", $x + 300, $y + $i * 25, 30, 21, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
			GUICtrlSetLimit(-1, 1)
		EndIf
#CE
	Next
	For $i = $g_ahPicCheckTroops[0] To $g_ahTxtCheckTroops[2]
		GUICtrlSetState($i, $GUI_DISABLE)
	Next

EndFunc   ;==>CheckTroopsCC
