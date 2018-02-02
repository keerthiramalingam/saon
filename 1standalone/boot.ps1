param (
    [string]$pp_region = "region not passed",
    [string]$pp_environment = "env  not passed",
    [string]$pp_role = "role not passed",
    [string]$sqlins = ""
 )

$tstfolder = C:\tst

$sqlins = "https://raw.githubusercontent.com/keerthiramalingam/saon/master/1standalone/custom.ps1"
New-Item -ItemType directory -Path $tstfolder

Add-Content C:\tst\output.txt "$(Get-Date) $pp_region XXXXX $pp_environment XXXXX $pp_role and $vmss"

$onlyScriptURI = $sqlins.Split(" ")[0]
$onlyFileName = $onlyScriptURI.Split("\/")[-1]
$localScriptLocation = "C:\tst\" + $onlyFileName

Invoke-WebRequest -Uri $onlyScriptURI -OutFile $localScriptLocation
Invoke-Expression $localScriptLocation