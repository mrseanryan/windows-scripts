
 #note: IE has only 1 window name, and this is the name of the last tab / window.
 get-process |where {$_.ProcessName -eq 'iexplore'} |format-table name,mainwindowtitle, Handles, WS, NPM, PM, VM, Id, ProcessName  –AutoSize


 get-process |where {$_.ProcessName -eq 'iexplore'}

