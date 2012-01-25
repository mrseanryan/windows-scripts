; script to find all explorer windows with duplicate address (not title !), and close them
;
; this script just looks at the title of the Window, and tries to extract the full address
;
;dependencies: AutoIt3
;
; tested on :
; Windows 7 Home 
; Windows 7 Pro 
; XP Home

#include <Array.au3>

Local $aExplorerTitles[1]
Local $aClosedAddresses[1]


$aWinTitles = WinList()
$numWindowsClosed = 0
Local $aExpAddresses[1]
$aExpAddresses[0] = 'dummy entry'

For $i = 1 to $aWinTitles[0][0]
	; Only consider visble windows that have a title
	$winTitle = $aWinTitles[$i][0]
	$winHandle = $aWinTitles[$i][1]
	If $winTitle <> "" AND IsVisible($aWinTitles[$i][1]) Then
		
		$bHasAddress = False

		If @OSVersion = "WIN_7" Then
			$expAddress = WinGetText($winHandle,"")
			If StringInStr($expAddress, "Address:") <> 0 Then
				;;MsgBox(0, "Win7 explorer Address 1", $expAddress)
				$expAddress = StringReplace($expAddress, "Address: ", "")
				;;MsgBox(0, "Win7 explorer Address 2", $expAddress)
				$aLines = StringSplit($expAddress, @CRLF)
				If $aLines[0] > 0 Then
					$expAddress = $aLines[1]
					;MsgBox(0, "Win7 explorer Address 3", $expAddress)
					$bHasAddress = (StringLen($expAddress) > 0)
				EndIf
			EndIf
		Else
			;XP or other
			$expAddress = ControlGetText($winHandle,'','Edit1') ; ok on XP
			;;MsgBox(0, "explorer Address", $expAddress)
			$bHasAddress = (StringLen($expAddress) > 0)
		EndIf
		
		If $bHasAddress Then
			
			$bDupAddress = False

			Local $addressIndex = _ArraySearch($aExpAddresses, $expAddress)
			If $addressIndex = -1 Then
				;MsgBox(0, "adding address", ' ' & $expAddress)
				_ArrayInsert($aExpAddresses, 0, $expAddress)
			Else
				;MsgBox(0, "dup address", 'index = ' & $addressIndex & ' for ' & $expAddress)
				$bDupAddress = True
			EndIf

			If $bDupAddress Then

				;;;MsgBox(0, "closing window titled ", ' ' & $winTitle)

				WinClose($winHandle)
				$numWindowsClosed =$numWindowsClosed + 1
				
				_ArrayInsert($aClosedAddresses, 0, $expAddress)
			EndIf

		EndIf
	EndIf
Next

;_ArrayDisplay($aClosedAddresses, "$aClosedAddresses")

MsgBox(0, "Explorer windows were closed", $numWindowsClosed & " duplicate Explorer windows were closed.")

Func IsVisible($handle)
	If BitAnd( WinGetState($handle), 2 ) Then 
		Return 1
	Else
		Return 0
	EndIf
EndFunc
