<#

    ref: http://4sysops.com/wp-content/uploads/2012/03/Get-DiskSpaceDetails.ps1

    .Synopsis 
        Get the disk space details of remote computer.
        
    .Description
        This script helps you to get the disk space details of local disks and removable disks of 
		remote computer using powershell. It will also get the space details of mount points.
 
    .Parameter ComputerName    
        Computer name(s) for which you want to get the disk space details.
        
    .Example
        Get-DiskSpaceDetails.ps1 -ComputerName Comp1, Comp2
		
		Get the total disk space, free disk space, and percentage disk free space details of computers listed.
               
    .Example
        Get-DiskSpaceDetails.ps1 -ComputerName Comp1 | ? {$_."`%Freespace `(GB`)" -lt 5}
        
        Get all the drives which are having less than 5% free space.
        
    .Notes
        NAME:      Get-DiskSpaceDetails.ps1
        AUTHOR:    Sitaram Pamarthi
		WEBSITE:   http://techibee.com

#>

[cmdletbinding()]
param(
	[parameter(ValueFromPipeline=$true,ValueFromPipelineByPropertyName=$true)]
	[string[]]$ComputerName = $env:computername
	
)

begin {
	
}

process {
	foreach($Computer in $ComputerName) {
		Write-Verbose "Working on $Computer"
		if(Test-Connection -ComputerName $Computer -Count 1 -ea 0) {
			$VolumesInfo = Get-WmiObject -ComputerName $Computer -Class Win32_Volume | ? {$_.DriveType -eq 2 -or $_.DriveType -eq 3 }
			foreach($Volume in $VolumesInfo) {
				
				$Capacity 	= [System.Math]::Round(($Volume.Capacity/1GB),2)
				$FreeSpace	= [System.Math]::Round(($Volume.FreeSpace/1GB),2)
                
                
				$PctFreeSpace	= 0
                
                #avoid div/0 error for empty removable drive:
                if ($Volume.Capacity -gt 0)
                {
                    $PctFreeSpace	= [System.Math]::Round(($Volume.FreeSpace/$Volume.Capacity)*100,2)
                }
                
				$OutputObj	= New-Object -TypeName PSobject 
				$OutputObj | Add-Member -MemberType NoteProperty -Name ComputerName -Value $Computer
				$OutputObj | Add-Member -MemberType NoteProperty -Name DriveName -Value $Volume.Caption
				$OutputObj | Add-Member -MemberType NoteProperty -Name DriveType -Value $Volume.DriveType
				$OutputObj | Add-Member -MemberType NoteProperty -Name "Capacity `(GB`)" -Value $Capacity
				$OutputObj | Add-Member -MemberType NoteProperty -Name "FreeSpace `(GB`)" -Value $FreeSpace
				$OutputObj | Add-Member -MemberType NoteProperty -Name "`%FreeSpace `(GB`)" -Value $PctFreeSpace
				$OutputObj# | Select ComputerName, DriveName, DriveType, Capacity, FreeSpace, PctFreespace | ft -auto
			}
		} else {
			Write-Verbose "$Computer is not reachable"
		}
	}
}

end {
}

