  #figure out the path to our helper script:
    $scriptpath = $MyInvocation.MyCommand.Path
    $dir = Split-Path $scriptpath


    $pathToGetDetails = $dir + "\checkDiskFreeSpace.ps1"

#no email on OdinDev + no PS on COMREG-INFO :-(

# & $pathToGetDetails	-ComputerName ling-build -DriveNames C:\  -emailEnabled no

& $pathToGetDetails	-ComputerName sryan-win7 -DriveNames C:\, B:\, Z:\  -emailEnabled no
