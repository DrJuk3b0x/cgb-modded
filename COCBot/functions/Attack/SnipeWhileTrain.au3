; #FUNCTION# ====================================================================================================================
; Name ..........: SnipeWhileTrain
; Description ...: During the idle loop, if $chkSnipeWhileTrain is checked, the bot will to for only TH snipe and return after
;                  10 searches to profit from idle time.
;                  VillageSearch() was modified to break search after 10 loops.
;                  GetResources() was modified to turn of SnipeWhileTrain when OoS occurs
;                  4 global variables are used for this function.
;                  Global $chkSnipeWhileTrain, $isSnipeWhileTrain, $tempSnipeWHileTrain[14], $haltSearch
; Syntax ........: SnipeWhileTrain(), TurnOnSnipeWhileTrain(), TurnOffSnipeWhileTrain()
; Parameters ....: None
; Return values .: False if not enough (<30%) troops, True if 10 searches was successfully done.
; Author ........: ChiefM3 (May 2015)
; Modified ......:
; Remarks .......: This file is part of ClashGameBot. Copyright 2015
;                  ClashGameBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================

Func SnipeWhileTrain()
   ; Attempt only when 30% army full to prevent failure of TH snipe
   If $CurCamp / $TotalCamp < 0.5 Then
	  Return False
   EndIf
   ; If army is 90% full of user defined full army then don't attempt TH snipe to prevent delay of full attack (ex: if user defined 90% don't snipe after 81% is full)
   If $CurCamp / $TotalCamp > $fulltroop / 100 * 0.9 Then
	  Return False
   EndIf
   SetLog("SnipeCount = " & $SnipeCount & "MaxSnipe = " & $MaxSnipe, $COLOR_GREEN)
   If $SnipeCount >= $MaxSnipe Then
	  SetLog("SnipeCount to high. Waiting for Full attack", $COLOR_GREEN)
	  Return False
   EndIf

   TurnOnSnipeWhileTrain()

   AttackMain()

   $SnipeCount += 1

   TurnOffSnipeWhileTrain()

   Return True

EndFunc

Func TurnOnSnipeWhileTrain()
   SetLog("[[[Start trying TH snipe while training army]]]", $COLOR_GREEN)
   ; Swap variables to pure TH snipe mode
   $tempSnipeWhileTrain[0] = $iradAttackMode ; attack mode
   $tempSnipeWhileTrain[1] = $chkConditions[0]
   $tempSnipeWhileTrain[2] = $chkConditions[1]
   $tempSnipeWhileTrain[3] = $chkConditions[2]
   $tempSnipeWhileTrain[4] = $chkConditions[3]
   $tempSnipeWhileTrain[5] = $chkConditions[4]
   $tempSnipeWhileTrain[6] = $chkConditions[5]
   $tempSnipeWhileTrain[7] = $chkConditions[6]
   $tempSnipeWhileTrain[8] = $MinGold
   $tempSnipeWHileTrain[9] = $MinElixir
   $tempSnipeWhileTrain[10] = $ichkMeetOne ; search meet one
   $tempSnipeWhileTrain[11] = $chkATH ; Attack Town Hall
   $tempSnipeWhileTrain[12] = $OptTrophyMode ; TH snipe
   $tempSnipeWhileTrain[13] = $THaddtiles ; Th snipe tiles
   $iradAttackMode = 2
   $chkConditions[0] = 0
   $chkConditions[1] = 0
   $chkConditions[2] = 0
   $chkConditions[3] = 1
   $chkConditions[4] = 0
   $chkConditions[5] = 1
   $chkConditions[6] = 0
   $MinGold = 1
   $MinElixir = 1
   $ichkMeetOne = 0
   $chkATH = 1
   GUICtrlSetState($chkAttackTH, $GUI_CHECKED) ;;; For some reason town hall snipe function reads from GUI directly instead of using $chkATH
   ;;; in algorithmTH.au3 and algorithm_AllTroops.au3
   ;;; This is a must be fixed in the official release since it is a waste of resources

   $OptTrophyMode = 1
   $isSnipeWhileTrain = True ; Lets the SearchVillage() function to know this is a part of Snipe While Train MOD
EndFunc

Func TurnOffSnipeWhileTrain()
   $haltSearch = False ; VillageSearch() sets $haltSearch as True to end search after 10 attempts, so put it back to False
   $Is_ClientSyncError = False ; In case 10 searches ends with an OoS
   $isSnipeWhileTrain = False ; Put it back to normal search mode

   ; revert settings back to normal
   $iradAttackMode = $tempSnipeWhileTrain[0]
   $chkConditions[0] = $tempSnipeWhileTrain[1]
   $chkConditions[1] = $tempSnipeWhileTrain[2]
   $chkConditions[2] = $tempSnipeWhileTrain[3]
   $chkConditions[3] = $tempSnipeWhileTrain[4]
   $chkConditions[4] = $tempSnipeWhileTrain[5]
   $chkConditions[5] = $tempSnipeWhileTrain[6]
   $chkConditions[6] = $tempSnipeWhileTrain[7]
   $MinGold = $tempSnipeWhileTrain[8]
   $MinElixir = $tempSnipeWhileTrain[9]
   $ichkMeetOne = $tempSnipeWhileTrain[10]
   $chkATH = $tempSnipeWhileTrain[11]
   If $chkATH = 1 Then ;;; revert GUI checked status to original settings
	  GUICtrlSetState($chkAttackTH, $GUI_CHECKED)
   Else
	  GUICtrlSetState($chkAttackTH, $GUI_UNCHECKED)
   EndIf
   $OptTrophyMode = $tempSnipeWhileTrain[12]
   $THaddtiles = $tempSnipeWhileTrain[13]
   SetLog("[[[End trying TH snipe while training army]]]", $COLOR_RED)
EndFunc
