; script to keep an RDP session alive, by periodically sending a LEFT ARROW key message.
;
;dependencies: AutoIt3
;
; tested on :
; Windows 7 Home 

#include <Array.au3>

run("c:\windows\notepad.exe");
Sleep(500)
SEND("AutoIt script is running, to keep sending LEFT ARROW key presses.  To stop, please kill the AutoIt process.");


While 1
    Sleep(1000)
	SEND("{LEFT}");
WEnd

