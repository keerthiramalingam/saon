function AddDrive()
{    
Param($driveLetter,$driveNumber, $driveName)
$disk = Get-Disk -Number $driveNumber

            
        if ($disk.IsOffline -eq $true)
        {
            
            $disk | Set-Disk -IsOffline $false
        }
        else
        {
            Add-Content C:\tst\output.txt "$(Get-Date) already online for $driveLetter, $driveNumber, $driveName "   
        }


        if ($disk.IsReadOnly -eq $true)
        {
            Add-Content C:\tst\output.txt "$(Get-Date) Setting disk to not ReadOnly "
            $disk | Set-Disk -IsReadOnly $false
        }
        else
        {
            Add-Content C:\tst\output.txt "$(Get-Date) Setting is not ReadOnly "
        }

        $diskNumber = $disk.Number

        if ($disk.PartitionStyle -eq "RAW")
        {
            
            Add-Content C:\tst\output.txt "$(Get-Date) Initializing disk number '$($DiskNumber)' for drive letter '$($driveLetter)' ... "

            $disk | Initialize-Disk -PartitionStyle GPT -PassThru
                
            $partition = $disk | New-Partition -DriveLetter $driveLetter -UseMaximumSize

            # Sometimes the disk will still be read-only after the call to New-Partition returns.
            Start-Sleep -Seconds 10

            $confirmpreference = 'none'

            $partition | Format-Volume -FileSystem NTFS -Confirm:$false -Force -NewFileSystemLabel $driveName

            Add-Content C:\tst\output.txt "$(Get-Date) Successfully initialized disk number '$($DiskNumber)'. to '$($driveLetter)' "
        

            return $true
        }
}

# uninstall
$installFile = "https://raw.githubusercontent.com/keerthiramalingam/saon/master/1standalone/install-sql.ini"
$uninstallFile = "https://raw.githubusercontent.com/keerthiramalingam/saon/master/1standalone/uninstall-sql.ini"
$tstfolder = 'C:\tst'

Invoke-WebRequest -Uri $installFile -OutFile $tstfolder\Install.ini
Invoke-WebRequest -Uri $uninstallFile -OutFile $tstfolder\Uninstall.ini

C:\SQLServer_13.0_Full\setup.exe /CONFIGURATIONFILE=$tstfolder\Uninstall.ini


AddDrive F 2 Bin
Add-Content C:\tst\output.txt "$(Get-Date) added F drive"

AddDrive G 3 Datas
Add-Content C:\tst\output.txt "$(Get-Date) added G drive "

AddDrive H 4 Logs
Add-Content C:\tst\output.txt "$(Get-Date) added H drive "

AddDrive P 5
Add-Content C:\tst\output.txt "$(Get-Date) added P drive "





New-Item -ItemType directory -Path F:\$env:computername

Add-Content C:\tst\output.txt "$(Get-Date) Created F drive folder"

(Get-Content $tstfolder\Install.ini).replace('computername', $env:computername) | Set-Content $tstfolder\Install.ini

Add-Content C:\tst\output.txt "$(Get-Date) updated Install.ini"

# enable below code after getting sevice account tot work
#(Get-Content $tstfolder\Install.ini).replace('svcact', $sqlsvcdomainsct) | Set-Content $tstfolder\Install.ini

C:\SQLServer_13.0_Full\setup.exe /CONFIGURATIONFILE=$tstfolder\Install.ini

Add-Content C:\tst\output.txt "$(Get-Date) SQL installed"