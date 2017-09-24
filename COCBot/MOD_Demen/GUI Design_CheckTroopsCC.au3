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
; CheckCC Troops - Demen_CC_#9004
#include-once

Global $g_hLblCastleCapacity = 0, $g_hCmbCastleCapacityT = 0, $g_hCmbCastleCapacityS = 0, $g_hChkTroopsCC = 0, $g_hLblWarningTextCheckCC = 0
Global $g_ahPicCCSlot[5] = [0, 0, 0, 0, 0], $g_ahCmbCCSlot[5] = [0, 0, 0, 0, 0], $g_ahTxtCCSlot[5] = [0, 0, 0, 0, 0]

Func GUIControlCheckCC()

	Local $aIcons[30] = [$eIcnDonBarbarian, $eIcnDonArcher, $eIcnDonGiant, $eIcnDonGoblin, $eIcnDonWallBreaker, $eIcnDonBalloon, _
			$eIcnDonWizard, $eIcnDonHealer, $eIcnDonDragon, $eIcnDonPekka, $eIcnDonBabyDragon, $eIcnDonMiner, $eIcnDonMinion, _
			$eIcnDonHogRider, $eIcnDonValkyrie, $eIcnDonGolem, $eIcnDonWitch, $eIcnDonLavaHound, $eIcnDonBowler, $eIcnDonBlank, _
			$eIcnLightSpell, $eIcnHealSpell, $eIcnRageSpell, $eIcnJumpSpell, $eIcnFreezeSpell, _
			$eIcnPoisonSpell, $eIcnEarthQuakeSpell, $eIcnHasteSpell, $eIcnSkeletonSpell, $eIcnDonBlank]

	Local $iCastleCapT, $iCastleCapS

	Local $sWarningTxt = "Please set troops/spells to fit your Castle Capacity"
	Local $color = $COLOR_BLACK

	; updating icon
	For $i = 0 To 4
		Local $CmbSel = _GUICtrlComboBox_GetCurSel($g_ahCmbCCSlot[$i])
		If $i >= 3 Then $CmbSel += 20
		If $CmbSel <> $aIcons[$CmbSel] Then _GUICtrlSetImage($g_ahPicCCSlot[$i], $g_sLibIconPath, $aIcons[$CmbSel])
	Next

	; checking expect/total for warning
	If GUICtrlRead($g_hChkTroopsCC) = $GUI_CHECKED Then
		Local $iTotalExpectT = 0, $iTotalExpectS = 0

		$iCastleCapT = 10 + _GUICtrlComboBox_GetCurSel($g_hCmbCastleCapacityT) * 5
		$iCastleCapS = _GUICtrlComboBox_GetCurSel($g_hCmbCastleCapacityS) + 1

		Local $bAnyT = True, $bAnyS = True

		For $i = 0 To 4
			Local $Idx = _GUICtrlComboBox_GetCurSel($g_ahCmbCCSlot[$i])
			Local $Qty = GUICtrlRead($g_ahTxtCCSlot[$i])

			If $i <= 2 Then
				If $Idx <= $eTroopBowler Then
					$iTotalExpectT += $Qty * $g_aiTroopSpace[$Idx]
					$bAnyT = False
				EndIf
			Else
				If $Idx > $eSpellFreeze Then $Idx += 1 ; exclude Clone Spell
				If $Idx <= $eSpellSkeleton Then
					$iTotalExpectS += $Qty * $g_aiSpellSpace[$Idx]
					$bAnyS = False
				EndIf
			EndIf
		Next

		If $bAnyT = False Or $bAnyS = False Then
			Local $sTxtTroopSpell[3] = ["", "", ""] ; Less, More, Equal
			Local $sTxtExpectVsCapacity = ""

			; troop text
			If $bAnyT = False Then
				$sTxtTroopSpell[0] = $iTotalExpectT < $iCastleCapT ? "Troop " : ""
				$sTxtTroopSpell[1] = $iTotalExpectT > $iCastleCapT ? "Troop " : ""
				$sTxtTroopSpell[2] = $iTotalExpectT = $iCastleCapT ? "Troop " : ""
				$sTxtExpectVsCapacity = $iTotalExpectT & "/" & $iCastleCapT
			EndIf

			; joining spell
			If $bAnyS = False Then
				If $iTotalExpectS < $iCastleCapS Then
					$sTxtTroopSpell[0] &= "&& Spell "
				ElseIf $iTotalExpectS > $iCastleCapS Then
					$sTxtTroopSpell[1] &= "&& Spell "
				Else
					$sTxtTroopSpell[2] &= "&& Spell "
				EndIf
				$sTxtExpectVsCapacity &= "; " & $iTotalExpectS & "/" & $iCastleCapS
			EndIf

			; removing character "&" and ";"
			For $i = 0 To 2
				If StringLeft($sTxtTroopSpell[$i], 1) = "&" Then $sTxtTroopSpell[$i] = StringTrimLeft($sTxtTroopSpell[$i], 3)
			Next
			If StringLeft($sTxtExpectVsCapacity, 1) = ";" Then $sTxtExpectVsCapacity = StringTrimLeft($sTxtExpectVsCapacity, 2)

			If ($bAnyT = False And $iTotalExpectT < $iCastleCapT) Or ($bAnyS = False And $iTotalExpectS < $iCastleCapS) Then
				$sWarningTxt = $sTxtTroopSpell[0] & "expectation is less than CC capacity (" & $sTxtExpectVsCapacity & ")" & @CRLF & "WARNING: Your " & $sTxtTroopSpell[0] & "CC will never be full."
				$color = $COLOR_RED
			ElseIf $iTotalExpectT > $iCastleCapT Or $iTotalExpectS > $iCastleCapS Then
				$sWarningTxt = $sTxtTroopSpell[1] & "expectation is more than CC capacity (" & $sTxtExpectVsCapacity & ")"
				$color = $COLOR_ORANGE
			Else
				$sWarningTxt = $sTxtTroopSpell[2] & "expectation fits your Castle capacity nicely (" & $sTxtExpectVsCapacity & ")"
				$color = $COLOR_GREEN
			EndIf
		EndIf
	EndIf
	GUICtrlSetData($g_hLblWarningTextCheckCC, $sWarningTxt)
	GUICtrlSetColor($g_hLblWarningTextCheckCC, $color)
EndFunc   ;==>GUIControlCheckCC

Func CreateGUICheckCC()
	Local $x = 100, $y = 80, $x_offset = 0, $y_offset = 0, $sCmbList = ""
	GUICtrlCreateGroup("CC Troop && Spell expectation", $x, $y, 325, 200)
	$y += 25
	$x += 5

	$g_hLblCastleCapacity = GUICtrlCreateLabel("Castle Capacity:", $x + 5, $y, -1, -1)
	$g_hCmbCastleCapacityT = GUICtrlCreateCombo("", $x + 85, $y - 2, 35, 25)
	GUICtrlSetData(-1, "10|15|20|25|30|35", "35")
	GUICtrlSetOnEvent(-1, "GUIControlCheckCC")
	GUICtrlCreateLabel("Troops", $x + 125, $y, -1, -1)
	$g_hCmbCastleCapacityS = GUICtrlCreateCombo("", $x + 195, $y - 2, 35, 25)
	GUICtrlSetData(-1, "1|2", "2")
	GUICtrlCreateLabel("Spells", $x + 235, $y, -1, -1)

	$y += 30
	For $i = 0 To 4
		If $i <= 2 Then ; 3 troop slots
			$y_offset = $i * 25
			$sCmbList = _ArrayToString($g_asTroopNames)
		Else ; 2 spell slots
			$x_offset = 160
			$y_offset = ($i - 3) * 25
			$sCmbList = StringReplace(_ArrayToString($g_asSpellNames), "Clone|", "") ; removing "Clone" as it does not fit for CC slots.
		EndIf
		$sCmbList &= "|Any"

		$g_ahPicCCSlot[$i] = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnDonBlank, $x + 5 + $x_offset, $y + $y_offset, 24, 24)
		$g_ahCmbCCSlot[$i] = GUICtrlCreateCombo("", $x + 35 + $x_offset, $y + $y_offset, 85, 25, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
		GUICtrlSetData(-1, $sCmbList, "Any")
		GUICtrlSetOnEvent(-1, "GUIControlCheckCC")
		$g_ahTxtCCSlot[$i] = GUICtrlCreateInput("0", $x + 125 + $x_offset, $y + $y_offset, 25, 21, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
		GUICtrlSetLimit(-1, 1)
		GUICtrlSetOnEvent(-1, "GUIControlCheckCC")
	Next

	$y += 80

	$g_hChkTroopsCC = GUICtrlCreateCheckbox("Remove unwanted troops and spells in CC", $x + 5, $y, -1, -1)
	_GUICtrlSetTip(-1, "Checking troops/spells in CC. Remove any item other than the above expected.")
	GUICtrlSetOnEvent(-1, "GUIControlCheckCC")

	$g_hLblWarningTextCheckCC = GUICtrlCreateLabel("Please set troops/spells to fit your Castle Capacity", $x + 21, $y + 25, 298, 30)

	GUICtrlCreateGroup("", -99, -99, 1, 1)
EndFunc   ;==>CreateGUICheckCC