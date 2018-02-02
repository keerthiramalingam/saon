# uninstall
$installFile = "https://raw.githubusercontent.com/keerthiramalingam/saon/master/1standalone/install-sql.ini"
$uninstallFile = "https://raw.githubusercontent.com/keerthiramalingam/saon/master/1standalone/uninstall-sql.ini"
$tstfolder = 'C:\tst'

Invoke-WebRequest -Uri $installFile -OutFile $tstfolder\Install.ini
Invoke-WebRequest -Uri $uninstallFile -OutFile $tstfolder\Uninstall.ini

C:\SQLServer_13.0_Full\setup.exe /CONFIGURATIONFILE=$tstfolder\Uninstall.ini

AddDrive F 2 Bin
AddTimeStamp 'added F drive'

AddDrive G 3 Data
AddTimeStamp 'added G drive'

AddDrive H 4 Logs
AddTimeStamp 'added H drive'

AddDrive P 5
AddTimeStamp 'added P drive'

function AddDrive()
    {    
Param($driveLetter,$driveNumber, $driveName)
$disk = Get-Disk -Number $driveNumber

            
        if ($disk.IsOffline -eq $true)
        {
            AddTimeStamp 'added P drive'
            $disk | Set-Disk -IsOffline $false
        }
        else
        {
            AddTimeStamp "already online for $driveLetter, $driveNumber, $driveName "   
        }


        if ($disk.IsReadOnly -eq $true)
        {
            AddTimeStamp 'Setting disk to not ReadOnly'
            $disk | Set-Disk -IsReadOnly $false
        }
        else
        {
            AddTimeStamp 'Setting is not ReadOnly'
        }

        $diskNumber = $disk.Number

        if ($disk.PartitionStyle -eq "RAW")
        {
            
            AddTimeStamp "Initializing disk number '$($DiskNumber)' for drive letter '$($driveLetter)' ... "

            $disk | Initialize-Disk -PartitionStyle GPT -PassThru
                
            $partition = $disk | New-Partition -DriveLetter $driveLetter -UseMaximumSize

            # Sometimes the disk will still be read-only after the call to New-Partition returns.
            Start-Sleep -Seconds 10

            $confirmpreference = 'none'

            $partition | Format-Volume -FileSystem NTFS -Confirm:$false -Force -NewFileSystemLabel $driveName

            AddTimeStamp "Successfully initialized disk number '$($DiskNumber)'. to '$($driveLetter)' "
            Start-Sleep -Seconds 20            

            return $true
        }
}

C:\SQLServer_13.0_Full\setup.exe /CONFIGURATIONFILE=$tstfolder\Uninstall.ini

function AddTimeStamp([string]$sr)
{    
    Add-Content C:\tst\output.txt "$(Get-Date) $sr"
}
