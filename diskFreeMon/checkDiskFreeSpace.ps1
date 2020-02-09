<#
checkDiskFreeSpace.ps1

Script which checks the given list of drives on the given computer.
If one or more of the given drives are running out of space,
then it sends a warning email.

USAGE: checkDiskFreeSpace.ps1 -ComputerName <hostname> -DriveNames <drive names> -emailEnabled <yes/no>

EXAMPLE: checkDiskFreeSpace.ps1 -ComputerName myHostName -DriveNames C:\ D:\ -emailEnabled yes

DEPENDENCIES: Powershell 2
              an SMPT server (if -emailEnabled yes)
#>

[cmdletbinding()]
param(
	[parameter(ValueFromPipeline=$true,ValueFromPipelineByPropertyName=$true)]
	[string]$ComputerName = $env:computername,
	[string[]]$DriveNames = $env:drives,
    [string]$emailEnabled = $env:emailEnabled
)

begin {
	
}

process {

    if(!$ComputerName -or !$DriveNames -or !$emailEnabled)
    {
        write-host "USAGE: checkDiskFreeSpace.ps1 -ComputerName <hostname> -DriveNames <drive names> -emailEnabled <yes/no>"
        write-host ""
        write-host "EXAMPLE: checkDiskFreeSpace.ps1 -ComputerName myHostName -DriveNames C:\ D:\ -emailEnabled yes"

        exit 1
    }

    if($emailEnabled -eq "yes")
    {
        $emailEnabled = $true
    }
    else
    {
        $emailEnabled = ""
    }

    #figure out the path to our helper script:
    $scriptpath = $MyInvocation.MyCommand.Path
    $dir = Split-Path $scriptpath

    #$pathToGetDetails = Resolve-Path "Get-DiskSpaceDetails.ps1"

    $pathToGetDetails = $dir + "\Get-DiskSpaceDetails.ps1"


    #$driveNames = "D:\", "F:\"

    #$computerName = "DELL-8100"

    $minSpacePC = 5

    write-host "Examing the drives " $driveNames "on computer" $computerName " for free space less than " $minSpacePC "%"

    $resultForComputer = & $pathToGetDetails  -ComputerName $computerName | ? {$_."`%Freespace `(GB`)" -lt $minSpacePC -and $_."`Capacity `(GB`)" -gt 0 -and $driveNames -contains $_."`DriveName" }

    if($resultForComputer)
    {
        $warningMsg = "!!!WARNING - disk space is low: " + $resultForComputer
        write-host $warningMsg
        
        if($emailEnabled)
        {
            #send an email:
            $emailFrom = "LING_automation@comreg.ie"
            $emailTo = "database@odin.ie"
            $subject = "disk space low warning - computer " + $computerName
            $body = $warningMsg
            $smtpServer = "ccr-ex07-01"
            $smtp = new-object Net.Mail.SmtpClient($smtpServer)
            $smtp.Send($emailFrom, $emailTo, $subject, $body)
        }
		else
		{
			write-host "no email - showing warning notification ..."
			
			#at least show a warning message:
			[void] [System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms")

			$objNotifyIcon = New-Object System.Windows.Forms.NotifyIcon 

			$objNotifyIcon.Icon = $dir + "\LING.ico"
			$objNotifyIcon.BalloonTipIcon = "Warning" 
			$objNotifyIcon.BalloonTipText = $warningMsg
			$objNotifyIcon.BalloonTipTitle = "Disk space low on " + $computerName
			 
			$objNotifyIcon.Visible = $True 

			$waitTime = 30 * 1000 #in millis

			$objNotifyIcon.ShowBalloonTip($waitTime)

			#need to dispose of the icon, as otherwise it hangs around waiting for user input:
			[System.Threading.Thread]::Sleep($waitTime)
			$objNotifyIcon.Dispose()
		}
    }
    else
    {
        write-host "[ok]"
    }

}

end {
}

