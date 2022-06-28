$DiskLabel = 'AuditLogFiles'
$Global:value = $true
$Raw_disks = Get-Disk | Where-Object {$_.PartitionStyle -ieq 'RAW' }
Set-Disk -UniqueId $Raw_disks.UniqueId -IsOffline $false -ErrorAction Stop
Initialize-Disk -UniqueId $Raw_disks.UniqueId -PartitionStyle 'GPT' -ErrorAction Stop
$partition = New-Partition -DiskId $Raw_disks.UniqueId -AssignDriveLetter -UseMaximumSize -ErrorAction Stop
Start-Sleep 10
if($partition)
{
write-host "New Partition completed for the disk"
Format-Volume -Partition $partition -FileSystem NTFS -NewFileSystemLabel $DiskLabel -Confirm:$false -ErrorAction Stop | Out-Null
write-host "Format completed for the disk `"$($Raw_disks.UniqueId)`" - Drive `"$($partition.DriveLetter)`""
$disk = Get-Disk | Where-Object { $_.UniqueId -ieq $Raw_disks.UniqueId }
write-host "Hostname - ${env:COMPUTERNAME}"
write-host "New Drive Letter - $($partition.DriveLetter)"
$DiskGB = ($disk.Size / 1gb).ToString('0.00')
write-host "Disk Size in GB - $DiskGB"
#write-host "Disk Size in Bytes - $($disk.Size)"
write-host "DiskId - $($disk.UniqueId)"
write-host "Health Status - $($disk.HealthStatus)"
}
else{
write-host "Failed to partition Drive"
$Global:value = $false
}
if($Global:value -eq $true){
$Driveletter = "$($partition.DriveLetter)"
$Path = $Driveletter+":\Windows\System32\Winevt\Logs" 
New-Item -Path $Path -ItemType Directory -Force | out-null
Limit-EventLog -LogName Security -MaximumSize 57671680
$SecurityPath = Join-Path -Path $Path -ChildPath "\Security.evtx"
Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\EventLog\Security" -Name "File" -Value $SecurityPath

write-host "validaion"
$Val = (get-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\EventLog\Security").file
write-host $env:COMPUTERNAME - "$Val"
write-host "**************************************************************"
}