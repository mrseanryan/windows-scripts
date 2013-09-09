#watch a directory, for changes to TypeScript files.
#
#when a file changes, then re-compile it.


$watcher = New-Object System.IO.FileSystemWatcher
#$watcher.Path = "V:\temp"
$watcher.Path = "V:\tfs12.II_SPOC\Wells\SPOC\SPOC Development\Source\Spoc.HMI\Spoc.HMI.Web\Scripts\TS"
$watcher.IncludeSubdirectories = $true
$watcher.EnableRaisingEvents = $true

$changed = Register-ObjectEvent $watcher "Changed" -Action {
    
    if ($($eventArgs.FullPath).EndsWith(".ts"))
    {
        $command = '"c:\Program Files (x86)\Microsoft SDKs\TypeScript\tsc.exe" "$($eventArgs.FullPath)"'

        write-host '>>> Recompiling file ' $($eventArgs.FullPath)

        iex "& $command"
    }
}

write-host 'changed.Id:' $changed.Id

# Unregister-Event $changed.Id
