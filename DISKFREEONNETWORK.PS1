Get-WMIObject Win32_LogicalDisk -computer (Get-Content c:\temp\computers.txt) | Select SystemName,DeviceID,VolumeName,@{Name="size(GB)";Expression={"{0:N1}" -f($_.size/1gb)}},@{Name=”freespace(GB)”;Expression={“{0:N1}” -f($_.freespace/1gb)}} | Out-GridView
#'//-filter "DriveType=3" 

Write-Host "Press any key to continue ..."

#$k = $host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
$k = $host.UI.RawUI.ReadKey()
