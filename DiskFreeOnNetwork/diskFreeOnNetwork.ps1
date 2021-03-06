Get-WMIObject Win32_LogicalDisk -filter "DriveType=3" -computer (Get-Content c:\temp\computers.txt) | Select SystemName,DeviceID,VolumeName,@{Name="size(GB)";Expression={"{0:N1}" -f($_.size/1gb)}},@{Name=”freespace(GB)”;Expression={“{0:N1}” -f($_.freespace/1gb)}} | Out-GridView

Write-Host "Press any key to continue ..."

$k = $host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
