param (
    [string]$pp_region = "region not passed",
    [string]$pp_environment = "env  not passed",
    [string]$pp_role = "role not passed",
    [string]$sqlins = ""
 )
########################################################
$DNSSuffix = "keerthi.io"

$tstfolder = 'C:\tst'
New-Item -ItemType directory -Path $tstfolder
Add-Content C:\tst\output.txt "$(Get-Date) "
Start-Sleep -Seconds 301

tzutil /s "GMT Standard Time"

# Update primary DNS Suffix for FQDN
#Set-ItemProperty "HKLM:\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\" -Name Domain -Value $DNSSuffix
#Set-ItemProperty "HKLM:\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\" -Name "NV Domain" -Value $DNSSuffix

$networkConfig = Get-WmiObject Win32_NetworkAdapterConfiguration -filter "ipenabled = 'true'"
$networkConfig.SetDnsDomain($DNSSuffix)
$networkConfig.SetDynamicDNSRegistration($true,$true)
ipconfig /RegisterDns
Start-Sleep -Seconds 30
Add-Content C:\tst\output.txt "$(Get-Date) DNS registered "
# Install software so we can update AD DNSHostname attribute
Add-WindowsFeature RSAT-AD-PowerShell

# Update AD DNS Name
$ad_username = "adadmin@keerthi.io"
$ad_password = "Password-12345"
$secureStringPwd = ($ad_password | ConvertTo-SecureString -AsPlainText -Force)
$creds = (New-Object System.Management.Automation.PSCredential -ArgumentList $ad_username, $secureStringPwd)
$ad_command = (Set-ADComputer -Identity $computerName -DNSHostName "$computerName.$DNSSuffix" -Credential $creds)
$ad_command

Add-Content C:\tst\output.txt "$(Get-Date) added to domain"
 ########################################################



$sqlins = "https://raw.githubusercontent.com/keerthiramalingam/saon/master/1standalone/custom.ps1"


Add-Content C:\tst\output.txt "$(Get-Date) $pp_region XXXXX $pp_environment XXXXX $pp_role and $sqlins"

$onlyScriptURI = $sqlins.Split(" ")[0]
$onlyFileName = $onlyScriptURI.Split("\/")[-1]
$localScriptLocation = $tstfolder + '\' + $onlyFileName

Invoke-WebRequest -Uri $onlyScriptURI -OutFile $localScriptLocation
Invoke-Expression $localScriptLocation