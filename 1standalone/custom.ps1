# uninstall
C:\SQLServer_13.0_Full\setup.exe /ACTION="Uninstall" /SUPPRESSPRIVACYSTATEMENTNOTICE="False" /QUIET="True" /FEATURES=SQLENGINE,REPLICATION,ADVANCEDANALYTICS,FULLTEXT,DQ,AS,RS,DQC,CONN,IS,BC,SDK,BOL,MDS,BROWSER,WRITER /INSTANCENAME="MSSQLSERVER"

AddStampT F 2 Bin

AddStampT G 3 Data
AddStampT H 4 Logs
AddStampT P 5

function AddStampT()

{    
Param($driveLetter,$driveNumber, $driveName)


$disk = Get-Disk -Number $driveNumber

            
        if ($disk.IsOffline -eq $true)
        {
            Write-Host 'Setting disk Online'
            $disk | Set-Disk -IsOffline $false
        }
        else
        {
            Write-Host 'Disk is Online' $driveLetter, $driveNumber, $driveName 
        }


        if ($disk.IsReadOnly -eq $true)
        {
            Write-Verbose 'Setting disk to not ReadOnly'
            $disk | Set-Disk -IsReadOnly $false
        }
        else
        {
            Write-Verbose 'Setting is not ReadOnly'
        }

        $diskNumber = $disk.Number

        if ($disk.PartitionStyle -eq "RAW")
        {
            
            Write-Host "Initializing disk number '$($DiskNumber)' for drive letter '$($driveLetter)' ... "

            $disk | Initialize-Disk -PartitionStyle GPT -PassThru
                
            $partition = $disk | New-Partition -DriveLetter $driveLetter -UseMaximumSize

            # Sometimes the disk will still be read-only after the call to New-Partition returns.
            Start-Sleep -Seconds 20

            $partition | Format-Volume -FileSystem NTFS -Confirm -Force -NewFileSystemLabel $driveName

            Write-Host "Successfully initialized disk number '$($DiskNumber)'. to '$($driveLetter)' "

            return $true
        }
}
