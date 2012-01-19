; script to find all explorer windows with duplicate title, and close them
;
; this script just looks at the title of the Window, which might NOT be the full address
;
;dependencies: AutoIt3
;
; tested on Windows 7 Home

#include <Array.au3>

Local $aExplorerTitles[1]


$var = WinList()
For $i = 1 to $var[0][0]
	; Only consider visble windows that have a title
	$winTitle = $var[$i][0]
	If $winTitle <> "" AND IsVisible($var[$i][1]) Then
	
		; MsgBox(0, "Details", "Title=" & $winTitle & @LF & "Handle=" & $var[$i][1])

		Local $iIndex = _ArraySearch($aExplorerTitles, $winTitle, 0, 0, 0, 1)
		If @error Then
			MsgBox(0, "Not Found", '"' & $winTitle & '" was not found in the array.')
			; _ArrayDisplay($aExplorerTitles, "$aExplorerTitles BEFORE _ArrayInsert()")
			_ArrayInsert($aExplorerTitles, 0, $winTitle)
			; _ArrayDisplay($aExplorerTitles, "$aExplorerTitles BEFORE _ArrayInsert()")
		Else
			MsgBox(0, "Found", '"' & $winTitle & '" was found in the array at position ' & $iIndex & " - will try to close it if its Explorer.")
			WinClose("[Title:" & $winTitle & "; CLASS:CabinetWClass]")
		EndIf

	EndIf
Next

Func IsVisible($handle)
	If BitAnd( WinGetState($handle), 2 ) Then 
		Return 1
	Else
		Return 0
	EndIf
EndFunc
