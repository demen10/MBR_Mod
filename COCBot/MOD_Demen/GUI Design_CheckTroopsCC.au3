#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.3.14.2
 Author:         myName

 Script Function:
	Template AutoIt script.

#ce ----------------------------------------------------------------------------

; Script Start - Add your code below here

Global $g_hGrpCheckTroopsCC = 0
Global $g_ahPicCheckTroops[3] = [0,0,0], $g_ahPicCheckSpells[2] = [0,0]
Global $g_ahCmbCheckTroops[3] = [0,0,0], $g_ahCmbCheckSpells[2] = [0,0]
Global $g_ahTxtCheckTroops[3] = [0,0,0], $g_ahTxtCheckSpells[2] = [0,0]

Local $sTxtNothing = "Nothing"
Local $sTxtBarbarians = "Barbarians"
Local $sTxtArchers = "Archers"
Local $sTxtGiants = "Giants"
Local $sTxtGoblins = "Goblins"
Local $sTxtWallBreakers = "Wall Breakers"
Local $sTxtBalloons = "Balloons"
Local $sTxtWizards = "Wizards"
Local $sTxtHealers = "Healers"
Local $sTxtDragons = "Dragons"
Local $sTxtPekkas = "Pekkas"
Local $sTxtMinions = "Minions"
Local $sTxtHogRiders = "Hog Riders"
Local $sTxtValkyries = "Valkyries"
Local $sTxtGolems = "Golems"
Local $sTxtWitches = "Witches"
Local $sTxtLavaHounds = "Lava Hounds"
Local $sTxtBowlers = "Bowlers"
Local $sTxtBabyDragons = "Baby Dragons"
Local $sTxtMiners = "Miners"

Local $sTxtLightningSpells = "Lightning"
Local $sTxtHealSpells = "Heal"
Local $sTxtRageSpells = "Rage"
Local $sTxtJumpSpells = "Jump"
Local $sTxtFreezeSpells = "Freeze"
Local $sTxtPoisonSpells = "Poison"
Local $sTxtEarthquakeSpells = "EarthQuake"
Local $sTxtHasteSpells = "Haste"
Local $sTxtSkeletonSpells = "Skeleton"

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
	If GUICtrlRead($g_hGrpCheckTroopsCC) = $GUI_CHECKED Then
		For $i = $g_ahPicCheckTroops[0] To $g_ahTxtCheckSpells[1]
			GUICtrlSetState($i, $GUI_SHOW)
			GUICtrlSetState($i, $GUI_ENABLE)
		Next
	Else
		For $i = $g_ahPicCheckTroops[0] To $g_ahTxtCheckSpells[1]
			GUICtrlSetState($i, $GUI_DISABLE)
			GUICtrlSetState($i, $GUI_HIDE)
		Next
	EndIf
EndFunc

Func CheckTroopsCC()
	Local $x = 100, $y = 80
		$g_hGrpCheckTroopsCC = GUICtrlCreateCheckbox("Check Troops CC", $x, $y, -1, -1)
			_GUICtrlSetTip(-1, "......")
			GUICtrlSetOnEvent(-1, "cmbCheckCC")
			$y += 25
			$x -= 50
			$g_ahPicCheckTroops[0] = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnDonWizard, $x + 5, $y, 24, 24)
			$g_ahCmbCheckTroops[0] = GUICtrlCreateCombo("", $x + 35, $y, 90, 25, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
				GUICtrlSetData(-1, 	$sTxtBarbarians & "|" & $sTxtArchers & "|" & $sTxtGiants & "|" & $sTxtGoblins & "|" & $sTxtWallBreakers _
									& "|" & $sTxtBalloons & "|" & $sTxtWizards & "|" & $sTxtHealers & "|" & $sTxtDragons & "|" & $sTxtPekkas _
									& "|" & $sTxtBabyDragons & "|" & $sTxtMiners & "|" & $sTxtMinions & "|" & $sTxtHogRiders & "|" & $sTxtValkyries _
									& "|" & $sTxtGolems & "|" & $sTxtWitches & "|" & $sTxtLavaHounds & "|" & $sTxtBowlers & "|" & $sTxtNothing, $sTxtWizards)
				GUICtrlSetOnEvent(-1, "cmbCheckTroopsCC")
			$g_ahTxtCheckTroops[0] = GUICtrlCreateInput("2", $x + 135, $y, 30, 21, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
				GUICtrlSetLimit(-1, 1)

			$g_ahPicCheckTroops[1] = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnDonArcher, $x + 5, $y + 25, 24, 24)
			$g_ahCmbCheckTroops[1] = GUICtrlCreateCombo("", $x + 35, $y + 25, 90, 25, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
				GUICtrlSetData(-1, $sTxtBarbarians & "|" & $sTxtArchers & "|" & $sTxtGiants & "|" & $sTxtGoblins & "|" & $sTxtWallBreakers & "|" & $sTxtBalloons & "|" & $sTxtWizards & "|" & $sTxtHealers & "|" & $sTxtDragons & "|" & $sTxtPekkas & "|" & $sTxtBabyDragons & "|" & $sTxtMiners & "|" & $sTxtMinions & "|" & $sTxtHogRiders & "|" & $sTxtValkyries & "|" & $sTxtGolems & "|" & $sTxtWitches & "|" & $sTxtLavaHounds & "|" & $sTxtBowlers & "|" & $sTxtNothing, $sTxtArchers)
				GUICtrlSetOnEvent(-1, "cmbCheckTroopsCC")
			$g_ahTxtCheckTroops[1] = GUICtrlCreateInput("3", $x + 135, $y + 25, 30, 21, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
				GUICtrlSetLimit(-1, 1)

			$g_ahPicCheckTroops[2] = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnDonBarbarian, $x + 5, $y + 50, 24, 24)
			$g_ahCmbCheckTroops[2] = GUICtrlCreateCombo("", $x + 35, $y + 50, 90, 25, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
				GUICtrlSetData(-1, $sTxtBarbarians & "|" & $sTxtArchers & "|" & $sTxtGiants & "|" & $sTxtGoblins & "|" & $sTxtWallBreakers & "|" & $sTxtBalloons & "|" & $sTxtWizards & "|" & $sTxtHealers & "|" & $sTxtDragons & "|" & $sTxtPekkas & "|" & $sTxtBabyDragons & "|" & $sTxtMiners & "|" & $sTxtMinions & "|" & $sTxtHogRiders & "|" & $sTxtValkyries & "|" & $sTxtGolems & "|" & $sTxtWitches & "|" & $sTxtLavaHounds & "|" & $sTxtBowlers & "|" & $sTxtNothing, $sTxtBarbarians)
				GUICtrlSetOnEvent(-1, "cmbCheckTroopsCC")
			$g_ahTxtCheckTroops[2] = GUICtrlCreateInput("1", $x + 135, $y + 50, 30, 21, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
				GUICtrlSetLimit(-1, 1)

			$g_ahPicCheckSpells[0] = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnLightSpell, $x + 180, $y, 24, 24)
			$g_ahCmbCheckSpells[0] = GUICtrlCreateCombo("", $x + 210, $y, 80, 25, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
				GUICtrlSetData(-1, $sTxtLightningSpells & "|" & $sTxtHealSpells & "|" & $sTxtRageSpells & "|" & $sTxtJumpSpells & "|" & $sTxtFreezeSpells & "|" & $sTxtPoisonSpells & "|" & $sTxtEarthquakeSpells & "|" & $sTxtHasteSpells & "|" & $sTxtSkeletonSpells & "|" & $sTxtNothing, $sTxtLightningSpells)
				GUICtrlSetOnEvent(-1, "cmbCheckSpellsCC")
			$g_ahTxtCheckSpells[0] = GUICtrlCreateInput("2", $x + 300, $y, 30, 21, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
				GUICtrlSetLimit(-1, 1)

			$g_ahPicCheckSpells[1] = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnDonHasteSpell, $x + 180, $y + 25, 24, 24)
			$g_ahCmbCheckSpells[1] = GUICtrlCreateCombo("", $x + 210, $y + 25, 80, 25, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
				GUICtrlSetData(-1, $sTxtLightningSpells & "|" & $sTxtHealSpells & "|" & $sTxtRageSpells & "|" & $sTxtJumpSpells & "|" & $sTxtFreezeSpells & "|" & $sTxtPoisonSpells & "|" & $sTxtEarthquakeSpells & "|" & $sTxtHasteSpells & "|" & $sTxtSkeletonSpells & "|" & $sTxtNothing, $sTxtHasteSpells)
				GUICtrlSetOnEvent(-1, "cmbCheckSpellsCC")
			$g_ahTxtCheckSpells[1] = GUICtrlCreateInput("3", $x + 300, $y + 25, 30, 21, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
				GUICtrlSetLimit(-1, 1)

	For $i = $g_ahPicCheckTroops[0] To $g_ahTxtCheckSpells[1]
		GUICtrlSetState($i, $GUI_HIDE)
	Next

EndFunc