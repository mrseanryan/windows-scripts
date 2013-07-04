; script to track the mouse position + colour
;
; ref: http://www.autoitscript.com/forum/topic/136611-small-mouse-tooltip-utility-for-developers/?fromsearch=1

#include <WindowsConstants.au3>
#include <GUIConstantsEx.au3>
#include <GDIPlus.au3>
#include <WinApI.au3>
#include <ScreenCapture.au3>
#NoTrayIcon
$collor=1
$a=10
$b=20
$d=105
$e=50
$setupGui = GUICreate("", 100, 160, 2, 2, $ws_popup,$ws_ex_topmost)
$cr=GUICtrlCreateRadio("color Gui",5,5)
$zr=GUICtrlCreateRadio("zoom Gui",5,25)
$nr=GUICtrlCreateRadio("no Gui",5,45)
GUICtrlSetState(-1,1)
$hc=GUICtrlCreateCheckbox("hex Color",5,65)
$nc=GUICtrlCreateCheckbox("no Color",5,85)
$tt=GUICtrlCreateCheckbox("Tool Tip",5,105)
$button=GUICtrlCreateButton("exit",5,130,90,20)
$colorGui = GUICreate("", 200, 200, 200, 200, BitAND($ws_popup,$ws_border),$ws_ex_topmost)
$cl=GUICtrlCreateLabel("",10,10,100,25)
   GUICtrlSetBkColor($cl,0x000000)
   GUICtrlSetFont($cl,14)
   GUICtrlSetColor($cl,0xffffff)
_GDIPlus_Startup()
While 1
Sleep(1)
$p=MouseGetPos()
$c=PixelGetColor($p[0],$p[1])
$hex=String("0x" & hex($c,6))
if GUICtrlRead($tt)=$GUI_CHECKED Then
if $p[0]>=@DesktopWidth-$d-$a and $p[1]<@DesktopHeight-$e-$b then Tipex(@DesktopWidth-$d,$p[1]+$b)
if $p[0]<@DesktopWidth-$d-$a and $p[1]<@DesktopHeight-$e-$b then Tipex($p[0]+$a,$p[1]+$b)
if $p[0]<@DesktopWidth-$d-$a and $p[1]>=@DesktopHeight-$e-$b then Tipex($p[0]+$a,@DesktopHeight-$e)
if $p[0]>=@DesktopWidth-$d-$a and $p[1]>=@DesktopHeight-$e-$b then Tipex(@DesktopWidth-$d,@DesktopHeight-$e-$b-30)
EndIf
if $p[0]=0 And $p[1]=0 then
GUISetState(@SW_SHOW,$setupGui)
While 1
  $p=MouseGetPos()
  if $p[0]>200 Then ExitLoop
  if $p[1]>200 Then ExitLoop
  Tipex($p[0]+$a,$p[1]+$b,1)
  if GUIGetMsg()=$button then Exit
WEnd
$tool=ToolTip("")
GUISetState(@SW_HIDE,$setupGui)
Else
EndIf
if GUICtrlRead($nr)=$GUI_CHECKED then
GUISetState(@SW_HIDE,$colorGui)
Else
if GUICtrlRead($zr)=$GUI_CHECKED Then
  GUISetState(@SW_SHOW,$colorGui)
  $scr = _ScreenCapture_Capture("")
  $secscr = _GDIPlus_BitmapCreateFromHBITMAP($scr)
  $palete = _GDIPlus_GraphicsCreateFromHWND($colorGui)
  _GDIPlus_GraphicsDrawImageRectRect($palete, $secscr,$p[0]-50, $p[1]-50, 100, 100, 0, 0, 200, 200)
  _GDIPlus_GraphicsDispose($palete)
  _GDIPlus_ImageDispose($secscr)
  _WinAPI_DeleteObject($scr)
EndIf
If GUICtrlRead($cr)=$GUI_CHECKED Then
   If GUICtrlRead($hc)=$GUI_CHECKED then
    If $hex<>$collor Then
     GUISetBkColor($hex,$colorGui)
     GUICtrlSetData($cl,$hex)
     $collor=$hex
    EndIf
   Else
    If $hex<>$collor Then
     GUISetBkColor($hex,$colorGui)
     GUICtrlSetData($cl,$c)
     $collor=$hex
    EndIf
   EndIf
  GUISetState(@SW_SHOW,$colorGui)
EndIf
EndIf
WEnd
_GDIPlus_Shutdown()
Func tipex($x,$y,$var=0)
if $var=0 Then
If GUICtrlRead($nc)=$GUI_CHECKED Then
  $tool=ToolTip($p[0] & "," & $p[1], $x,$y)
Else
  if GUICtrlRead($hc)=$GUI_CHECKED then
   $tool=ToolTip($p[0] & "," & $p[1] & "--" & $hex , $x,$y)
  Else
   $tool=ToolTip($p[0] & "," & $p[1] & "--" & $c , $x,$y)
  EndIf
EndIf
EndIf
if $var=1 then $tool=ToolTip("Setup", $x,$y)
EndFunc
Func quit()
Exit
EndFunc