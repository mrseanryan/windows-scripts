#include-once

; ref - http://www.autoitscript.com/forum/topic/89833-windows-explorer-current-folder/

; ==================================================================================================
; <_GetWindowsExplorerPath.au3>
;
; Functions:
;   _GetWindowsExplorerPath()
;   _GetWindowsExplorerPaths()
;
; Author: WideBoyDixon
; ==================================================================================================

; ==================================================================================================
; Func _GetWindowsExplorerPath($hWnd)
;
; Function to get the path currently being explored by a Windows Explorer window
;
; $hWnd = Handle to the Windows Explorer window
;
; Returns:
;   Success: String - Path being explored by this window
;   Failure: "" empty string, with @error set:
;      @error = 1 = This is not a valid explorer window
;      @error = 2 = DLL call error, use _WinAPI_GetLastError()
;
; Author: WideBoyDixon
; ==================================================================================================
Func _GetWindowsExplorerPath($hWnd)
    Local $pv, $pidl, $return = "", $ret, $hMem, $pid, $folderPath = DllStructCreate("char[260]"), $className
    Local $bPIDL = False
    Local Const $CWM_GETPATH = 0x400 + 12;

    ; Check the classname of the window first
    $className = DllCall("user32.dll", "int", "GetClassName", "hwnd", $hWnd, "str", "", "int", 4096)
    If @error Then Return SetError(2, 0, "")
    If ($className[2] <> "ExploreWClass" And $className[2] <> "CabinetWClass") Then Return SetError(1, 0, "")
    
    ; Retrieve the process ID for our process
    $pid = DllCall("kernel32.dll", "int", "GetCurrentProcessId")
    If @error Then Return SetError(2, 0, "")

    ; Send the CWM_GETPATH message to the window
    $hMem = DllCall("user32.dll", "lparam", "SendMessage", "hwnd", $hWnd, "int", $CWM_GETPATH, "wparam", $pid[0], "lparam", 0) 
    If @error Then Return SetError(2, 0, "")
    If $hMem[0] = 0 Then Return SetError(1, 0, "")
    
    ; Lock the shared memory
    $pv = DllCall("shell32.dll", "ptr", "SHLockShared", "uint", $hMem[0], "uint", $pid[0])
    If @error Then Return SetError(2, 0, "")
    If $pv[0] Then
        $pidl = DllCall("shell32.dll", "ptr", "ILClone", "uint", $pv[0]) ; Clone the PIDL
        If @error Then Return SetError(2, 0, "")
        $bPIDL = True
        DllCall("shell32.dll", "int", "SHUnlockShared", "uint", $pv) ; Unlock the shared memory
    EndIf
    DllCall("shell32.dll", "int", "SHFreeShared", "uint", $hMem, "uint", $pid) ; Free the shared memory
    
    If $bPIDL Then
        ; Retrieve the path from the PIDL
        $ret = DllCall("shell32.dll", "int", "SHGetPathFromIDList", "ptr", $pidl[0], "ptr", DllStructGetPtr($folderPath))
        If (@error = 0) And ($ret[0] <> 0) Then $return = DllStructGetData($folderPath, 1) ; Retrieve the value
        DllCall("shell32.dll", "none", "ILFree", "ptr", $pidl[0]) ; Free up the PIDL that we cloned
        Return SetError(0, 0, $return) ; Success
    EndIf
    
    Return SetError(2, 0, "") ; Failed a WinAPI call
EndFunc

; ==================================================================================================
; Func _GetWindowsExplorerPaths()
;
; Function to get a list of all paths currently being explored by a Windows Explorer window
;
; Returns:
;   Array
;       [0][0] - Number of items in the Array
;       [$i][0] - Window handle of the explorer window
;       [$i][1] - Folder being explored by this window
;
; Author: WideBoyDixon
; ==================================================================================================
Func _GetWindowsExplorerPaths()
    Local $nCount = 0 ; The number of explorer windows we found
    Local $aPaths[1][2] ; Our return array
    Local $aWindows = WinList() ; Look at all the windows we can find
    Local $nI, $folderPath ; Loop variable and folder path string

    ; Loop through all windows
    For $nI = 1 To $aWindows[0][0]
        ; Try to get the folder path for this window
        $folderPath = _GetWindowsExplorerPath($aWindows[$nI][1])
        If @error = 0 Then
            ; Found the path ... store it
            $nCount += 1 ; Increment the number of windows we've found
            ReDim $aPaths[$nCount + 1][2] ; Make room for this one in the array
            $aPaths[$nCount][0] = $aWindows[$nI][1] ; Store the window handle
            $aPaths[$nCount][1] = $folderPath ; Store the path that's being explored
            $aPaths[0][0] = $nCount ; Update the number of items in the array
        EndIf
    Next

    Return $aPaths
EndFunc