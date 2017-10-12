; #FUNCTION# ====================================================================================================================
; Name ..........: MBR Global Variables for Demen Mod
; Description ...: This file Includes several files in the current script and all Declared variables, constant, or create an array.
; Syntax ........: #include , Global
; Parameters ....: None
; Return values .: None
; Author ........: Demen
; Modified ......: Everyone all the time  :)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2016
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
#include-once

; SwitchAcc - Demen_SA_#9001
Global $g_bInitiateSwitchAcc = True, $g_bChkSwitchAcc, $g_bChkSmartSwitch, $g_bReMatchAcc = False
Global $g_iTotalAcc, $g_iNextAccount, $g_iCurAccount
Global $g_iTrainTimeToSkip = 0
Global $g_abAccountNo[8], $g_aiProfileNo[8], $g_abDonateOnly[8]
Global $g_aiAttackedCountSwitch[8], $g_iActiveSwitchCounter = 0, $g_iDonateSwitchCounter = 0
Global $g_aiRemainTrainTime[8], $g_aiTimerStart[8]
Global $g_oTxtSALogInitText = ObjCreate("Scripting.Dictionary")
Global $g_hSwitchLogFile = 0
Global $g_aiGoldTotalAcc[8], $g_aiElixirTotalAcc[8], $g_aiDarkTotalAcc[8], $g_aiTrophyLootAcc[8], $g_aiAttackedCountAcc[8], $g_aiSkippedVillageCountAcc[8] ; Total Gain
Global $g_aiGoldCurrentAcc[8], $g_aiElixirCurrentAcc[8], $g_aiDarkCurrentAcc[8], $g_aiTrophyCurrentAcc[8], $g_aiGemAmountAcc[8], $g_aiFreeBuilderCountAcc[8], $g_aiTotalBuilderCountAcc[8] ; village report

; SmartTrain - Demen_ST_#9002
Global $ichkSmartTrain, $ichkPreciseTroops, $ichkFillArcher, $iFillArcher, $ichkFillEQ
Global $g_bWaitForCCTroopSpell = False	; ForceSwitch while waiting for CC troops - Demen
Global Enum $g_eFull, $g_eRemained, $g_eNoTrain
Global $g_abRCheckWrongTroops[2] = [False, False] ; Result of checking wrong troops & spells
Global $g_aiQueueTroops[$eTroopCount] = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
Global $g_aiQueueSpells[$eSpellCount] = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0]

; ExtendedAttackBar - Demen_S11_#9003
Global $g_hChkExtendedAttackBarLB, $g_hChkExtendedAttackBarDB, $g_abChkExtendedAttackBar[2]
Global $g_iTotalAttackSlot = 10, $g_bDraggedAttackBar = False ; flag if AttackBar is dragged or not

; CheckCC Troops - Demen_CC_#9004
Global $g_aiCCTroops[$eTroopCount] = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
Global $g_aiCCSpells[$eSpellCount] = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
Global $g_aiCCTroopsExpected[$eTroopCount] = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
Global $g_aiCCSpellsExpected[$eSpellCount] = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
Global $g_bChkCC, $g_bChkCCTroops
Global $g_aiCmbCCSlot[5], $g_aiTxtCCSlot[5]
Global $g_iCmbCastleCapacityT, $g_iCmbCastleCapacityS

; Hero & Lab Status - Demen_HL_#9005
Global $g_bNeedLocateLab = True, $g_bLabReady[9]
Global $g_aLabTimeAcc[8], $g_aLabTime[4] = [0, 0, 0, 0] ; day | hour | minute | time in minutes
Global $g_aLabTimerStart[8], $g_aLabTimerEnd[8]

; QuickTrainCombo (Checkbox) - Demen_QT_#9006
Global $g_bQuickTrainArmy[3] = [True, False, False]
Global $g_bChkMultiClick, $g_iMultiClick = 1

; Classic FourFinger - Demen_FF_#9007
; Enable/Disable GUI - Demen_EG_#9008
; Other mod's Code ref. Demen_OT_#9009
; General common codes - Demen_GE_#9000

; FarmSchedule - Demen_FS_#9012
Global $g_abChkSetFarm[8]
Global $g_aiCmbAction1[8], $g_aiCmbCriteria1[8], $g_aiTxtResource1[8], $g_aiCmbTime1[8]
Global $g_aiCmbAction2[8], $g_aiCmbCriteria2[8], $g_aiTxtResource2[8], $g_aiCmbTime2[8]
