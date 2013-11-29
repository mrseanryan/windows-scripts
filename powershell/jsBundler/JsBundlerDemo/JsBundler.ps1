# JsBundler
# =========
#
# Summary:
# --------
# Read a Web Essentials bundle file, and bundle up the given JavaScript files.
# Purpose: to run as part of a build, and make sure that all bundle output is up to date.
# This means developers in a team can simply check in the JavaScript files, they do not have to worry about merging bundle output files.

# Dependencies: 
# -------------
# Powershell 2 or higher

# Usage: 
# ------
# JsBundler.ps1 <bundle file> <path to basedir for the JavaScript files> [OPTIONS]

# ENSURE CORRECT EXIT CODE =================================================================
#
# PS has issue, where if a script is run with -file, then the exit code is ALWAYS 0.
#so we put in a trap to catch this:

trap
{
	write-output $_
	exit 1
}

# ARGUMENTS =================================================================
$pathToBundleFile = $args[0]
$pathToBaseDir = $args[1]
$optionOne = $args[2]

$IsMinimising = $False

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
		$IsGoodArgs = $False
	}
}

if (!$IsGoodArgs)
{
	Write-Host ("Incorrect arguments.") -foregroundcolor red
	Write-Host ("USAGE:")
	Write-Host ("JsBundler <bundle file> <path to basedir for the JavaScript files> [OPTIONS]")
	Write-Host ("OPTIONS:")
	Write-Host ("-m    use the Minimised JavaScript files")
	Write-Output "" 
	exit
}

$outputPath = $pathToBundleFile.ToString().ToLower().Replace('.bundle', '')

if(!$outputPath.Contains(".js"))
{
	throw "Only implemented for use with JavaScript bundles";
}

if($IsMinimising)
{
	$outputPath = $outputPath.Replace('.js', '.min.js')
}

# CONFIG SUMMARY ============================================================
Write-Host "Bundling JavaScript from bundle file:"
Write-Host $pathToBundleFile " -> " $outputPath

if($IsMinimising)
{
	Write-Host "Using minimised JavaScript files"
}
else
{
	Write-Host "NOT using minimised JavaScript files"
}

# READ XML ==================================================================
$srcPaths = New-Object Collections.Generic.List[String]

[xml]$xml = Get-Content $pathToBundleFile;
$nodes = Select-Xml "//bundle/file" $xml
$nodes | ForEach-Object { $srcPaths.Add($pathToBaseDir + $_.Node.'#text'); }

Write-Host 'Processing files...'
#stream is the fastest way to write a file:
$stream = [System.IO.StreamWriter] $outputPath
$nowString = Get-Date
$hostname = $env:computername
$stream.WriteLine('/*bundled by JsBundler at ' + $nowString + ' on ' + $hostname + ' */')

ForEach ($srcPath in $srcPaths)
{ 
	if($IsMinimising)
	{
		$srcPath = $srcPath.Replace('.js', '.min.js')
	}

	Write-Host $srcPath
	$text = Get-Content $srcPath

	$stream.WriteLine('/*' + $srcPath + '*/')

	foreach ($line in $text)
	{
		$stream.WriteLine($line)    
	}

	#add a ; to prevent syntax error in one file, propogating to the next:
	$stream.WriteLine(';')
}

$stream.Flush();
$stream.Close();
$stream = $null

Write-Host 'Output has been written to file:'
Write-Host $outputPath
