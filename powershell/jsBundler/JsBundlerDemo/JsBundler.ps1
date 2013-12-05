# JsBundler
# =========
#
# Summary:
# --------
# Read a Web Essentials bundle file, and bundle up the given JavaScript or CSS files.
# Purpose: to run as part of a build, and make sure that all bundle output is up to date.
# This means developers in a team can simply check in the JavaScript or CSS files - they do not have to worry about merging bundle output files.

# Dependencies: 
# -------------
# Powershell 2 or higher

# Usage: 
# ------
# JsBundler.ps1 <bundle file> <path to basedir for the input files> [OPTIONS]

# ENSURE CORRECT EXIT CODE =================================================================
#
# PS has issue, where if a script is run with -file, then the exit code is ALWAYS 0.
#so we put in a trap to catch this:

trap
{
	write-output $_
	exit 1
}

#xxx for debugging
# $args = @("V:\sean\sourcecode\bitbucket\windowsscripts\powershell\jsBundler\JsBundlerDemo\JsBundlerDemo\Scripts\FibonaciBundle.js.bundle",
# "V:\sean\sourcecode\bitbucket\windowsscripts\powershell\jsBundler\JsBundlerDemo\JsBundlerDemo",
# "-b"
# )
#xxx

# ARGUMENTS =================================================================
$pathToBundleFile = $args[0]
$pathToBaseDir = $args[1]
$optionOne = $args[2]

$IsMinimising = $False
$IsBothMinimisingAndNot = $False

$IsGoodArgs = $False
if (($args.Count -eq 2 -or $args.Count -eq 3) -and $pathToBundleFile -ne '' -and $pathToBaseDir -ne '')
{
	$IsGoodArgs = $True
}

if ($optionOne)
{
	if ($optionOne -eq '-m')
	{
		$IsMinimising = $True
	}
	else
	{
        if($optionOne -eq '-b')
        {
            $IsBothMinimisingAndNot = $True
        }
        else
        {
		    $IsGoodArgs = $False
        }
	}
}

if (!$IsGoodArgs)
{
	Write-Host ("Incorrect arguments.") -foregroundcolor red
	Write-Host ("USAGE:")
	Write-Host ("JsBundler <bundle file> <path to basedir for the input files> [OPTIONS]")
	Write-Host ("OPTIONS:")
	Write-Host ("-b    read in and bundle Both minimised and unminimised files")
	Write-Host ("-m    read in and bundle Minimised files")
	Write-Output ""
	exit
}

$outputPath = $pathToBundleFile.ToString().ToLower().Replace('.bundle', '')

$isJavaScript = $False
$isCss = $False
$ext = ''
if($outputPath.Contains(".js"))
{
	$isJavaScript = $True
	$ext = ".js"
} 
else 
{
	if($outputPath.Contains(".css"))
	{
		$isCss = $True
		$ext = ".css"
	}
	else
	{
		throw "Only implemented for use with JavaScript or CSS bundles";
	}
}

# FUNCTION ============================================================
function GenerateBundleFile($outputPath, $ext, $IsMinimising)
{
	if($IsMinimising)
	{
		$outputPath = $outputPath.Replace($ext, '.min' + $ext)
	}

	# CONFIG SUMMARY ============================================================
	Write-Host "Bundling JavaScript from bundle file:"
	Write-Host $pathToBundleFile " -> " $outputPath

	if($IsMinimising)
	{
		Write-Host "Using minimised files"
	}
	else
	{
		Write-Host "NOT using minimised files"
	}

	# READ XML ==================================================================
	$srcPaths = New-Object Collections.Generic.List[String]

	[xml]$xml = Get-Content $pathToBundleFile;
	$nodes = Select-Xml "//bundle/file" $xml
	$nodes | ForEach-Object { $srcPaths.Add($pathToBaseDir + $_.Node.'#text'); }

	Write-Host 'Processing files...'
    
    #make sure our output file is NOT readonly:
    if (Test-Path($outputPath))
    {
        sp $outputPath IsReadOnly $false
    }

	#stream is the fastest way to write a file:
    #$fs = New-Object IO.FileStream $outputPath,'Write','Create'
    $stream = New-Object System.IO.StreamWriter($outputPath)
	$nowString = Get-Date
	$hostname = $env:computername
	$stream.WriteLine('/*bundled by JsBundler at ' + $nowString + ' on ' + $hostname + ' */')

	ForEach ($srcPath in $srcPaths)
	{ 
		if($IsMinimising)
		{
			$srcPath = $srcPath.Replace($ext, '.min' + $ext)
		}

		Write-Host $srcPath
		$text = Get-Content $srcPath

		$stream.WriteLine('/*' + $srcPath + '*/')

		foreach ($line in $text)
		{
			$stream.WriteLine($line)    
		}

		if($isJavaScript)
		{
			#add a ; to prevent syntax error in one file, propogating to the next:
			$stream.WriteLine(';')
		}
	}

	$stream.Flush();
	$stream.Close();
	$stream.Dispose();
    #$fs.Close();
    #$fs.Dispose();

	Write-Host 'Output has been written to file:'
	Write-Host $outputPath
}

# MAIN ============================================================
if($IsBothMinimisingAndNot)
{
    GenerateBundleFile $outputPath $ext $False
    GenerateBundleFile $outputPath $ext $True
}
else
{
    GenerateBundleFile $outputPath $ext $IsMinimising
}

Write-Host "[done]"
