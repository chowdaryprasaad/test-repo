#$array = @()
$storageAccount = Get-AzStorageAccount -Name test1stoagra -ResourceGroupName prod-rg-01
#foreach ($storageAccount in Get-AzStorageAccount) 
#{
$data = @()
$file = @()
$storageAccountName = $storageAccount.StorageAccountName
$resourceGroupName = $storageAccount.ResourceGroupName
$storageAccountKey = (Get-AzStorageAccountKey -Name $storageAccountName -ResourceGroupName $resourceGroupName).Value[0]
$storagecontext = New-AzStorageContext -StorageAccountName $storageAccountName -StorageAccountKey $storageAccountKey

$containers = Get-AzStorageContainer -Context $storagecontext

$FileShares = Get-AzStorageShare -Context $storagecontext

    foreach($container in $containers){
        $obj = new-object psobject -Property @{
        StorageAccount = $storageAccountName
        ContainerName = $($container.name)
        lastModified = $($container.lastmodified.date)
        }
    $data+=$obj
    }
    foreach($fileshare in $FileShares){
        $obj2 = new-object psobject -Property @{
        StorageAccount = $storageAccountName
        FileShareName= $($fileshare.name)
        lastModified = $($fileshare.lastmodified.date)
        }
    $file+=$obj2

    $data
    $file
}


<#
$obj3 = new-object psobject -Property @{
       # StorageAccountf = $storageAccountName
        FileShareNamef = $file | where {$_.storageaccount -eq $storageAccountName} | select $storageaccount, $($fileshare.name), $($fileshare.lastmodified.date)
        #lastModifiedff = $($fileshare.lastmodified.date)
        #ContainerNamef = $($container.name)
        #lastModifiedcf = $($container.lastmodified.date)
        }
   $array+=$obj3     
}
$array #| select StorageAccountf, ContainerNamef, lastModifiedcf, FileShareNamef, lastModifiedff | ft -AutoSize


#>

