#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Icon=..\..\..\..\..\Program Files (x86)\Steam\steam.ico
#AutoIt3Wrapper_UseUpx=n
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****

TraySetState(2)
Global Const $GUI_EVENT_CLOSE = -3

$sContents = FileRead('Settings.txt')
$aReturn = StringRegExp($sContents, '<(.+)>([^<\n]*|)<(.+)>', 3)
Local $aAccounts[UBound($aReturn)/3][2]
For $i = 0 To UBound($aReturn)-1 Step 3
	$aAccounts[$i/3][0] = $aReturn[$i]
	$aAccounts[$i/3][1] = $aReturn[$i+2]
Next
$aReturn = StringRegExp($sContents, '\n"([^"]*)"$', 3)
$sSteamDir = $aReturn[0]

$NumOfButtons = UBound($aAccounts)
$Mpos = MouseGetPos()
If $Mpos[0] + 183 > @DesktopWidth Then $Mpos[0]-= 183
If $Mpos[1] + 40*$NumOfButtons > @DesktopHeight Then $Mpos[1]-= 40*$NumOfButtons
$Form = GUICreate("Select", 183, 5 + 40*$NumOfButtons, $Mpos[0], $Mpos[1])
Local $Button[$NumOfButtons]
For $i = 0 To $NumOfButtons - 1
	$Button[$i] = GUICtrlCreateButton($aAccounts[$i][0], 8, 5+40*$i, 161, 35)
Next
GUISetState(@SW_SHOW)

While 1
	$nMsg = GUIGetMsg()
	Switch $nMsg
		Case $GUI_EVENT_CLOSE
			Exit

		Case Else
			For $i = 0 To $NumOfButtons - 1
				If $nMsg = $Button[$i] Then
					SteamLogin($sSteamDir, $aAccounts[$i][0], $aAccounts[$i][1])
				EndIf
			Next
			If Not(WinActive($Form)) Then Exit

	EndSwitch
WEnd

Func SteamLogin($SteamLoc, $Username, $Password)
	If ProcessExists("steam.exe") Then ProcessClose("steam.exe")
	ShellExecute($SteamLoc, '-silent -login '&$Username&' '&$Password)
	Exit
EndFunc