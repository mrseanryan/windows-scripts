' Process Killer script


' ------ SCRIPT CONFIGURATION ------
strComputer = "." ' Can be a hostname or "." to target local host

Dim processNameList(1)

processNameList(0)  = "notepad.exe"

' ------ END CONFIGURATION ---------

Function killProcesses()

   set objWMI = GetObject("winmgmts:\\" & strComputer & "\root\cimv2")
   set colProcesses = objWMI.InstancesOf("Win32_Process")

   bwac_processNameList = 0

   On Error Resume Next

' Kill mode manager first, as it will try to retstrat bwac processes 

   for each objProcess In colProcesses

     if InStr(objProcess.Name, "BWC_Mode") Then
         WScript.Echo "Killing " & objProcess.Name & " pid: " & objProcess.ProcessID
         objProcess.Terminate()
         bwac_processNameList = 1
     End If
   next

' Kill the rest of them

   for each objProcess In colProcesses

     if InStr(objProcess.Name, "BWC_") Then
         WScript.Echo "Killing " & objProcess.Name & " pid: " & objProcess.ProcessID
         objProcess.Terminate()
         bwac_processNameList = 1
     Else

        if InStr(objProcess.Name, "CR2") Then
           WScript.Echo "Killing " & objProcess.Name & " pid: " & objProcess.ProcessID
           objProcess.Terminate()
           bwac_processNameList = 1
        Else

          if InStr(objProcess.Name, "XFS3") Then
             WScript.Echo "Killing " & objProcess.Name & " pid: " & objProcess.ProcessID
             objProcess.Terminate()
             bwac_processNameList = 1
          Else

             For Each bwacProc in processNameList
                if StrComp (objProcess.Name, bwacProc, vbTextCompare) = 0 Then
                  WScript.Echo "Killing " & objProcess.Name & " pid: " & objProcess.ProcessID
                  objProcess.Terminate()         
                  bwac_processNameList = 1
                  Exit For
                End If
             Next
      
          End If
        End If
      End If
      
   next

   killProcesses = bwac_processNameList
End Function

' header

WScript.Echo "********************************************************************"
WScript.Echo "*          process killer utility  ver 2.0                    *"
WScript.Echo "********************************************************************"

WScript.Echo "INFO: Looking for processes to kill ..."

On Error Resume Next

continue = 1

Do Until continue = 0

   continue = killProcesses()

   if continue = 1 Then
      
      Sleep (5)
   End If
  
Loop

WScript.Echo "INFO: No more processes found ..."
