 # Data Lake items
$foldertoupload = "H:\TPC-H Toolkit\2.17.3\dbgen"
$destinationDataLakeAccount = "pankajcsa"
$dataLakeFolder = "/DataFiles/tpc-h_500gb/" 

# Login Items
$tenantID = "72f988bf-86f1-41af-91ab-2d7cd011db47"
$AuthKey = "jKOZ8oUHB+pyAdb6sd8E61zFzGSA8ME7HXtSF6Bm+4Q="
$AppId = "4c42aac1-51ff-4b07-8c93-6cb8d9fee076" #ID FOR YETANOTHERTEST

# Login an select subscription
$secpasswd = ConvertTo-SecureString $AuthKey -AsPlainText -Force
$mycreds = New-Object System.Management.Automation.PSCredential ($AppId, $secpasswd)
Login-AzureRmAccount -ServicePrincipal -Tenant $tenantID  -Credential $mycreds
#Select-AzureRmSubscription -SubscriptionId $subscriptionId
 
#Upload and entire folder
Import-AzureRmDataLakeStoreItem -AccountName $destinationDataLakeAccount -Path $foldertoupload -Destination $dataLakeFolder -Force


#Upload certain files in a folder

$files = Get-ChildItem $foldertoupload\* -Include *.tbl 
foreach ($file in $files)
{
    $dataLakePath = "$datalakeFolder$file" 
    $write =  "BEGIN Upload: " + $file
    Write-Output $write
    Import-AzureRmDataLakeStoreItem -AccountName $destinationDataLakeAccount -Path $file.FullName -Destination $dataLakePath -Force
    $write =  "END   Upload: " + $file
    Write-Output $write
}

Import-AzureRmDataLakeStoreItem -AccountName $destinationDataLakeAccount -Path 'H:\TPC-H Toolkit\2.17.3\dbgen\lineitem.tbl' -Destination $dataLakePath -Force

