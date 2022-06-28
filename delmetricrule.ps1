$Input = Import-Csv -Path C:\temp\sub1.csv 
$num = 0
foreach($Item in $Input){
$num++
write-host "`n"
write-host "`n"
Write-host "$num ***************************************************************************"
Write-host ($item).name
Write-host "$num ***************************************************************************"
#Remove-AzMetricAlertRuleV2 -ResourceId $Item.ResourceID -Verbose
}