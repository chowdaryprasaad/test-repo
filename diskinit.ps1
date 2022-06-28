

Get-Disk | Where-Object {$_.partitionstyle -eq ‘raw’} | Initialize-Disk -PartitionStyle MBR -PassThru 
| New-Partition -AssignDriveLetter -UseMaximumSize | Format-Volume -FileSystem NTFS -NewFileSystemLabel “AuditLogFiles” -Confirm:$false


$Drive = (Get-WmiObject win32_logicaldisk | Where-Object {$_.volumename -eq "AuditLogFiles"}).DeviceID
$Path = $Drive +"\windows22\System32\Winevt\Logs\"
New-Item -Path $Path -ItemType directory -Force
 
Limit-EventLog -LogName Security -MaximumSize 1000MB

$SecurityPath = $Path+'Security.evtx'
Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\EventLog\Security" -Name "File" -Value $SecurityPath